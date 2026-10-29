#!/bin/bash

for action in cleanup setup
do
  for service in satellite aap
  do
    if [[ -f ${action}/${service}.yaml ]]
    then
      ansible-playbook ${action}/${service}.yaml -e @values.yaml
    fi
  done
done

ansible-playbook ../aap_workflows/install.yaml -e @values.yaml
