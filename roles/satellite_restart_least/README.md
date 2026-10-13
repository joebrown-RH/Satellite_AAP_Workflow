# satellite_restart_least

Works out the least disruptive restart action a RHEL host needs after patching
and performs it:

| Condition | Action |
| --------- | ------ |
| Kernel / core library updated | Full `reboot` |
| Only userspace services affected | `systemctl restart` of just those units |
| Nothing affected | No action |

Used by `playbooks/update_systems.yml` when `reboot: least`.

## Requirements

This role reads `ansible_facts['distribution_major_version']`, so the calling
play must gather facts (or the role must be preceded by a `setup` task).

> **Known issue:** `playbooks/update_systems.yml` currently sets
> `gather_facts: false`, so the `least` path fails on an undefined fact. This is
> tracked for the playbook-hardening stage and is not addressed by the
> restructure work.

## Role Variables

None. The role discovers everything it needs via `needs-restarting`.

## Facts set

| Fact | Description |
| ---- | ----------- |
| `system_restart_required` | Boolean - a full reboot is needed |
| `services_to_restart` | List of systemd units needing a restart |
| `restart_action` | One of `reboot`, `restart_services`, `none` |
