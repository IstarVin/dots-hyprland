# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**illogical-impulse** is a comprehensive Hyprland dotfiles configuration featuring a custom QtQuick-based widget system built on Quickshell. The project provides a Material Design-inspired desktop environment with features like AI integration (Gemini/Ollama), auto-generated wallpaper-based color schemes, window overview with live previews, and extensive customization options.

Documentation: https://ii.clsty.link

## Installation & Setup Commands

### Main Installation
```bash
./setup install              # Full (re)install or update
./setup install-deps         # Install dependencies only
./setup install-setups       # Run setup for permissions/services
./setup install-files        # Copy config files only
./setup install --symlink    # Install using symlinks (for development)
```

### Update & Maintenance
```bash
./setup exp-update           # Experimental update without full reinstall
./setup exp-uninstall        # Experimental uninstall
./setup resetfirstrun        # Reset first-run state
```

### Development & Diagnostics
```bash
./diagnose                   # Generate diagnostic report (outputs to diagnose.result)
./setup virtmon              # Create virtual monitors for testing
./setup checkdeps            # Check package availability in Arch repos/AUR
```

### Running Quickshell During Development
```bash
pkill qs; qs -c ii           # Kill and restart Quickshell with ii config (shows logs in terminal)
```

## Repository Structure

### Core Directories
- `dots/.config/` - User configuration files that get copied to `~/.config/`
  - `hypr/` - Hyprland compositor configuration
    - `hyprland.conf` - Main config that sources from `hyprland/` and `custom/` subdirectories
    - `hyprland/` - Default configuration files (env, execs, general, rules, colors, keybinds)
    - `custom/` - User customizations (preferred location for adding personal config)
  - `quickshell/ii/` - Quickshell widget system (QtQuick/QML-based)
    - `shell.qml` - Main shell entry point
    - `modules/` - Widget modules (bar, dock, overview, sidebars, etc.)
    - `services/` - Background services and integrations
    - `scripts/` - Helper scripts (colors, images, etc.)
    - `translations/` - i18n translation files
- `dots/.local/` - Additional user files
- `sdata/` - Setup script data and distribution-specific packages
  - `lib/` - Shared bash functions and utilities
  - `dist-arch/` - Arch Linux packages (PKGBUILDs for meta packages and custom builds)
  - `dist-fedora/`, `dist-gentoo/`, `dist-nix/` - Other distribution support
  - `subcmd-*/` - Subcommand implementations for `./setup`
  - `uv/` - Python virtual environment configuration (requirements.in/txt)

### Key Files
- `setup` - Main installation/setup script (bash)
- `diagnose` - Diagnostic information generator
- `.gitmodules` - Git submodule for rounded-polygon-qmljs

## Architecture & Design

### Multi-Layer Configuration System
1. **Hyprland Layer**: Window manager configuration split into modular files (env, general, keybinds, rules, colors, execs)
2. **Quickshell Layer**: QtQuick-based widget system with module-based architecture
3. **Services Layer**: Background services for colors (matugen), theming, AI, etc.
4. **Custom Layer**: User overrides in `custom/` directories take precedence

### Quickshell Widget Architecture
- **Module System**: Each widget is a self-contained module in `modules/ii/` (bar, dock, overview, sidebars, etc.)
- **Dynamic Loading**: Uses QML `Loader` components for conditional/lazy loading of features
- **Service Integration**: Singletons provide shared state (MaterialThemeLoader, Hyprsunset, FirstRunExperience, etc.)
- **Multi-Monitor**: Designed with multi-monitor support throughout

### Python Environment
- All Python dependencies managed via `uv` in a virtual environment
- Location: `$ILLOGICAL_IMPULSE_VIRTUAL_ENV` (default: `~/.local/state/quickshell/.venv`)
- Add packages: Edit `sdata/uv/requirements.in`, then run `uv pip compile requirements.in -o requirements.txt`
- Usage in scripts: Activate with `source $(eval echo $ILLOGICAL_IMPULSE_VIRTUAL_ENV)/bin/activate`
- See `sdata/uv/README.md` for detailed usage patterns

### Color Generation System
- Auto-generates Material Design 3 colors from wallpaper using matugen
- Applied across Hyprland, Quickshell, Qt apps, GTK apps, KDE apps
- Scripts in `dots/.config/quickshell/ii/scripts/colors/`

## Development Workflow

### Using Symlinks for Development

For active development, use symlinks instead of copying files. This keeps your repo and configs in sync:

```bash
./setup install --symlink
```

