# 📚 Workspace - Análisis Numérico

<div align="center">

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![C++](https://img.shields.io/badge/C++-00599C?style=for-the-badge&logo=c%2B%2B&logoColor=white)
![Jupyter](https://img.shields.io/badge/Jupyter-F37626?style=for-the-badge&logo=jupyter&logoColor=white)

</div>

## 🎯 Guía del Estudiante

## 💻 Comandos Útiles

# Iniciar Jupyter Notebook
notebook

# Iniciar Jupyter Lab
jlab

# Compilar código C++
cpp-compile archivo.cpp

# Ejecutar Python
python archivo.py

### 📂 Organización de Archivos

```plaintext
.
├── practicas/
│   ├── practica1/
│   ├── practica2/
│   └── ...
├── proyectos/
│   └── proyecto_final/
└── recursos/
    ├── datos/
    └── ejemplos/

```

### 📚 Trabajando con notebooks
1. Los notebooks deben guardarse en la carpeta correspondiente
2. Nombra tus notebooks con formato: `practica1_nombre_apellido.ipynb`
3. Documenta tu código usando Markdown
4. Incluye conclusiones al final de cada notebook

### 📚 Ejemplos de uso
```plaintext
# Ejemplo de gráfica en Python
import numpy as np
import matplotlib.pyplot as plt

x = np.linspace(-5, 5, 100)
plt.plot(x, np.sin(x))
plt.title('Función Seno')
plt.show()
```

```plaintext
// Ejemplo de gráfica en C++
#include <iostream>
#include <cmath>

int main() {
    double x = 1.0;
    std::cout << "sin(" << x << ") = " << sin(x) << std::endl;
    return 0;
}
```	

### 🚫 Evitar
- No modificar archivos de configuración
- No trabajar fuera de la carpeta workspace `Los archivos que se encuentren fuera de la carpeta workspace se borrarán`
- No usar rutas absolutas en tu código, ej: `/home/usuario/workspace/archivo.cpp`
- No subir archivos binarios grandes

<div align="center">
<strong>¡Éxito en tu curso de Análisis Numérico! 🚀</strong>
</div>