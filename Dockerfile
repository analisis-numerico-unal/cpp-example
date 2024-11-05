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
echo -e "\n🔍 Comandos útiles:" \n\
echo "   • notebook : Iniciar Jupyter Notebook" \n\
echo "   • python : Iniciar Python" \n\
echo "   • cpp-compile : Compilar con optimizaciones" \n\
echo "=================================================" \n\
fortune | cowsay\n\
echo "=================================================" \n\
' > /usr/local/bin/welcome-message && chmod +x /usr/local/bin/welcome-message

# Create compilation script
RUN echo '#!/bin/bash\n\
g++ -Wall -Wextra -O2 -march=native -ftree-vectorize "$@"\n\
' > /usr/local/bin/cpp-compile && chmod +x /usr/local/bin/cpp-compile

# Configure shell
RUN echo 'PS1="\[\033[38;5;14m\][\[$(tput sgr0)\]\[\033[38;5;9m\]\u\[$(tput sgr0)\]\[\033[38;5;14m\]@\[$(tput sgr0)\]\[\033[38;5;13m\]\h\[$(tput sgr0)\]\[\033[38;5;14m\]]\[$(tput sgr0)\]\[\033[38;5;10m\]\w\[$(tput sgr0)\]\n\\$ \[$(tput sgr0)\]"' >> /etc/bash.bashrc

# Set welcome message on startup
RUN echo '/usr/local/bin/welcome-message' >> /etc/bash.bashrc

# Add useful aliases
RUN echo 'alias ll="ls -la"\n\
alias g++="g++ -Wall -Wextra -Wpedantic"\n\
alias gc="g++ -Wall -Wextra -Wpedantic -g"\n\
alias gdb="gdb -q"\n\
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