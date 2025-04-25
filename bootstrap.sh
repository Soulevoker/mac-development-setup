#!/bin/bash

echo "=== Bootstrapping Mac Studio Setup (Linux Test) ==="

# Install Python and Ansible
echo "Installing Python and Ansible..."
sudo apt update
sudo apt install -y python3 python3-pip
pip3 install ansible

# Run the Ansible playbook
echo "Running Ansible playbook..."
ansible-playbook -i "localhost," -c local "$(pwd)/playbook.yml"

echo "=== Setup Complete! ==="
