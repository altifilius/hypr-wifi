# Hypr WiFi

A native NetworkManager Wi-Fi and hotspot interface for Hyprland, built with
GTK 4, libadwaita, and libnm.

## Features

- Live, signal-sorted list of nearby Wi-Fi networks
- Saved-network reuse and open-network connection without password prompts
- WPA2/WPA3 password dialog with credentials sent through libnm/D-Bus
- Separate **Tools** tab for Wi-Fi radio control and hotspot management
- WPA2 hotspot creation with generated editable passwords
- Hidden-network and advanced profile entry points
- Captive portal detection, notification, and automatic browser launch
- Single-instance application behavior
- Waybar left/right/middle-click integration

## Security model

`hypr-network-menu` does not put Wi-Fi or hotspot passwords in process
arguments. Credentials are passed to NetworkManager through libnm. Existing
NetworkManager profiles are reused when possible. Enterprise and legacy
authentication can use `nm-applet` as the NetworkManager secret agent.

The captive portal helper opens only NetworkManager's configured plain-HTTP
connectivity-check URI. This lets the access point redirect the browser without
requiring TLS certificate bypasses. Never ignore a certificate warning on a
public network.

## Requirements

- NetworkManager with connectivity checking enabled
- Python 3 and PyGObject
- GTK 4 and libadwaita
- libnm GObject introspection bindings
- `libnotify`, `xdg-utils`, and systemd
- Optional: `network-manager-applet` for enterprise/legacy secret prompts

Arch Linux package names:

```sh
sudo pacman -S --needed networkmanager python-gobject gtk4 libadwaita \
  libnotify xdg-utils network-manager-applet
```

The Wi-Fi adapter must advertise AP capability for hotspot creation:

```sh
nmcli -f WIFI-PROPERTIES.AP device show
```

## Install

```sh
git clone git@github.com:altifilius/hypr-wifi.git
cd hypr-wifi
./install.sh
```

The installer places the executables in `~/.local/bin`, installs and enables the
user-level captive portal service, and creates an application launcher. It does
not modify compositor or bar configuration.

## Waybar integration

Merge `examples/waybar-network.jsonc` into the active Waybar configuration and
ensure `network` is present in one of the module lists.

Behavior:

- Left click: nearby Wi-Fi networks
- Right click: Tools tab
- Middle click: captive portal page

## Hyprland integration

`examples/hyprland.conf` contains a key binding and a floating-window rule for
Hyprland 0.56+. Lua configurations can use the equivalent commands:

```lua
hl.bind("SUPER + N", hl.dsp.exec_cmd("hypr-network-menu"))
```

Match the application class `io.github.altifilius.HyprWifi` and apply a
`620x700` centered floating rule.

## Usage

```sh
hypr-network-menu          # nearby networks
hypr-network-menu --tools  # hotspot and advanced tools

hypr-captive-portal check  # force a NetworkManager connectivity check
hypr-captive-portal open   # open the configured portal probe manually
```

The portal monitor normally runs through:

```sh
systemctl --user status hypr-captive-portal.service
```

## Hotspot behavior

Creating a hotspot may disconnect the current Wi-Fi connection when the adapter
cannot run station and AP modes simultaneously. The UI warns before activation.
Generated profiles use WPA-PSK, IPv4/IPv6 shared mode, and do not autoconnect.

## Uninstall

```sh
./uninstall.sh
```

Waybar and Hyprland snippets are intentionally left untouched.

## Verification

```sh
python -m py_compile bin/hypr-network-menu
bash -n bin/hypr-captive-portal install.sh uninstall.sh
systemd-analyze --user verify systemd/hypr-captive-portal.service
```

The application requires a live graphical session and NetworkManager for the UI
smoke test:

```sh
hypr-network-menu
```
