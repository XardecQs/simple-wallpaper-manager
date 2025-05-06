#!/bin/bash

#---------------------------------------------#
IMAGE_DIR="$HOME/Media/Imágenes/Wallpapers"
VIDEO_DIR="$HOME/Media/Videos/Wallpapers"

COLOR_MODE=lighten    #puede ser: [darken|lighten]
#---------------------------------------------#

check_deps() {
  local missing=()
  for cmd in zenity swww wal mpvpaper swaync-client; do
    if ! command -v "$cmd" &> /dev/null; then
      missing+=("$cmd")
    fi
  done
  
  if [ ${#missing[@]} -gt 0 ]; then
    zenity --error --text="Faltan dependencias requeridas:\n${missing[*]}"
    exit 1
  fi
}

select_image() {
  zenity --file-selection --title="Selecciona una imagen de fondo" \
    --file-filter="Imágenes | *.jpeg *.jpg *.png *.gif *.pnm *.tga *.tiff *.webp *.bmp *.farbfeld" \
    --filename="$IMAGE_DIR/"
}

select_video() {
  zenity --file-selection --title="Selecciona un video de fondo" \
    --file-filter="Videos | *.mp4 *.mkv *.webm *.avi" \
    --filename="$VIDEO_DIR/"
}

set_image_swww() {
  if ! pgrep -x "swww-daemon" >/dev/null; then
    swww-daemon &
  fi
  swww img "$IMAGE" --transition-type random --transition-duration 1.5 --transition-fps 60
  wal -i "$IMAGE" --cols16 $COLOR_MODE -n -e 
  pkill mpvpaper
}

set_video_wallpaper() {
  pkill mpvpaper
  mpvpaper --auto-pause -o "no-audio --loop-playlist shuffle" '*' "$VIDEO" --idle &
  wal -i "$VIDEO" --cols16 $COLOR_MODE -n -e
  pkill swww-daemon
}


select_random_img() {
  find "$IMAGE_DIR" -type f \( -iname "*.jpeg" -o -iname "*.jpg" -o -iname "*.png" \
      -o -iname "*.gif" -o -iname "*.pnm" -o -iname "*.tga" -o -iname "*.tiff" -o -iname "*.webp" \
      -o -iname "*.bmp" -o -iname "*.farbfeld" \) | shuf -n 1
}

select_random_vid() {
    find "$VIDEO_DIR" -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" \
      -o -iname "*.avi" \) | shuf -n 1
}

recalcular-colores(){
  local recalc=$(cat /home/xardec/.cache/swww/eDP-1)
  wal -i "$recalc" --cols16 $COLOR_MODE -n -e
}


sddm() {
  local sddm_wall="/usr/share/sddm/themes/sugar-candy/Backgrounds/wallpaper.jpg"
  local cache_file="$(cat /home/xardec/.cache/swww/eDP-1)"
  
  if [ -f "$cache_file" ]; then
    cp "$cache_file" "$sddm_wall" || true
  fi

  ACCENT_COLOR=$(sed -n '10p' ~/.cache/wal/colors || echo "#fb884f")
  sed -i "s/AccentColor=.*/AccentColor=$ACCENT_COLOR/" "${sddm_wall%/Backgrounds*}/theme.conf"
}

extras() {
  swaync-client -rs &>/dev/null
}

#---------------------------------------------#
check_deps

case ${1:-$(zenity --list --title="Seleccionar fondo" --text="Elige una opción:" \
    --column="Opción" "Imagen manual" "Imagen aleatoria" "Video manual" "Video aleatorio" "Recalcular colores" "Reaplicar imagen" \
    --height=300 --width=400)} in
  "Imagen manual")
    IMAGE=$(select_image)
    [ -z "$IMAGE" ] && exit 1
    set_image_swww
    ;;
  "Imagen aleatoria")
    IMAGE=$(select_random_img)
    set_image_swww
    ;;
  "Video manual")
    VIDEO=$(select_video)
    [ -z "$VIDEO" ] && exit 1
    set_video_wallpaper
    ;;
  "Video aleatorio")
    VIDEO=$(select_random_vid)
    set_video_wallpaper
    ;;
  "Reaplicar imagen")
    IMAGE=$(cat /home/xardec/.cache/swww/eDP-1)
    set_image_swww
    ;;
  "Recalcular colores")
    recalcular-colores
    ;;
esac

sddm
extras
