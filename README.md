# .dotfiles

This repo contains the configuration to setup my machines. This is using [Chezmoi](https://chezmoi.io), the dotfile manager to setup the install.

## How to run

1. Install homebrew

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install Chezmoi

```shell
brew install chezmoi
```

> zsh as well for linux

3. Init Chezmoi

```shell
chezmoi init https://github.com/vivalareda/.dotfiles.git
```
