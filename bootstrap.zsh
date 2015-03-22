#!/usr/bin/env zsh

set -e

function puts () {
  echo "\n-- [$1] $2"
}

function pacin () {
  if ! (pacman -Q $1 >/dev/null); then
    pacman -S --noconfirm $1
  fi
}

pacin curl
pacin python
pacin python-yaml

if ! [[ -e /usr/local/bin/archutil ]]; then
  curl -L -o /usr/local/bin/archutil https://io.evansosenko.com/archutil/archutil
fi

if [[ -e /usr/local/bin/archutil ]]; then
  chmod +x /usr/local/bin/archutil
  puts 'Installed' 'archutil'
fi
