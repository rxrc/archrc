#!/usr/bin/env zsh

enabled=()
disabled=()

enabled+=('getty@tty6')
enabled+=('nftables')
enabled+=('NetworkManager')
enabled+=('numlock')
enabled+=("slimlock@$USER")
enabled+=('sshd')

if [[ -e /etc/ddclient/ddclient.conf ]]; then
  enabled+=('ddclient')
fi

if (pacman -Q dkms >/dev/null); then
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
