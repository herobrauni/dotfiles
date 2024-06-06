# Use the official Arch Linux base image
FROM archlinux:latest

# Install essential packages
RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm --needed python git zsh curl unzip wget base-devel rust

# Set Zsh as the default shell
SHELL ["/usr/bin/zsh", "-c"]

RUN useradd -ms /usr/bin/zsh brauni && echo "brauni ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER brauni
WORKDIR /home/brauni

RUN git clone https://aur.archlinux.org/paru.git
WORKDIR /home/brauni/paru
RUN makepkg -si

RUN paru -S --noconfirm flux-bin helm opentofu kubectl chezmoi

# Apply dotfiles using Chezmoi
RUN chezmoi init --apply https://github.com/herobrauni/dotfiles.git

# Set the default shell for the user
RUN chsh -s $(which zsh) brauni

