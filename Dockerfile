FROM archlinux:base-devel

# Update system and install packages
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
    base-devel \
    # Development tools
    git \
    cmake \
    ninja \
    gcc \
    gdb \
    lldb \
    clang \
    llvm \
    make \
    valgrind \
    boost \
    fmt \
    gtest \
    benchmark \
    ccache \
    doxygen \
    graphviz \
    # Python and data science
    python \
    python-pip \
    python-numpy \
    python-scipy \
    python-matplotlib \
    python-pandas \
    python-sympy \
    python-ipykernel \
    python-notebook \
    python-plotly \
    python-seaborn \
    python-scikit-learn \
    python-cmake-build-extension \
    jupyter-notebook \
    # Web development
    nodejs \
    npm \
    # Editors and tools
    vim \
    neovim \
    nano \
    # System utilities
    wget \
    curl \
    man-pages \
    man-db \
    bash-completion \
    zsh \
    htop \
    tree \
    ripgrep \
    fzf \
    fd \
    bat \
    # Terminal customization
    lolcat \
    figlet \
    cowsay \
    fortune-mod \
    # Numerical computing
    octave

# Create and setup Python virtual environment for additional packages
RUN python -m venv /opt/venv && \
    source /opt/venv/bin/activate && \
    pip install \
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

# Crear mensaje de bienvenida
RUN echo '#!/bin/bash\n\
clear\n\
echo -e "\033[34m$(figlet -f slant "Análisis Numérico")\033[0m" | lolcat -a -d 2\n\
echo -e "\033[35m================================================\033[0m" | lolcat\n\
echo -e "\033[36m     Universidad Nacional de Colombia sede Palmira\033[0m" | lolcat\n\
echo -e "\033[35m================================================\033[0m" | lolcat\n\
echo -e "\033[33m\n🔢 Bienvenido al curso de Análisis Numérico\033[0m\n"\n\
echo -e "\033[32m📚 Herramientas disponibles:\033[0m"\n\
echo -e "   • C++ con bibliotecas numéricas"\n\
echo -e "   • Python con NumPy, SciPy, Matplotlib"\n\
echo -e "   • Octave para cálculos numéricos"\n\
echo -e "   • Jupyter Notebooks"\n\
echo -e "   • Herramientas de visualización"\n\
echo -e "\033[32m🔍 Comandos útiles:\033[0m"\n\
echo -e "   • plot-help : Muestra ejemplos de gráficas"\n\
echo -e "   • calc-help : Muestra ayuda para cálculos numéricos"\n\
echo -e "   • cpp-compile : Compila con flags para análisis numérico"\n\
echo -e "\033[35m================================================\033[0m" | lolcat\n\
echo -e "\033[36m        ¡Comencemos a programar! 💻\033[0m\n" | lolcat\n\
fortune | cowsay -f tux | lolcat\n\
echo -e "\033[35m================================================\033[0m" | lolcat\n\
' > /usr/local/bin/welcome-message && chmod +x /usr/local/bin/welcome-message

# Crear scripts de ayuda
RUN echo '#!/bin/bash\n\
echo -e "\033[34mEjemplos de gráficas con C++ y Python:\033[0m\n"\n\
echo -e "1. Matplotlib en Python:"\n\
echo "   python -c \"import matplotlib.pyplot as plt; import numpy as np; x = np.linspace(-5,5,100); plt.plot(x, np.sin(x)); plt.show()\""\n\
echo -e "\n2. Gnuplot en C++:"\n\
echo "   g++ -o plot plot.cpp -lgnuplot-iostream"\n\
' > /usr/local/bin/plot-help && chmod +x /usr/local/bin/plot-help

RUN echo '#!/bin/bash\n\
g++ -Wall -Wextra -O2 -march=native -ftree-vectorize "$@"\n\
' > /usr/local/bin/cpp-compile && chmod +x /usr/local/bin/cpp-compile

# Configurar shell con mejor prompt y utilidades
RUN echo 'PS1="\[\033[38;5;14m\][\[$(tput sgr0)\]\[\033[38;5;9m\]\u\[$(tput sgr0)\]\[\033[38;5;14m\]@\[$(tput sgr0)\]\[\033[38;5;13m\]\h\[$(tput sgr0)\]\[\033[38;5;14m\]]\[$(tput sgr0)\]\[\033[38;5;10m\]\w\[$(tput sgr0)\]\n\\$ \[$(tput sgr0)\]"' >> /etc/bash.bashrc

# Ejecutar mensaje de bienvenida al iniciar
RUN echo '/usr/local/bin/welcome-message' >> /etc/bash.bashrc

# Agregar alias útiles para análisis numérico
RUN echo 'alias ll="ls -la"\n\
alias g++="g++ -Wall -Wextra -Wpedantic"\n\
alias gc="g++ -Wall -Wextra -Wpedantic -g"\n\
alias gdb="gdb -q"\n\
alias cmake="cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"\n\
alias make="make -j$(nproc)"\n\
alias valgrind="valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes"\n\
alias python="python3"\n\
alias pip="pip3"\n\
alias notebook="jupyter notebook --ip=0.0.0.0 --allow-root"\n\
alias calc="octave-cli"\n\
alias plot="gnuplot"\n\
alias matrix="cmatrix | lolcat"\n\
' >> /etc/bash.bashrc

# Limpiar caché
RUN pacman -Scc --noconfirm

# Configurar el workspace
WORKDIR /workspace