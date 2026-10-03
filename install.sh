#!/usr/bin/env bash

set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
bin_dir="${HOME}/.local/bin"
unit_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/systemd/user"
app_dir="${XDG_DATA_HOME:-${HOME}/.local/share}/applications"

required=(nmcli busctl xdg-open notify-send python3 systemctl)
missing=()
for command in "${required[@]}"; do
    command -v "$command" >/dev/null 2>&1 || missing+=("$command")
done

if ((${#missing[@]})); then
    printf 'Missing required commands: %s\n' "${missing[*]}" >&2
    exit 1
fi

python3 - <<'PY'
import gi
for namespace, version in (("Adw", "1"), ("Gtk", "4.0"), ("NM", "1.0")):
    gi.require_version(namespace, version)
    __import__("gi.repository", fromlist=[namespace])
PY

install -Dm755 "$repo_dir/bin/hypr-network-menu" "$bin_dir/hypr-network-menu"
install -Dm755 "$repo_dir/bin/hypr-captive-portal" "$bin_dir/hypr-captive-portal"
install -Dm644 \
    "$repo_dir/systemd/hypr-captive-portal.service" \
    "$unit_dir/hypr-captive-portal.service"

mkdir -p "$app_dir"
cat > "$app_dir/io.github.altifilius.HyprWifi.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Name=Hypr WiFi
Comment=NetworkManager Wi-Fi and hotspot controls for Hyprland
Exec=hypr-network-menu
Icon=network-wireless
Terminal=false
Categories=Network;Settings;
Keywords=wifi;network;hotspot;portal;
EOF

systemctl --user daemon-reload
systemctl --user enable --now hypr-captive-portal.service

printf '%s\n' \
    'Installed Hypr WiFi.' \
    'Run: hypr-network-menu' \
    'Tools tab: hypr-network-menu --tools' \
    'See examples/waybar-network.jsonc for Waybar integration.'
