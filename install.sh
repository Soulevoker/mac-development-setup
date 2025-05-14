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

# Check for sudo access
echo "Checking for sudo access (may prompt for password)..."
if ! sudo -v >/dev/null 2>&1; then
  echo "Error: This script requires sudo access. Please run as an admin user." >&2
  exit 1
fi


# Install Xcode Command Line Tools (ensures Git is functional)
echo "Installing Xcode Command Line Tools..."
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install || true
  if [ -n "${NONINTERACTIVE-}" ]; then
    echo "Non-interactive mode: Waiting up to 5 minutes for Command Line Tools..."
    for i in {1..300}; do
      if [ -x "/Library/Developer/CommandLineTools/usr/bin/git" ]; then
        echo "Xcode Command Line Tools installed."
        break
      fi
      sleep 1
    done
    if ! [ -x "/Library/Developer/CommandLineTools/usr/bin/git" ]; then
      echo "Warning: Xcode Command Line Tools not detected after timeout. Proceeding anyway."
    fi
  else
    echo "A GUI prompt should appear to install Xcode Command Line Tools."
    echo "Press any key when the installation is complete..."
    until [ -x "/Library/Developer/CommandLineTools/usr/bin/git" ]; do
      read -n 1 -s
    done
    echo "Xcode Command Line Tools installed."
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
git clone https://github.com/Soulevoker/mac-development-setup.git
cd mac-development-setup || exit 1

# Ensure bootstrap.sh is executable and run it
chmod +x bootstrap.sh
echo "Running bootstrap script..."
if ! ./bootstrap.sh; then
  echo "Error: Bootstrap script failed. Check logs for details." >&2
  cd /tmp || exit 1
  rm -rf "$TEMP_DIR"
  exit 1
fi

# Clean up
cd /tmp || exit 1
rm -rf "$TEMP_DIR"

echo "=== Installation Complete! ==="
echo "Run 'podman run -it ubuntu bash' to test containers!"
