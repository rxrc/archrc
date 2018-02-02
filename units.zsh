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
enabled+=('systemd-resolved')
enabled+=('nftables')

if [[ -d /boot/efi/EFI/arch || -d /boot/efi/loader ]]; then
  enabled+=('efistub-update@linux.path')
  enabled+=('efistub-ucode-update@linux.path')
fi

if [[ -d /boot/efi/EFI/refind ]]; then
  enabled+=('refind-update.path')
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

if [[ $(hostname) == 'Sleipnir' || $(hostname) == 'Mimir' ]]; then
  enabled+=('systemd-networkd')

  # TODO This will fail under initial arch-chroot.
  #      Comment it out and run it after first boot.
  # sudo -S ln -s -f /run/systemd/resolve/resolv.conf /etc/resolv.conf

  # sudo -S sed -i \
  #   's/hosts: files dns myhostname/hosts: files resolve myhostname/' \
  #   /etc/nsswitch.conf
else
  # sudo -S sed -i \
  #   's/hosts: files resolve myhostname/hosts: files dns myhostname/' \
  #   /etc/nsswitch.conf

  # if [[ -h /etc/resolv.conf ]]; then
  #   sudo -S rm /etc/resolv.conf
  #   sudo -S touch /etc/resolv.conf
  # fi

  enabled+=("netctl-ifplugd@$(ls /sys/class/net | grep ^e | head -1)")
  enabled+=("netctl-auto@$(ls /sys/class/net | grep ^w | head -1)")

  enabled+=("netctl-auto-resume@$(ls /sys/class/net | grep ^w | head -1)")
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

exit
