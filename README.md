# Satellite Content Lifecycle Automation for AAP

Red Hat Satellite content view best practices, implemented as Ansible playbooks
and packaged as an importable Ansible Automation Platform workflow bundle.

Run one playbook against your AAP instance and you get the credential type,
credentials, execution environment, project, inventories, six job templates
with surveys, three workflows, failure notifications and RBAC — all built from
a single settings file.

The Satellite configuration these playbooks assume is documented in
[`docs/satellite/`](docs/satellite/README.md). Read that first if you are
setting up Satellite from scratch.

---

## What gets created

### Workflows

Three workflows, matching [`Workflows.txt`](Workflows.txt):

```
Satellite - Publishing
  clean emergency CV ──▶ publish all CVs

Satellite - Update Systems
  promote ──▶ [approval] ──▶ errata report ──▶ patch ──┬─▶ errata report
                                                        └─(always)

Satellite - Emergency Publish
  emergency publish ──▶ [approval] ──▶ errata report ──▶ patch ──┬─▶ errata report
                                                                  └─(always)
```

Failures on any workflow send an email via the **Satellite - Workflow Failure**
notification rather than a failure node — the controller delivers it even when
the execution environment cannot start at all.

The approval gate is on by default (`sat_require_patch_approval`). Turn it off
and the node is removed from the graph entirely.

### Job templates

| Template | Playbook | Inventory |
| -------- | -------- | --------- |
| Publish Content Views | `playbooks/publish_content_views.yml` | Control |
| Promote Content Views | `playbooks/promote_content_views.yml` | Control |
| Emergency Publish | `playbooks/emergency_publish.yml` | Control |
| Clean Emergency Content View | `playbooks/clean_emergency.yml` | Control |
| Report Installable Errata | `playbooks/report_errata.yml` | Clients |
| Update Systems | `playbooks/update_systems.yml` | Clients |

---

## Importing into your environment

### 1. Prerequisites

- AAP 2.4 or later, with an admin account
- A Satellite 6 account with content view and errata permissions
- A container registry you can push an execution environment to

### 2. Build and push the execution environment

```bash
cd execution-environment
ansible-builder build -f execution-environment.yml -t satellite-workflow-ee:1.0.0
podman tag satellite-workflow-ee:1.0.0 quay.io/yourorg/satellite-workflow-ee:1.0.0
podman push quay.io/yourorg/satellite-workflow-ee:1.0.0
```

This bakes in `redhat.satellite`, `community.general` and the `jmespath`
library the `json_query` filters depend on.

### 3. Edit one file

Everything customer-specific lives in [`aap_config/defaults.yml`](aap_config/defaults.yml):
your Satellite URL and organization, lifecycle environment names, the content
view model, the git URL of your fork, the EE image, and alert recipients.

### 4. Apply it

```bash
ansible-galaxy collection install -r collections/requirements.yml

export CONTROLLER_HOST=https://aap.example.com
export CONTROLLER_USERNAME=admin
export CONTROLLER_PASSWORD='...'
export SATELLITE_USERNAME=admin
export SATELLITE_PASSWORD='...'

ansible-playbook playbooks/configure_aap.yml
```

Idempotent — re-run it after any change to `defaults.yml`. Add `--check` to
preview.

### 5. Finish the two credentials AAP cannot fill in

- **Satellite - Client SSH** — the key used to reach your RHEL hosts
- **Satellite - Inventory Source** — the Red Hat Satellite 6 credential used by
  dynamic inventory

Both are created with `state: exists`, so re-running the bundle never
overwrites what you put there.

### 6. Sync and launch

Sync the **Satellite - Clients** inventory source, then launch
**Satellite - Publishing**.

---

## How variables are sourced

The original `extra_vars.yaml` files annotated each variable with its intended
source. Those annotations map onto three AAP mechanisms:

| Annotation | Mechanism | Example |
| ---------- | --------- | ------- |
| `# Ansible Vault` | Custom credential type | `satellite_password` |
| `# Static Variable` | Job template `extra_vars` from `defaults.yml` | `satellite_organization` |
| `# Input` | Survey question | `lifecycle_environment` |

Using a credential type rather than a vaulted file is what makes this bundle
safe to share: no vault password to distribute, and no secret ever enters git.
The injected variable names match what the playbooks already read, so the
playbooks work unchanged whether run from AAP or from a workstation.

For workstation runs, copy [`vars/satellite_example.yml`](vars/satellite_example.yml)
to `vars/satellite.local.yml` (gitignored) and pass it with `-e @`.

---

## Why two inventories

**Satellite - Control** holds a single `localhost` entry. The content view
playbooks drive the Satellite REST API, so they need somewhere to execute, not
SSH access to the Satellite server. Keeping this to one host is what guarantees
each content view is published once — pointing these playbooks at a client
inventory would publish every content view once per client.

**Satellite - Clients** is sourced from Satellite itself, so host groups and
host collections stay authoritative. This is what makes the HA patch-group
pattern in [`docs/satellite/patching.md`](docs/satellite/patching.md) work as a
`limit` at launch:

```text
foreman_hostgroup_general_department1_app1_dev:&foreman_host_collection_patch_group_1
```

`report_errata.yml` runs against the client inventory because errata are
per-host, but every task is an API call — it sets `connection: local` and never
opens an SSH session.

---

## Repository layout

```
aap_config/          Config-as-code. defaults.yml is the only file to edit.
  surveys/           Survey definitions, templated from defaults.yml
collections/         requirements.yml — AAP reads ONLY this path
docs/satellite/      Satellite configuration guidance
execution-environment/
inventories/
playbooks/           One playbook per job template, plus configure_aap.yml
roles/
vars/                Example variables for workstation runs
```

---

## Known gaps

Tracked for the playbook-hardening stage; the restructure deliberately left
playbook logic alone apart from inventory scoping.

- **`update_systems.yml` sets `gather_facts: false`** but the `reboot: least`
  path reads `ansible_facts['distribution_major_version']`. That path fails
  with an undefined variable until facts are gathered.
- **`distribution_major_version` is compared to integers** in
  `roles/satellite_restart_least`, which raises a `TypeError` on Python 3.
- **`publish_content_views.yml` never checks whether its async publishes
  succeeded** — the two `# Check if async tasks passed` comments mark work that
  was never written. `async_status` with `until: finished` reports success even
  when the publish itself failed, so a broken content view can be promoted by
  the next workflow node. This is the highest-priority fix: it defeats the
  success/failure branching the workflows rely on.
- **Errata reports end in a bare `debug`.** Nothing is persisted, so the
  "store in whatever location is appropriate" step in `Workflows.txt` is not
  yet implemented. `set_stats` is the intended mechanism, which would also let
  the closing report diff against the opening one.
- **`promote_content_views.yml` derives the source environment from
  `.prior.name`**, which is null when promoting out of Library.
- Modules are not consistently FQCN, so the repo will not pass a strict
  `ansible-lint` profile.

### Collection versions

`collections/requirements.yml` uses `>=` floors so the bundle imports cleanly
into most environments. Pin exact versions before promoting to production.

### infra.aap_configuration naming

The CaC files use the long-established `controller_*` variable names
(`controller_templates`, `controller_workflows`, …). Some AAP 2.5-era releases
of `infra.aap_configuration` prefer `aap_*` aliases for gateway-managed objects.
If the dispatch role reports nothing to do, check which naming your installed
version expects. `playbooks/configure_aap.yml` already sets both the
`aap_*` and `controller_*` connection variables for this reason.
