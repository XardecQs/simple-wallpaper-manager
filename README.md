# Simple Wallpaper Manager

**Simple Wallpaper Manager** es un script en Bash que permite cambiar fácilmente el fondo de pantalla o configurar un video como fondo dinámico en hyprland. Ofrece opciones para seleccionar imágenes o videos de forma manual o aleatoria, utilizando herramientas ligeras y modernas como `swww`, `mpvpaper`, y `pywal`.

---

## Características

- **Soporte para imágenes**: Configura imágenes estáticas como fondo usando `swww`.
- **Fondos de video**: Configura videos en bucle como fondo de pantalla con `mpvpaper`.
- **Selección manual**: Escoge una imagen o video desde un cuadro de diálogo.
- **Selección aleatoria**: Elige automáticamente una imagen o video de las carpetas configuradas.
- **Paleta de colores**: Genera una paleta de colores para la terminal y aplicaciones compatibles con `pywal`.

---

## Dependencias

Asegúrate de tener instalados los siguientes paquetes en tu sistema:

1. **Zenity**: Para los cuadros de diálogo interactivos.
2. **swww**: Para gestionar fondos de pantalla estáticos con transiciones.
3. **mpvpaper**: Para reproducir videos como fondo de pantalla.
4. **pywal**: Para generar paletas de colores basadas en el fondo seleccionado.

En distribuciones basadas en Arch Linux, puedes instalarlos con:

```bash
sudo pacman -S zenity pywal swww
yay -S mpvpaper
```

---
## Uso

1. Ejecuta el script:
```bash
./simple-wallpaper-manager.sh
```

---
## Personalización

Puedes modificar las carpetas predeterminadas de imágenes y videos editando las siguientes líneas en el script:

```bash
IMAGE_DIR="/home/$(whoami)/Imágenes/wallpapers"
VIDEO_DIR="/home/$(whoami)/Vídeos/VWallpapers"
```

---
## Créditos

Primer script desarrollado por [XardecQs](https://github.com/XardecQs). Si tienes comentarios o sugerencias, ¡no dudes en abrir un issue o enviar un pull request!