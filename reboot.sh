#!/bin/bash

ansible-playbook -i inventory/hosts.ini playbooks/reboot.yml
