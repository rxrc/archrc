#!/usr/bin/env zsh

set -e
set -u

enabled=()
disabled=()

command -v systemctl >/dev/null 2>&1 || exit 0

enabled+=('lightdm')
enabled+=('nftables')
enabled+=('NetworkManager')
enabled+=('numlock')
enabled+=('org.cups.cupsd')
enabled+=('sshd')

if [[ -d /boot/efi ]]; then
  enabled+=('efistub-update.path')
fi

if [[ -e /etc/ddclient/ddclient.conf ]]; then
  enabled+=('ddclient')
fi

if [[ "$USER" != 'root' ]]; then
  enabled+=("xscreensaver-lock@$USER")
fi

if (pacman -Q dkms &>/dev/null); then
  enabled+=('dkms')
fi

if (pacman -Q linux-samus4 &>/dev/null); then
  enabled+=('chromeos-kbd_backlight')
fi

for unit in $enabled; do
  echo "[Enable] $unit"
  sudo systemctl enable $unit
done

for unit in $disabled; do
  echo "[Disable] $unit"
  sudo systemctl disable $unit
done

exit
