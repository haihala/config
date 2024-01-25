# Config

Dungeons, dragons, dotfiles and dives

A bunch of simple scripts and dotfiles I use. Should eventually be able to recreate my preferred linux environment really quicly.

## Setup

1. Run a new-ish fedora workstation
2. `sudo dnf_install.sh`
3. Install [Rust tools](#rust-tools)
4. Install the following (not found in dnf by default)
   1. oh-my-zsh - [link](https://ohmyz.sh/)
   2. nvim - [link](https://github.com/neovim/neovim), A bit of a mystery, may require:
      1. `bob use stable` to install the stable version
      2. `npm` (via `rtx` from [Rust tools](#rust-tools))
      3. Several cycles of `:PackerSync` and restart
   3. swaylock-effects - [link](https://github.com/mortie/swaylock-effects)
      1. Compile by hand to avoid a bug on the lock screen
   4. mpv - [link](https://forums.fedoraforum.org/showthread.php?324163-install-mpv-player-on-fedora32&p=1835826#post1835826)
   5. zsh-autosuggestions - [link](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh)
   6. obsidian - [link](https://obsidian.md/download)
5. Run `./link.sh` from the repository root
   1. You may have to create the `.config` folder in home.
6. Check git email with `git config user.email`
7. Edit crontab to run `bin/cron_battery.sh` (for laptops)
8. Handle ssh keys (See [instructions](#setting-up-ssh-key-magic))
9. Install [tpm](https://github.com/tmux-plugins/tpm)

### Rust tools

Tooling for and by rust.

- Install rust from https://rustup.rs/
- Run `./cargo_install.sh`

## What goes where

- `dotfiles/*` is linked to `$HOME/*`
- `home_config/*` -> `$HOME/.config/*`
- `bin` -> `$HOME/bin`

## Setting up SSH key magic

Requirements:

- Python3
- pip-package pexpect
- gpg

1. Generate an ssh key with a passphrase
2. Generate a gpg key with `gpg --generate-full-key`
3. Put `<path to ssh key> <ssh key passphrase>` in a file
4. Encrypt previous file with `gpg --output ~/.ssh/key_password_vault.asc --encrypt --recipient <email> <path of file from previous step>`
5. Remove `~/.sshagentenv` if it exists
6. `reload`
7. **Remove the file you temporarily had your password in written in plain text**
