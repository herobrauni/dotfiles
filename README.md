We need brew and flatpaks
flatpak should be installed by default.
install brew:

`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

install rbw and chezmoi:

`brew install rbw chezmoi`

init chezmoi

`chezmoi init herobrauni`

apply rbw config

`chezmoi apply .config/rbw`

apply the rest

`chezmoi apply`

switch chezmoi repo to use ssh

`cd (chezmoi source-path)`

`git remote set-url origin git@github.com:herobrauni/dotfiles`

Set Terminal to Wezterm


