#!/usr/bin/env zsh

enabled=()
disabled=()

echo 'Enable: dbus.socket'
sudo systemctl --global enable dbus.socket

for unit in $enabled; do
  echo "[Enable] $unit"
  sudo systemctl enable $unit
done

for unit in $disabled; do
  echo "[Disable] $unit"
  sudo systemctl disable $unit
done

exit 0
