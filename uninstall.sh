#!/usr/bin/env bash

set -euo pipefail

unit_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/systemd/user"
app_dir="${XDG_DATA_HOME:-${HOME}/.local/share}/applications"

systemctl --user disable --now hypr-captive-portal.service 2>/dev/null || true
rm -f \
    "${HOME}/.local/bin/hypr-network-menu" \
    "${HOME}/.local/bin/hypr-captive-portal" \
    "$unit_dir/hypr-captive-portal.service" \
    "$app_dir/io.github.altifilius.HyprWifi.desktop"
systemctl --user daemon-reload

printf '%s\n' 'Hypr WiFi removed. Waybar/Hyprland snippets were left untouched.'
