#!/usr/bin/env zsh

set -e
set -u

puts () {
  echo "\n-- [${1:-}] ${2:-}"
}

set_hostname () {
  hostname="${1:-}"

  if [[ -z ${hostname} ]]; then
    echo 'Must give hostname as first argument.'
    exit 2
  fi

  puts 'Setting' 'Hostname'
  echo $hostname | sudo -S tee /etc/hostname
  sudo -S hostname $hostname
  puts 'Hostname' $hostname
}

install_config () {
  puts 'Installing' 'Node modules'
  sudo -S pacman -S --noconfirm rsync npm
  npm install
  puts 'Installed' 'Node modules'

  puts 'Installing' 'Config'
  sudo npm start
  puts 'Installed' 'Config'
}

install_efistubs () {
  puts 'Installing' 'EFI Stubs'
  if [[ -d /boot/efi ]]; then
    efi_stub_path="/boot/efi/EFI/arch"
    mkdir $efi_stub_path
    sudo cp /boot/vmlinuz-linux "${efi_stub_path}/vmlinuz-linux.efi"
    sudo cp /boot/initramfs-linux.img "${efi_stub_path}"
    sudo cp /boot/initramfs-linux-fallback.img "${efi_stub_path}"
    sudo cp /boot/intel-ucode.img "${efi_stub_path}"
    puts 'Installed' 'EFI Stubs'
  fi
}

install_archutil () {
  archutil_url='https://raw.githubusercontent.com/rxrc/archutil/v1.2.9/bin/archutil'

  puts 'Installing' 'archutil requirements'
  sudo -S pacman -S --noconfirm curl python python-yaml
  puts 'Installed' 'archutil requirements'

  if ! [[ -e /usr/local/bin/archutil ]]; then
    puts 'Installing' 'archutil'
    sudo -S curl -L -o /usr/local/bin/archutil $archutil_url
  fi

  if [[ -e /usr/local/bin/archutil ]]; then
    sudo -S chmod +x /usr/local/bin/archutil
    puts 'Installed' 'archutil'
  fi
}

set_locale () {
  puts 'Setting' 'Locale'
  sudo -S locale-gen
  export $(cat /etc/locale.conf)
  puts 'Set' 'Locale'
}

main () {
  echo 'Preauthenticate for sudo.'
  sudo -S echo

  if [[ $(id -u) == 0 ]]; then
    echo 'Must not run as root.'
    exit 1
  fi

  set_hostname ${1:-}
  install_config
  install_archutil
  set_locale
  install_efistubs
  puts 'Done' ''
}

main ${1:-}
exit
