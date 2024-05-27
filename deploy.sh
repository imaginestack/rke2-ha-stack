#!/bin/bash

ansible-galaxy collection install -r ./collections/requirements.yml
ansible-playbook -i inventory/hosts.ini playbooks/site.yml