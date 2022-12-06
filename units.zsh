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

if [[ -d /boot/efi/EFI/arch || -d /boot/efi/loader ]]; then
  enabled+=('efistub-update@linux.path')
  enabled+=('efistub-ucode-update@linux.path')
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

if (pacman -Q linux-samus4 &>/dev/null); then
  enabled+=('chromeos-kbd_backlight')
fi

if [[ $(hostname) == 'Sleipnir' || $(hostname) == 'Mimir' ]]; then
  enabled+=('systemd-networkd')
elif [[ $(hostname) == 'Freyja' ]]; then
  enabled+=('dhcpcd')
elif [[ $(hostname) == 'Gungnir' ]]; then
  enabled+=('iwd')
elif [[ $(hostname) == 'Mjolnir' && $(pacman -Q netctl &>/dev/null) ]]; then
  enabled+=('systemd-resolved-resume')
  enabled+=("netctl-auto@$(ls /sys/class/net | grep ^w | head -1)")
  enabled+=("netctl-auto-resume@$(ls /sys/class/net | grep ^e | head -1)")
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
