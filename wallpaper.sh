#!/bin/bash

#---------------------------------------------#

IMAGE_DIR="/home/$(whoami)/Imágenes/wallpapers"
VIDEO_DIR="/home/$(whoami)/Vídeos/VWallpapers"

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
  mpvpaper -o "no-audio --loop-playlist shuffle" '*' "$VIDEO" &
  wal -i "$VIDEO" --cols16
  pkill swww-daemon
}

select_random_img() {
  local wallpapers=($(find "$IMAGE_DIR" -type f \( -iname "*.jpeg" -o -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.pnm" -o -iname "*.tga" -o -iname "*.tiff" -o -iname "*.webp" -o -iname "*.bmp" -o -iname "*.farbfeld" \)))
  #local wallpapers=("$IMAGE_DIR"/*.{jpeg,jpg,png,gif,pnm,tga,tiff,webp,bmp,farbfeld})
  if [[ ${#wallpapers[@]} -eq 0 ]]; then
    echo "No se encontraron imágenes en la carpeta $IMAGE_DIR. Saliendo..."
    exit 1
  fi
  echo "${wallpapers[RANDOM % ${#wallpapers[@]}]}"
}

select_random_vid() {
  local wallpapers=($(find "$VIDEO_DIR" -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" -o -iname "*.avi" \)))
  #local wallpapers=("$VIDEO_DIR"/*)
  if [[ ${#wallpapers[@]} -eq 0 ]]; then
    echo "No se encontraron imágenes en la carpeta $VIDEO_DIR. Saliendo..."
    exit 1
  fi
  echo "${wallpapers[RANDOM % ${#wallpapers[@]}]}"
  pkill mpvpaper
}

#---------------------------------------------#

CHOICE=$(zenity --list --title="Seleccionar fondo" --text="Elige una opción:" \
  --column="opción" "Imagen manual" "Imagen aleatoria" "Video manual" "Video aleatorio" \
  --height=300 --width=400)

case $CHOICE in
  "Imagen manual")
    select_image
    set_image_swww
    ;;
  "Imagen aleatoria")
    IMAGE=$(select_random_img)
    set_image_swww
    ;;
  "Video manual")
    select_video
    set_video_wallpaper
    ;;
  "Video aleatorio")
    VIDEO=$(select_random_vid)
    set_video_wallpaper
    ;;
esac
