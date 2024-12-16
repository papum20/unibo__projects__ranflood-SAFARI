#!/bin/bash

ansible-playbook -i external_inventory full_playbook.yml --extra-vars "@ansible_variables.yml"