# Client inventory

`playbooks/update_systems.yml` and `playbooks/report_errata.yml` run against the
managed RHEL hosts. **Do not maintain a static file here** - source these hosts
from Satellite itself so host groups, host collections and lifecycle
environments stay authoritative.

## In AAP (recommended)

`aap_config/inventories.yml` creates an inventory named **Satellite Clients**
with an inventory source of type `satellite6`, using the same Satellite
credential as the content-view templates. Host group and host collection
membership arrive as inventory groups, so the HA patch-group passes described in
[`docs/satellite/patching.md`](../../docs/satellite/patching.md) become a simple
`limit` on the job template:

```text
Pass 1   limit: foreman_hostgroup_general_department1_app1_dev:&foreman_host_collection_patch_group_1
```

Scope the source itself with `foreman_search` if a customer wants one inventory
per environment instead of one inventory with a `limit`.

## Outside AAP

Use the `redhat.satellite.foreman` inventory plugin directly:

```yaml
# inventories/clients/foreman.yml
plugin: redhat.satellite.foreman
url: https://satellite.example.com
user: "{{ lookup('env', 'SATELLITE_USERNAME') }}"
password: "{{ lookup('env', 'SATELLITE_PASSWORD') }}"
validate_certs: true
group_prefix: foreman_
want_hostcollections: true
```

Then: `ansible-playbook -i inventories/clients/foreman.yml playbooks/update_systems.yml`
