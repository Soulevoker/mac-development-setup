# Mac Studio Setup

Automated setup for a development Mac Studio using Ansible, chezmoi, Homebrew, and Podman.

## Usage

Run this command on a fresh macOS system:
```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/mac-studio-setup/main/install.sh | bash
```

For non-interactive mode (e.g., CI):
```bash
NONINTERACTIVE=1 curl -fsSL https://raw.githubusercontent.com/yourusername/mac-studio-setup/main/install.sh | bash
```

## Components
- **Homebrew**: Installs packages (zsh, openjdk, podman, jetbrains-toolbox, etc.).
- **Podman**: Container runtime with macOS networking fixes.
- **zsh + Oh My Zsh**: Configured shell.
- **chezmoi**: Manages dotfiles (.zshrc, .gitconfig).
- **JetBrains Toolbox**: Installs IntelliJ IDEA and PyCharm.

## Testing
Test with a new user:
```bash
sudo sysadminctl -addUser testuser -fullName "Test User" -password test123
su - testuser
curl -fsSL https://raw.githubusercontent.com/yourusername/mac-studio-setup/main/install.sh | bash
```
