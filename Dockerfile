FROM archlinux:base-devel

# Update system and add extra repositories if needed
RUN pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -Syu --noconfirm

# Install basic development tools first
RUN pacman -S --noconfirm \
    base-devel \
    git \
    cmake \
    gcc \
    make \
    wget \
    curl

# Install Python and core scientific packages
RUN pacman -S --noconfirm \
    python \
    python-pip \
    python-numpy \
    python-scipy \
    python-matplotlib \
    python-pandas \
    python-sympy \
    jupyter-notebook

# Install development tools
RUN pacman -S --noconfirm \
    gdb \
    clang \
    llvm \
    valgrind \
    doxygen \
    graphviz \
    nodejs \
    npm

# Install editors
RUN pacman -S --noconfirm \
    vim \
    neovim \
    nano

# Install system utilities
RUN pacman -S --noconfirm \
    man-pages \
    man-db \
    bash-completion \
    zsh \
    htop \
    tree \
    ripgrep \
    fzf \
    fd \
    bat

# Install terminal customization tools
RUN pacman -S --noconfirm \
    cowsay \
    fortune-mod

# Setup Python virtual environment
RUN python -m venv /opt/venv && \
    source /opt/venv/bin/activate && \
    pip install --upgrade pip && \
    pip install \
        ipykernel \
        notebook \
        plotly \
        seaborn \
        scikit-learn \
        cmake-format \
        conan \
        cppcheck \
        compdb \
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
echo "   • Herramientas de visualización" \n\
echo -e "\n🔍 Comandos útiles:" \n\
echo "   • notebook : Iniciar Jupyter Notebook" \n\
echo "   • python : Iniciar Python" \n\
echo "   • cpp-compile : Compilar con optimizaciones" \n\
echo "=================================================" \n\
if command -v fortune > /dev/null && command -v cowsay > /dev/null; then\n\
    fortune | cowsay\n\
fi\n\
echo "=================================================" \n\
' > /usr/local/bin/welcome-message && chmod +x /usr/local/bin/welcome-message

# Create helper scripts
RUN echo '#!/bin/bash\n\
echo -e "Ejemplos de gráficas con Python:\n"\n\
echo "1. Matplotlib básico:"\n\
echo "python -c \"import matplotlib.pyplot as plt; import numpy as np; x = np.linspace(-5,5,100); plt.plot(x, np.sin(x)); plt.show()\""\n\
' > /usr/local/bin/plot-help && chmod +x /usr/local/bin/plot-help

# Create optimized compilation script
RUN echo '#!/bin/bash\n\
g++ -Wall -Wextra -O2 -march=native -ftree-vectorize "$@"\n\
' > /usr/local/bin/cpp-compile && chmod +x /usr/local/bin/cpp-compile

# Configure shell prompt
RUN echo 'PS1="\[\033[38;5;14m\][\[$(tput sgr0)\]\[\033[38;5;9m\]\u\[$(tput sgr0)\]\[\033[38;5;14m\]@\[$(tput sgr0)\]\[\033[38;5;13m\]\h\[$(tput sgr0)\]\[\033[38;5;14m\]]\[$(tput sgr0)\]\[\033[38;5;10m\]\w\[$(tput sgr0)\]\n\\$ \[$(tput sgr0)\]"' >> /etc/bash.bashrc

# Set welcome message on startup
RUN echo '/usr/local/bin/welcome-message' >> /etc/bash.bashrc

# Add useful aliases
RUN echo 'alias ll="ls -la"\n\
alias g++="g++ -Wall -Wextra -Wpedantic"\n\
alias gc="g++ -Wall -Wextra -Wpedantic -g"\n\
alias gdb="gdb -q"\n\
alias cmake="cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"\n\
alias make="make -j$(nproc)"\n\
alias python="python3"\n\
alias pip="pip3"\n\
alias notebook="jupyter notebook --ip=0.0.0.0 --allow-root"\n\
source /opt/venv/bin/activate\n\
' >> /etc/bash.bashrc

# Clean up
RUN pacman -Scc --noconfirm && \
    rm -rf /var/cache/pacman/pkg/*

# Set working directory
WORKDIR /workspace