#!/usr/bin/env zsh

enabled=()
disabled=()

command -v systemctl >/dev/null 2>&1 || exit 0

enabled+=('getty@tty6')
enabled+=('nftables')
enabled+=('NetworkManager')
enabled+=('numlock')
enabled+=('org.cups.cupsd')
enabled+=("slimlock@$USER")
enabled+=('sshd')

if [[ -d /boot/efi ]]; then
  enabled+=('efistub-update.path')
fi

if [[ -e /etc/ddclient/ddclient.conf ]]; then
  enabled+=('ddclient')
fi

if (pacman -Q dkms &>/dev/null); then
  enabled+=('dkms')
fi

for unit in $enabled; do
  echo "[Enable] $unit"
  sudo systemctl enable $unit
done

for unit in $disabled; do
  echo "[Disable] $unit"
  sudo systemctl disable $unit
done

exit 0
