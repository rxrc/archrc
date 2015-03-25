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

if [[ -z "$1" ]]; then
  echo 'Must give hostname as first argument.'
  exit 1
fi

echo $1 > /etc/hostname
puts 'Hostname' $1

puts 'Installing' 'Config Curator requirements'

pacin ruby
pacin nodejs

command -v curate >/dev/null 2>&1 || gem install config_curator
command -v bower  >/dev/null 2>&1 || npm install -g bower

command -v curate >/dev/null 2>&1 && \
command -v bower  >/dev/null 2>&1 && \
puts 'Installed' 'Config Curator requirements'

if ! [[ -d bower_components ]]; then
  puts 'Installing' 'Bower components'
  bower --allow-root install
fi

if [[ -d bower_components ]]; then
  puts 'Installed' 'Bower components'
fi

puts 'Installing' 'Config'

curate -v

if [[ -d bower_components ]]; then
  rm -rf bower_components
  puts 'Cleaned' 'Bower components'
fi

puts 'Installing' 'archutil requirements'

pacin curl
pacin python
pacin python-yaml

puts 'Installed' 'archutil requirements'

if ! [[ -e /usr/local/bin/archutil ]]; then
  puts 'Installing' 'archutil'
  curl -L -o /usr/local/bin/archutil https://io.evansosenko.com/archutil/archutil
fi

if [[ -e /usr/local/bin/archutil ]]; then
  chmod +x /usr/local/bin/archutil
  puts 'Installed' 'archutil'
fi

puts 'Running' 'locale-gen'

locale-gen
export $(cat /etc/locale.conf)

puts 'Done'

exit 0
