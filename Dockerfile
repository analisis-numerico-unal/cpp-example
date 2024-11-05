FROM archlinux:base-devel

# Update the system and install packages
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
    npm \
    gcc \
    g++ \
    gdb \
    make \
    cmake

# Clean the cache
RUN pacman -Scc --noconfirm

# Config the workspace
WORKDIR /workspace