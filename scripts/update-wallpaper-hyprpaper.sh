wallpaper_root="$HOME/Pictures/Wallpapers/"

# args must be separated for wal
wal --cols16 -q -t -s -n -i "$wallpaper_root"

# load pywal colorscheme
source "$HOME/.cache/wal/colors.sh"

# $wallpaper should be loaded by the above script
hyprctl hyprpaper preload "$wallpaper"
# set globally
hyprctl hyprpaper wallpaper ",$wallpaper"

# get the filename by removing the root
new_wallpaper_name=$(echo "wallpaper" | sed "s|$wallpaper_root||g")

notify-send -u normal --app-name hyprpaper "Successfully updated wallpaper and colors!" "Used $new_wallpaper_name"
