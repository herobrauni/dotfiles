# Use the official Arch Linux base image
FROM archlinux:latest

# Install essential packages
RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm python git zsh curl unzip

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install Terraform
RUN curl -fsSL https://releases.hashicorp.com/terraform/1.5.2/terraform_1.5.2_linux_amd64.zip -o terraform.zip \
    && unzip terraform.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform.zip

# Install Flux
RUN curl -s https://fluxcd.io/install.sh | bash

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl

# Install Chezmoi
RUN curl -fsSL https://chezmoi.io/get | sh

# Clean up to reduce image size
RUN pacman -Scc --noconfirm

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

# Apply dotfiles using Chezmoi
RUN chezmoi init --apply https://github.com/herobrauni/dotfiles.git

# Set the default shell for the user
RUN chsh -s $(which zsh) $USERNAME

# Copy entrypoint script if available
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
