#!/usr/bin/env zsh

enabled=()
disabled=()

enabled+=( 'ntpd.service' )

for unit in $enabled; do
  sudo systemctl enable $unit
done

for unit in $disabled; do
  sudo systemctl disable $unit
done

exit 0
