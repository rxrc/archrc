#!/usr/bin/env zsh

set -e
set -u

function puts () {
  echo "\n-- [${1:-}] ${2:-}"
}

function set_hostname () {
  hostname="${1:-}"

  if [[ -z ${hostname} ]]; then
    echo 'Must give hostname as first argument.'
    exit 2
  fi

  puts 'Setting' 'Hostname'
  echo $hostname > /etc/hostname
  hostname $hostname
  puts 'Hostname ' $hostname
}

function install_node_modules () {
  puts 'Installing' 'Node modules'
  pacman -S --noconfirm npm
  npm install yarn
  ./node_modules/.bin/yarn
  puts 'Installed' 'Node modules'

  puts 'Installing' 'Config'
  ./node_modules/.bin/gulp
  puts 'Installed' 'Config'
}

function install_archutil () {
  puts 'Installing' 'archutil requirements'
  pacman -S --noconfirm curl python python-yaml
  puts 'Installed' 'archutil requirements'

  if ! [[ -e /usr/local/bin/archutil ]]; then
    puts 'Installing' 'archutil'
    curl -L -o /usr/local/bin/archutil https://io.evansosenko.com/archutil/archutil
  fi

  if [[ -e /usr/local/bin/archutil ]]; then
    chmod +x /usr/local/bin/archutil
    puts 'Installed' 'archutil'
  fi
}

function set_locale () {
  puts 'Setting' 'Locale'
  locale-gen
  export $(cat /etc/locale.conf)
  puts 'Set' 'Locale'
}

function main () {
  if [[ $(id -u) -ne 0 ]]; then
    echo 'Must run as root.'
    exit 1
  fi

  set_hostname ${1:-}
  install_config
  install_archutil
  set_locale
  puts 'Done' ''
}

main ${1:-}
exit
