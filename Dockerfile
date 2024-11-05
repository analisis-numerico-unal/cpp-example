FROM archlinux:base-devel

# Update system and add extra repositories if needed
RUN pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -Syu --noconfirm

# Install basic development tools
RUN pacman -S --noconfirm \
    base-devel \
    git \
    cmake \
    gcc \
    gdb \
    make \
    wget \
    curl \
    python \
    python-pip \
    python-numpy \
    python-scipy \
    python-matplotlib \
    python-pandas \
    python-sympy \
    vim \
    nano \
    man-pages \
    man-db \
    bash-completion \
    htop \
    tree \
    cowsay \
    fortune-mod

# Setup Python environment
RUN python -m venv /opt/venv && \
    source /opt/venv/bin/activate && \
    pip install --upgrade pip && \
    pip install \
        notebook \
        plotly \
        seaborn \
        scikit-learn \
        --break-system-packages

# Add virtual environment to PATH
ENV PATH="/opt/venv/bin:$PATH"

# Configure git
RUN git config --system core.editor "vim" && \
    git config --system color.ui true

# Create welcome message
RUN echo '#!/bin/bash\n\
clear\n\
echo "=================================================" \n\
echo "     Análisis Numérico - UNAL Palmira" \n\
echo "=================================================" \n\
echo -e "\n🔢 Bienvenido al curso de Análisis Numérico\n" \n\
echo -e "📚 Herramientas disponibles:" \n\
echo "   • C++ con bibliotecas numéricas" \n\
echo "   • Python con NumPy, SciPy, Matplotlib" \n\
echo "   • Jupyter Notebooks" \n\
echo "=================================================" \n\
fortune | cowsay\n\
echo "=================================================" \n\
' > /usr/local/bin/welcome-message && chmod +x /usr/local/bin/welcome-message

# Install Mambaforge
RUN wget https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-pypy3-Linux-x86_64.sh && \
    sh Mambaforge-pypy3-Linux-x86_64.sh -b -p /opt/mambaforge && \
    rm Mambaforge-pypy3-Linux-x86_64.sh

# Add Mambaforge to PATH
ENV PATH="/opt/mambaforge/bin:$PATH"

# Create cling environment and install xeus-cling
RUN mamba create -n cling xeus-cling jupyterlab -c conda-forge && \
    mamba clean --all -f -y

# Configure shell
RUN echo 'PS1="\[\033[38;5;14m\][\[$(tput sgr0)\]\[\033[38;5;9m\]\u\[$(tput sgr0)\]\[\033[38;5;14m\]@\[$(tput sgr0)\]\[\033[38;5;13m\]\h\[$(tput sgr0)\]\[\033[38;5;14m\]]\[$(tput sgr0)\]\[\033[38;5;10m\]\w\[$(tput sgr0)\]\n\\$ \[$(tput sgr0)\]"' >> /etc/bash.bashrc

# Set welcome message on startup
RUN echo '/usr/local/bin/welcome-message' >> /etc/bash.bashrc

# Clean up
RUN pacman -Scc --noconfirm && \
    rm -rf /var/cache/pacman/pkg/*

# Set working directory
WORKDIR /workspace