# Directory Overview

This directory contains dotfiles for configuring a development environment on macOS and Linux. It uses `stow` to manage symlinks and `brew` for package management on macOS. The configurations are highly customized for tools like Neovim, Zsh, and tmux.

## Key Files

*   `install.sh`: A script that creates symlinks for all the configuration files. This is an alternative to using `stow`.
*   `Brewfile`: A list of packages to be installed using Homebrew on macOS. This includes command-line tools and GUI applications.
*   `_gitconfig`: Git configuration file.
*   `_gitignore_global`: Global gitignore file.
*   `_tmux.conf`: Configuration file for tmux, a terminal multiplexer.
*   `_zshenv`: Zsh environment file.
*   `config/`: This directory contains configuration files for various applications.
    *   `nvim/`: Neovim configuration, using Lua and the `lazy.nvim` plugin manager.
    *   `zsh/.zshrc`: Zsh shell configuration, using `oh-my-zsh` and many custom aliases and functions.
    *   `kitty/`: Kitty terminal emulator configuration.
    *   `aerospace/`: Aerospace window manager configuration for macOS.
    *   `bat/`: Bat (a `cat` clone with syntax highlighting) configuration.
    *   `btop/`: btop (a resource monitor) configuration.
    *   `hypr/`: Hyprland (a dynamic tiling Wayland compositor) configuration for Linux.
    *   `mise/`: Mise (a tool for managing project-specific development environments) configuration.
    *   `tmuxinator/`: Tmuxinator (a tool for managing tmux sessions) configuration.
*   `system/macos/setup..sh`: A script for setting up macOS specific settings.
*   `vscode/`: Visual Studio Code settings and keybindings.

## Usage

These dotfiles are used to set up a consistent development environment across multiple machines. The `install.sh` script can be used to create the necessary symlinks. The `Brewfile` can be used with `brew bundle` to install all the necessary packages on macOS.

The user's workflow seems to be heavily based on the terminal, using tools like Neovim, tmux, and Zsh with many customizations.

## Summary of Findings by Codebase Investigator

This repository contains dotfiles for configuring a development environment on macOS and Linux. It uses `stow` or an `install.sh` script to manage symlinks for applications like Zsh, Kitty, Neovim, and VS Code. The setup also includes system-level customizations for macOS and Linux.