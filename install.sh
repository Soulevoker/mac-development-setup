#!/bin/bash

echo "=== Installing Mac Studio Setup ==="

# Fail fast if not bash
if [ -z "${BASH_VERSION:-}" ]; then
  echo "Error: Bash is required to run this script." >&2
  exit 1
fi

# Check for non-interactive mode
if [ -n "${NONINTERACTIVE-}" ]; then
  echo "Running in non-interactive mode."
else
  echo "Running in interactive mode. You may be prompted for input."
fi

# Ensure we're on macOS
if [ "$(uname)" != "Darwin" ]; then
  echo "Error: This script is only supported on macOS." >&2
  exit 1
fi

# Install Xcode Command Line Tools (ensures Git is functional)
echo "Installing Xcode Command Line Tools..."
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install || true
  if [ -n "${NONINTERACTIVE-}" ]; then
    echo "Non-interactive mode: Assuming Command Line Tools are installed or will be manually handled."
  else
    echo "Press any key when the Command Line Tools installation is complete..."
    read -n 1 -s
  fi
fi

# Install Homebrew
echo "Installing Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zshrc
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew already installed."
fi

# Temporary directory for setup
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR" || exit 1

# Clone the repo
echo "Fetching setup from GitHub..."
git clone https://github.com/yourusername/mac-studio-setup.git
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
