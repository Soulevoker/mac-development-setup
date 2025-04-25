#!/bin/bash

echo "=== Bootstrapping Mac Studio Setup ==="

# Install Python and Ansible
echo "Installing Python and Ansible..."
brew install python ansible

# Run the Ansible playbook
echo "Running Ansible playbook..."
ansible-playbook -i "localhost," -c local "$(pwd)/playbook.yml"

echo "=== Setup Complete! ==="
