FROM archlinux:base-devel

# Update the sistem and install the packages
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
    git \
    base-devel \
    vim \
    nano \
    wget \
    curl \
    python \
    nodejs \
    npm

# Clean the cache and the package files
RUN pacman -Scc --noconfirm

# Config the workspace
WORKDIR /workspace