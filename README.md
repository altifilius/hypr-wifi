# Hypr WiFi

A native NetworkManager Wi-Fi and hotspot interface for Hyprland, built with
GTK 4, libadwaita, and libnm.

## Features

- Live, signal-sorted list of nearby Wi-Fi networks
- Dedicated connected-network card with immediate disconnect control
- Saved-network reuse, profile deletion, and open-network connection without password prompts
- WPA2/WPA3 password dialog with credentials sent through libnm/D-Bus
- Separate **Tools** tab for Wi-Fi radio control and hotspot management
- WPA2 hotspot creation with generated editable passwords
- Hidden-network and advanced profile entry points
- Multi-probe captive portal detection, notification, and automatic browser launch
- Single-instance application behavior with debounced NetworkManager updates
- Waybar left/right/middle-click integration and live transfer rates

## Security model

`hypr-network-menu` does not put Wi-Fi or hotspot passwords in process
arguments. Credentials are passed to NetworkManager through libnm. Existing
NetworkManager profiles are reused when possible. Enterprise and legacy
authentication can use `nm-applet` as the NetworkManager secret agent.

The captive portal helper uses plain-HTTP connectivity probes from Mozilla,
Ubuntu, Google, and Microsoft. Redirects or replaced responses identify a
portal; the active Wi-Fi gateway is tried only when every public probe is
unreachable. This permits portal redirection without bypassing TLS certificate
validation. Never ignore a certificate warning on a public network.

## Requirements

- NetworkManager with connectivity checking enabled
- Python 3 and PyGObject
- GTK 4 and libadwaita
- libnm GObject introspection bindings
- `iproute2`, `libnotify`, `xdg-utils`, and systemd
- Optional: `network-manager-applet` for enterprise/legacy secret prompts

Arch Linux package names:

```sh
sudo pacman -S --needed networkmanager python-gobject gtk4 libadwaita \
  iproute2 libnotify xdg-utils network-manager-applet
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
`620x720` centered floating rule.

## Usage

```sh
hypr-network-menu          # nearby networks
hypr-network-menu --tools  # hotspot and advanced tools

hypr-captive-portal check  # detect and open a portal, ignoring activation deduplication
hypr-captive-portal open   # force the detected portal or HTTP fallback page to open
```

The portal monitor follows NetworkManager connectivity changes and actively
probes when NetworkManager reports portal, limited, unknown, or no connectivity.
It normally runs through:

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
python -m py_compile bin/hypr-network-menu bin/hypr-captive-portal
bash -n install.sh uninstall.sh
systemd-analyze --user verify systemd/hypr-captive-portal.service
```

The application requires a live graphical session and NetworkManager for the UI
smoke test:

```sh
hypr-network-menu
```
