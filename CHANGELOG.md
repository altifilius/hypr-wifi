# Changelog

## 1.1.1 — 2026-10-06

- Prevent the multi-probe detector from treating an ordinary router admin page as a portal after successful public probes.
- Resolve the gateway through the active Wi-Fi interface instead of assuming `wlan0`.
- Make `check` bypass activation deduplication without opening a fallback when no portal is detected.
- Update installation dependencies, verification commands, documentation, and the 620×720 window rule.

## 1.1.0 — 2026-10-03

- Add dedicated connected-network status card with instant disconnect button.
- Add multi-probe captive portal detector (Mozilla, Ubuntu, Google, Microsoft, and Gateway IP).
- Replace deprecated dialogs with native `Adw.AlertDialog` prompts.
- Add debounced event loop to eliminate GTK widget thrashing during rapid D-Bus state changes.
- Add inline profile forget/deletion buttons for saved networks.
- Store Wi-Fi credentials with `psk_flags = 0` to persist system keyfiles without external agents.
- Update Waybar network format with real-time download and upload speeds.

## 1.0.0 — 2026-10-03

- Add a GTK 4/libadwaita Wi-Fi network list backed by libnm.
- Add saved, open, WPA2, WPA3, OWE, and enterprise connection paths.
- Add a separate Tools tab with Wi-Fi radio and hotspot controls.
- Add WPA2 hotspot profile creation using shared IPv4 and IPv6.
- Add NetworkManager captive portal monitoring and browser launch.
- Add Waybar and Hyprland integration examples.
- Add install and uninstall scripts.
