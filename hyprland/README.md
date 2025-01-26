# hyprland config

# Installation

See the [Hyprland Wiki](https://wiki.hyprland.org/Nvidia/#installation).

# Requirements:

## Programs

- `blueman-applet`
  - Installed with `blueman`
- `hypridle`
- `hyprlock`
- `hyprpaper`
- `hyprpolkitagent`
- `mako`
- `nwg-look`
- `uwsm`
- `waybar`
- `wofi`

You'll also need to enable the experimental `bluez` features:

```sh
# /etc/bluetooth/main.conf
# Add this line
Experimental = true
```

> [!IMPORTANT] Be careful with `bluetoothctl`
> Some of its subcommands can cause Hyprland to just... logout or crash. It's tracked by [this GitHub issue](https://github.com/bluez/bluez/issues/996).
