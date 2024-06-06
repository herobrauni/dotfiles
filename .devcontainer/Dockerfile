# Use the official Arch Linux base image
FROM archlinux:latest

# Install essential packages
RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm --needed python git zsh curl unzip wget base-devel rust

# Set Zsh as the default shell
SHELL ["/usr/bin/zsh", "-c"]

RUN useradd -ms /usr/bin/zsh devuser && echo "devuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set the default shell for the user
RUN chsh -s /usr/bin/zsh devuser

USER devuser
WORKDIR /home/devuser

RUN git clone https://aur.archlinux.org/yay-bin.git
WORKDIR /home/devuser/yay-bin
RUN makepkg -si --noconfirm

RUN yay -S --noconfirm flux-bin helm terraform kubectl chezmoi

# Apply dotfiles using Chezmoi
RUN chezmoi init --apply https://github.com/herodevuser/dotfiles.git
