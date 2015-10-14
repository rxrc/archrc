#!/usr/bin/env zsh

set -e
set -u

enabled=()
disabled=()

command -v systemctl >/dev/null 2>&1 || exit 0

enabled+=('lightdm')
enabled+=('nftables')
enabled+=('numlock')
enabled+=('org.cups.cupsd')
enabled+=('sshd')

if [[ -d /boot/efi ]]; then
  enabled+=('efistub-update.path')
  enabled+=('efistub-ucode-update.path')
fi

if [[ -d /boot/efi/EFI/refind ]]; then
  enabled+=('refind-update.path')
fi

if (pacman -Q networkmanager &>/dev/null); then
  enabled+=('NetworkManager')
  if [[ -h /etc/resolv.conf ]]; then
    sudo -S rm /etc/resolv.conf
    sudo -S touch /etc/resolv.conf
  fi
  sudo -S sed -i \
    's/hosts: files resolve myhostname/hosts: files dns myhostname/' \
    /etc/nsswitch.conf
else
  enabled+=('systemd-networkd')
  enabled+=('systemd-resolved')
  if lsof | grep -q /etc/resolv.conf; then
    echo '[Error] Could not modify resolv.conf.'
    echo '        This is expected if under inital arch-chroot.'
    echo '        Rerun units.zsh after first boot.'
  else
    sudo -S ln -s -f /run/systemd/resolve/resolv.conf /etc/resolv.conf
  fi
  sudo -S sed -i \
    's/hosts: files dns myhostname/hosts: files resolve myhostname/' \
    /etc/nsswitch.conf
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
  sudo -S systemctl enable $unit
done

for unit in $disabled; do
  echo "[Disable] $unit"
  sudo -S systemctl disable $unit
done

exit
