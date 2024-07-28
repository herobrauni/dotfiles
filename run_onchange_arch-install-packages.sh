#!/bin/bash
ID=$(grep -oP '(?<=^ID=).+' /etc/os-release | tr -d '"')
ID_LIKE=$(grep -oP '(?<=^ID_LIKE=).+' /etc/os-release | tr -d '"')

if [[ $ID == *"arch"* ]] || [[ $ID_LIKE == "arch" ]]; then
  if command -v paru &> /dev/null; then
    paru -S --noconfirm git zsh oh-my-zsh-git zsh-antidote btop htop fastfetch
  fi
fi
