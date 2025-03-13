#!/bin/bash

#---------------------------------------------#
IMAGE_DIR="$HOME/Media/Imágenes/Wallpapers"
VIDEO_DIR="$HOME/Media/Videos/Wallpapers"
#----------------------------------------------#

select_image() {
  IMAGE=$(zenity --file-selection --title="Selecciona una imagen de fondo" --file-filter="Imágenes | *.jpeg *.jpg *.png *.gif *.pnm *.tga *.tiff *.webp *.bmp *.farbfeld" --filename="$IMAGE_DIR/")
}

select_video() {
  VIDEO=$(zenity --file-selection --title="Selecciona un video de fondo" --file-filter="Videos | *.mp4 *.mkv *.webm *.avi" --filename="$VIDEO_DIR/")
}

set_image_swww() {
  swww-daemon &
  swww img "$IMAGE" --transition-type random --transition-duration 1.5 --transition-fps 60
  sleep 1.5
  wal -i "$IMAGE" --cols16
  pkill mpvpaper
}

set_video_wallpaper() {
  pkill mpvpaper
  mpvpaper --auto-pause -o "no-audio --loop-playlist shuffle" '*' "$VIDEO" --idle &
  wal -i "$VIDEO" --cols16
  pkill swww-daemon
}

select_random_img() {
  local wallpapers=($(find "$IMAGE_DIR" -type f \( -iname "*.jpeg" -o -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.pnm" -o -iname "*.tga" -o -iname "*.tiff" -o -iname "*.webp" -o -iname "*.bmp" -o -iname "*.farbfeld" \)))
  if [[ ${#wallpapers[@]} -eq 0 ]]; then
    echo "No se encontraron imágenes en la carpeta $IMAGE_DIR. Saliendo..."
    exit 1
  fi
  echo "${wallpapers[RANDOM % ${#wallpapers[@]}]}"
}

select_random_vid() {
  local wallpapers=($(find "$VIDEO_DIR" -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" -o -iname "*.avi" \)))
  if [[ ${#wallpapers[@]} -eq 0 ]]; then
    echo "No se encontraron imágenes en la carpeta $VIDEO_DIR. Saliendo..."c
    exit 1
  fi
  echo "${wallpapers[RANDOM % ${#wallpapers[@]}]}"
}

sddm() {
  WALLPAPER=$(cat /home/xardec/.cache/swww/eDP-1)
  cp "$WALLPAPER" /usr/share/sddm/themes/sugar-candy/Backgrounds/wallpaper.jpg

  ACCENT_COLOR=$(sed -n '10p' ~/.cache/wal/colors)
  if [ -z "$ACCENT_COLOR" ]; then
    ACCENT_COLOR="#fb884f"
  fi
  
  sed -i "s/AccentColor=.*/AccentColor=$ACCENT_COLOR/" /usr/share/sddm/themes/sugar-candy/theme.conf

}

#---------------------------------------------#

CHOICE=$1

if [[ -z "$CHOICE" ]]; then
  CHOICE=$(zenity --list --title="Seleccionar fondo" --text="Elige una opción:" \
    --column="Opción" "Imagen manual" "Imagen aleatoria" "Video manual" "Video aleatorio" \
    --height=300 --width=400)

elif [[ "$CHOICE" != "Imagen manual" && "$CHOICE" != "Imagen aleatoria" && \
        "$CHOICE" != "Video manual" && "$CHOICE" != "Video aleatorio" ]]; then
  zenity --error --title="Error" --text="Opción inválida, argumentos posibles:\n - Imagen manual \n - Imagen aleatoria \n - Video manual \n - Video aleatorio"
  exit 1
fi

case $CHOICE in
  "Imagen manual")
    select_image
    set_image_swww
    sddm
    ;;
  "Imagen aleatoria")
    IMAGE=$(select_random_img)
    set_image_swww
    sddm
    ;;
  "Video manual")
    select_video
    set_video_wallpaper
    sddm
    ;;
  "Video aleatorio")
    VIDEO=$(select_random_vid)
    set_video_wallpaper
    sddm
    ;;
esac
