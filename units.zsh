#!/usr/bin/env zsh

set -e
set -u

enabled=()
disabled=()

command -v systemctl >/dev/null 2>&1 || exit 0

enabled+=('lightdm')
enabled+=('numlock')
enabled+=('org.cups.cupsd')
enabled+=('sshd')

if [[ $(hostname) != 'Sleipnir' ]]; then
  enabled+=('nftables')
fi

if [[ -d /boot/efi/EFI/arch || -d /boot/efi/loader ]]; then
  enabled+=('efistub-update@linux.path')
  enabled+=('efistub-ucode-update@linux.path')
fi
if [[ $(hostname) == 'Frigg' ]]; then
  enabled+=('efistub-update@linux-macbook.path')
  enabled+=('efistub-ucode-update@linux-macbook.path')
fi

if [[ -d /boot/efi/EFI/refind ]]; then
  enabled+=('refind-update.path')
fi

if [[ $(hostname) == 'Sleipnir' || $(hostname) == 'Mimir' ]]; then
  enabled+=('systemd-networkd')
  enabled+=('systemd-resolved')

  # TODO This will fail under initial arch-chroot.
  #      Comment it out and run it after first boot.
  sudo -S ln -s -f /run/systemd/resolve/resolv.conf /etc/resolv.conf

  sudo -S sed -i \
    's/hosts: files dns myhostname/hosts: files resolve myhostname/' \
    /etc/nsswitch.conf
else
  sudo -S sed -i \
    's/hosts: files resolve myhostname/hosts: files dns myhostname/' \
    /etc/nsswitch.conf

  if [[ -h /etc/resolv.conf ]]; then
    sudo -S rm /etc/resolv.conf
    sudo -S touch /etc/resolv.conf
  fi

  enabled+=("netctl-auto@$(ls /sys/class/net | grep ^wl | head -1)")
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

if [[ "$USER" != 'root' ]]; then
  enabled+=("xscreensaver-lock@$USER")
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