**What it does:**
- Creates symlinks from `~/.config/*` to the repo's `dots/.config/*`
- Changes in either location are immediately reflected in both
- Makes it easy to test, commit, and push changes
- Main config files (hyprland.conf, monitors.conf) are copied once for user customization
- The modular `hyprland/` directory is symlinked for live updates

**Important notes:**
- Backup existing configs first (the script will auto-backup with timestamps)
- The `custom/` directory remains separate for your personal overrides
- Root config files like `hyprland.conf` are initially copied, not symlinked, allowing customization

### Quickshell Development Setup
1. Install Hyprland and `quickshell-git`: `yay -S hyprland quickshell-git`
2. Copy `dots/.config/quickshell` to `~/.config/`
3. Create LSP config: `touch ~/.config/quickshell/ii/.qmlls.ini`
4. For VSCode: Install "Qt Qml" extension, set custom exe path to `/usr/bin/qmlls6`
5. Launch Hyprland (non-uwsm version)
6. Run `pkill qs; qs -c ii` in terminal to see live logs
7. Edit QML files - changes reload live

### Contributing Guidelines (from .github/CONTRIBUTING.md)
- Create separate PRs for different features/fixes
- Don't include personal configuration changes in PRs
- Features not universally wanted should be configurable/optional
- For large contributions, ask first to avoid wasted effort
- Use `Loader` for conditional features
- Ensure changes don't harm performance or usability
- Fancy but impractical features should be disabled by default

### Translation (i18n)
See `dots/.config/quickshell/ii/translations/tools` for contributing translations

## Package Management

### Arch Linux Package Structure
The project provides meta-packages in `sdata/dist-arch/`:
- `illogical-impulse-audio` - Audio utilities (cava, pavucontrol-qt, playerctl)
- `illogical-impulse-backlight` - Brightness control (brightnessctl, ddcutil, geoclue)
- `illogical-impulse-basic` - Core utilities (bc, curl, jq, ripgrep, rsync, go-yq, cliphist)
- `illogical-impulse-fonts-themes` - Fonts and themes (Material Symbols, Roboto Flex, etc.)
- `illogical-impulse-hyprland` - Hyprland and related tools
- `illogical-impulse-kde` - KDE integration (dolphin, polkit-kde-agent, systemsettings)
- `illogical-impulse-portal` - XDG portals
- `illogical-impulse-python` - Python dependencies (uv, gtk4, libadwaita, etc.)
- `illogical-impulse-screencapture` - Screenshot/recording tools (hyprshot, slurp, swappy, tesseract)
- `illogical-impulse-widgets` - Widget system dependencies (fuzzel, hypridle, hyprlock, etc.)
- `illogical-impulse-quickshell-git` - Pinned Quickshell build with Qt6 dependencies
- `illogical-impulse-microtex-git` - LaTeX rendering library
- Custom packages for specific resources (icons, cursors)

See `sdata/deps-info.md` for detailed dependency explanations.

## Important Patterns

### Adding New Hyprland Configuration
- User customizations go in `dots/.config/hypr/custom/` (NOT in `hyprland/` directory)
- Custom files are sourced after defaults, allowing overrides

### Working with QML/Quickshell
- Positioning properties (like `anchors`) sometimes need to be in `Loader`, not `sourceComponent`
- Environment variables set via `//@ pragma Env` at top of shell.qml
- Scale factor: `//@ pragma Env QT_SCALE_FACTOR=1`

### Using Python Scripts
- All Python scripts should use the virtual environment
- For shebangs: `#!/usr/bin/env python3`
- Wrapper pattern: Create bash wrapper that activates venv before calling script
- See `sdata/uv/README.md` for complete patterns

### Submodules
- `dots/.config/quickshell/ii/modules/common/widgets/shapes` is a git submodule
- Remember to initialize: `git submodule update --init --recursive`

## Distribution Support

Primary support: Arch Linux (and Arch-based distributions)
Experimental/community support: Fedora, Gentoo, NixOS

Distribution-specific code lives in `sdata/dist-*/` directories.

## Default Keybinds

- `Super + /` - Show keybind list
- `Super + Enter` - Terminal
- See screenshot in .github/README.md for full visual keybind reference

## Notes

- The widget system is **Quickshell** (not Waybar, not AGS anymore - AGS version is in `ii-ags` branch)
- Installation script (`./setup`) is transparent - shows every command before running
- The `v()` and `x()` functions in setup scripts provide interactive error handling
- Discord: https://discord.gg/GtdRBXgMwq (for support, prefer GitHub issues for bugs)
