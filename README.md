change hostname

`hostnamectl hostname WHATEVER`

create and enter distrobox with all tools

`distrobox create -i ghcr.io/herobrauni/boxkit -n archbox`
`distrobox enter archbox`

run stuff in this box

```
chezmoi init herobrauni
chezmoi apply ~/.config/rbw
chezmoi apply
cd ~/.local/share/chezmoi
git remote set-url origin git@github.com:herobrauni/dotfiles
```
