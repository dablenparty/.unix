# hyprland config

TODO: all of this

For now, just know you'll need to enable the experimental bluez features:

```shell
# /etc/bluetooth/main.conf
# Add this line
Experimental = true
```

Then restart the service:

```bash
systemctl restart bluetooth
```
