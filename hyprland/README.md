# hyprland config

TODO: all of this

For now, just know you'll need to enable the experimental `bluez` features:

```sh
# /etc/bluetooth/main.conf
# Add this line
Experimental = true
```

as well as the following programs:

- `wofi`: App launcher
- `waybar`: Top bar
- `swaync`: Notification daemon
- `hypridle`: Hyprland idler
- `hyprlock`: Hyprland lock screen
- `nwg-look`: GTK Theme Settings
- `blueman`: Bluetooth applet
