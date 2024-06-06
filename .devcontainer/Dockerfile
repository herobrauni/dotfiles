# Use the official Arch Linux base image
FROM archlinux:latest

# Install essential packages
RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm --needed python git zsh curl unzip wget base-devel

# Set Zsh as the default shell
SHELL ["/usr/bin/zsh", "-c"]

# Create a non-root user (optional but recommended)
ARG USERNAME=devuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $USERNAME
WORKDIR /home/$USERNAME

RUN git clone https://aur.archlinux.org/paru.git
RUN cd paru
RUN makepkg -si

RUN paru -S --noconfirm flux-bin helm opentofu kubectl chezmoi

# Apply dotfiles using Chezmoi
RUN chezmoi init --apply https://github.com/herobrauni/dotfiles.git

# Set the default shell for the user
RUN chsh -s $(which zsh) $USERNAME

