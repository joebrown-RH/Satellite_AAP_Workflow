# Instructions to configure the internal Red Hat Demo
1. Deploy [Ansible Workshop - Automated Satellite Workshop]
1. Copy `values.yaml.example` to `values.yaml` and fill in the fields
1. Run `ansible-playbook cleanup/cleanup.yaml`
1. Run `ansible-playbook setup/satellite.yaml`
1. Run `ansible-playbook setup/aap.yaml`
