#!/usr/bin/env zsh

set -e
set -u

enabled=()
disabled=()

command -v systemctl >/dev/null 2>&1 || exit 0

enabled+=('lightdm')
enabled+=('numlock')
enabled+=('cups')
enabled+=('sshd')
enabled+=('systemd-resolved')
enabled+=('nftables')
enabled+=('bluetooth')
enabled+=('paccache.timer')
enabled+=('fstrim')
enabled+=('fstrim.timer')
enabled+=('systemd-timesyncd')
enabled+=('systemd-oomd')

if [[ -e /etc/xdg/reflector/reflector.conf ]]; then
  enabled+=('reflector')
fi

if [[ -e /etc/ddclient/ddclient.conf ]]; then
  enabled+=('ddclient')
fi

if [[ -e /etc/samba/smb.conf ]]; then
  enabled+=('smbd')
fi

if [[ -e /etc/nginx/nginx.conf ]]; then
  enabled+=('nginx')
fi

if (pacman -Q bumblebee &>/dev/null); then
  enabled+=('bumblebeed')
fi

if (pacman -Q open-vm-tools &>/dev/null); then
  enabled+=('vmtoolsd')
fi

if [[ $(hostname) == 'Sleipnir' || $(hostname) == 'Fenrir' || $(hostname) == 'Frigg' ]]; then
  enabled+=('systemd-networkd')
elif [[ $(hostname) == 'Freyja' || $(hostname) == 'Sleipnir' ]]; then
  enabled+=('dhcpcd')
elif [[ $(hostname) == 'Gungnir' ]]; then
  enabled+=('iwd')
fi

for unit in $enabled; do
  echo "[Enable] $unit"
  sudo -S systemctl enable $unit
done

for unit in $disabled; do
  echo "[Disable] $unit"
  sudo -S systemctl disable $unit
done

# TODO This will fail under initial arch-chroot.
#      Ignore for now and run it after first boot.
sudo -S ln -s -f /run/systemd/resolve/resolv.conf /etc/resolv.conf
sudo chattr +i "$(realpath /etc/resolv.conf)"

exit
