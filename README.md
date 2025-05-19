# Tundra

A comprehensive NixOS, Home Manager, and Nix Darwin configuration system for managing multiple machines with a unified configuration approach.

![NixOS](https://img.shields.io/badge/NixOS-5277C3?style=for-the-badge&logo=nixos&logoColor=white)
![Nix](https://img.shields.io/badge/Nix-5277C3?style=for-the-badge&logo=NixOS&logoColor=white)
![Home Manager](https://img.shields.io/badge/Home_Manager-5277C3?style=for-the-badge&logo=nixos&logoColor=white)

## Overview

Tundra is a Nix flake-based configuration system that provides:

- Multi-host management for various machines (desktop, laptop, VPS, etc.)
- Comprehensive Home Manager configurations for consistent user environments
- Modular design for easy customization and extension
- Support for both NixOS and macOS (via nix-darwin)
- Secure configuration with sops-nix for secrets management
- Hyprland and GNOME desktop environment configurations
- Extensive CLI and desktop application configurations

## Features

### System Management

- **Multi-host Support**: Configurations for different machines (desktop, laptop, VPS, etc.)
- **Disk Management**: Uses [disko](https://github.com/nix-community/disko) for declarative disk partitioning
- **Boot Security**: Integration with [lanzaboote](https://github.com/nix-community/lanzaboote) for secure boot
- **Impermanence**: Support for [impermanence](https://github.com/nix-community/impermanence) for stateless systems
- **Secrets Management**: [sops-nix](https://github.com/mic92/sops-nix) for encrypted secrets

### Desktop Environments

- **Hyprland**: Comprehensive Wayland compositor setup with:
  - Waybar configuration
  - Hyprpaper for wallpapers
  - Hyprlock for screen locking
  - Hypridle for idle management
  - Dunst for notifications
  - Rofi for application launching
  - wlogout for session management
  - wlsunset for blue light filtering
- **GNOME**: Alternative desktop environment configuration

### CLI Environment

- **Shell**: ZSH configuration with plugins and customizations
- **Editors**: 
  - Custom Neovim configuration via [cnvim](https://github.com/conorhk/vimrc)
- **Multiplexers**: 
  - tmux configuration
  - zellij configuration with auto-lock
- **CLI Tools**:
  - atuin - shell history management
  - bat - better cat
  - btop - system monitor
  - comma - run commands without installing
  - duf - disk usage
  - dust - file size analyzer
  - eza - better ls
  - fzf - fuzzy finder
  - git - version control
  - gpg - encryption
  - htop - process viewer
  - jq - JSON processor
  - networking tools
  - ripgrep - better grep
  - script-directory - script management
  - zoxide - smarter cd

### Desktop Applications

- **Terminal**: Alacritty
- **Browser**: Firefox with customizations
- **Communication**: Discord via nixcord
- **Media**: Spotify with spicetify customizations

### Styling

- **Stylix**: Consistent theming across applications
- **Fonts**: Custom fonts including Apple fonts and Creeper

## Supported Platforms

- **Linux**: x86_64-linux
- **macOS**: aarch64-darwin

## Getting Started

### Prerequisites

- Nix package manager installed
- Sufficient disk space for Nix store
- Git

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/conorhk/tundra.git
   cd tundra
   ```

2. Enter the development shell:
   ```bash
   # Using nix-shell
   nix-shell
   
   # Or using nix command with flakes
   nix --extra-experimental-features 'nix-command flakes' develop
   ```

3. Apply the configuration:
   ```bash
   # For NixOS systems
   nh os switch .
   
   # For Home Manager only
   nh home switch .
   ```

### Disk Installation (NixOS)

For a fresh NixOS installation with disk partitioning:

```bash
./install.sh /path/to/flake/config /dev/disk
```

## Structure

```
nix/
├── hosts/                  # Host-specific configurations
│   ├── desktop/            # Desktop configuration
│   ├── laptop/             # Laptop configuration
│   ├── vps/                # VPS configuration
│   └── ...                 # Other hosts
├── modules/                # Shared configuration modules
│   ├── home/               # Home Manager modules
│   │   ├── cli/            # CLI tools and configurations
│   │   ├── desktop/        # Desktop environments and applications
│   │   ├── styles/         # Theming and styling
│   │   └── system/         # System-level home configurations
│   └── nixos/              # NixOS modules
│       ├── desktop/        # Desktop environments
│       ├── hardware/       # Hardware configurations
│       ├── security/       # Security settings
│       ├── services/       # System services
│       ├── styles/         # System-wide styling
│       └── system/         # Core system configuration
└── packages/               # Custom packages
    ├── creeper/            # Creeper font package
    ├── wallpapers/         # Wallpaper collection
    └── zellij-autolock/    # Custom zellij autolock package
```

## Customization

### Adding a New Host

1. Create a new directory under `nix/hosts/`:
   ```bash
   mkdir -p nix/hosts/new-host/users
   ```

2. Create the necessary configuration files:
   ```bash
   touch nix/hosts/new-host/default.nix
   touch nix/hosts/new-host/hardware-configuration.nix
   touch nix/hosts/new-host/users/your-username.nix
   ```

3. Import the required modules and customize as needed.

### Adding New Modules

1. Create a new module directory:
   ```bash
   mkdir -p nix/modules/home/cli/programs/new-program
   ```

2. Create the module configuration:
   ```bash
   touch nix/modules/home/cli/programs/new-program/default.nix
   ```

3. Import the module in your host or user configuration.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the [MIT License](LICENSE).
