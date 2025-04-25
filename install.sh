#!/bin/bash

echo "=== Installing Mac Studio Setup (Linux Test) ==="

# Fail fast if not bash
if [ -z "${BASH_VERSION:-}" ]; then
  echo "Error: Bash is required to run this script." >&2
  exit 1
fi

# Check for non-interactive mode
if [ -n "${NONINTERACTIVE-}" ]; then
  echo "Running in non-interactive mode."
else
  echo "Running in interactive mode."
fi

# Ensure we're on Linux
if [ "$(uname)" != "Linux" ]; then
  echo "Error: This script is intended for Linux (WSL)." >&2
  exit 1
fi

# Install basic tools (git, curl)
echo "Installing basic tools..."
sudo apt update
sudo apt install -y git curl

# Temporary directory for setup
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR" || exit 1

# Clone the repo
echo "Fetching setup from GitHub..."
git clone https://github.com/Soulevoker/mac-development-setup.git
cd mac-studio-setup || exit 1

# Ensure bootstrap.sh is executable and run it
chmod +x bootstrap.sh
echo "Running bootstrap script..."
./bootstrap.sh

# Clean up
cd /tmp || exit 1
rm -rf "$TEMP_DIR"

echo "=== Installation Complete! ==="
echo "Run 'podman run -it ubuntu bash' to test containers!"
