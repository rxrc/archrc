'use strict'

import os from 'os'

const host = os.hostname().toLowerCase()
const rxrc = 'node_modules/@rxrc'

const targetRoot = '/'

const ioType = 'linux'
const pkgType = 'pacman'

const defaults = {
  dmode: '0755',
  fmode: '0644',
  user: 'root',
  group: 'root'
}

const unlinks = [{
  src: 'etc/X11/xorg.conf',
  hosts: ['mjolnir']
}]

const directories = [{
  src: `${rxrc}/systemd-units/system/user@.service.d`,
  dst: 'etc/systemd/system/user@.service.d'
}, {
  src: 'etc/systemd/resolved.conf.d'
}, {
  src: 'usr/local/share/dark-mode.d',
  fmode: '0755',
  pkgs: ['darkman']
}, {
  src: 'usr/local/share/light-mode.d',
  fmode: '0755',
  pkgs: ['darkman']
}]

const files = [{
  src: 'etc/mkinitcpio.conf',
  pkgs: ['mkinitcpio']
}, {
  src: 'etc/mkinitcpio.nvidia.conf',
  dst: 'etc/mkinitcpio.conf',
  order: 200,
  pkgs: ['mkinitcpio', 'nvidia']
}, {
  src: 'etc/vconsole.conf',
  pkgs: ['terminus-font']
}, {
  src: 'etc/locale.gen'
}, {
  src: 'etc/locale.conf'
}, {
  src: 'etc/sysctl.d/99-sysctl.conf'
}, {
  src: `${rxrc}/archrc-private/etc/fstab.${host}`,
  dst: 'etc/fstab'
}, {
  src: `${rxrc}/archrc-private/refind/refind.conf`,
  dst: 'boot/efi/EFI/refind/refind.conf',
  hosts: ['sleipnir']
}, {
  src: `${rxrc}/archrc-private/refind/refind_linux.${host}.conf`,
  dst: 'boot/refind_linux.conf',
  hosts: ['sleipnir']
}, {
  src: `${rxrc}/archrc-private/loader/loader.conf`,
  dst: 'boot/efi/loader/loader.conf',
  hosts: ['frigg']
}, {
  src: `${rxrc}/archrc-private/loader/entries/arch.${host}.conf`,
  dst: 'boot/efi/loader/entries/arch.conf',
  hosts: ['frigg', 'gungnir']
}, {
  src: 'etc/default/grub',
  pkgs: ['grub'],
  hosts: ['frigg']
}, {
  src: `etc/default/grub.${host}`,
  dst: 'etc/default/grub',
  pkgs: ['grub'],
  hosts: ['pixelbook']
}, {
  src: `${rxrc}/systemd-units/system/efistub-update@.path`,
  dst: 'etc/systemd/system/efistub-update@.path',
  pkgs: ['efibootmgr']
}, {
  src: `${rxrc}/systemd-units/system/efistub-update@.service`,
  dst: 'etc/systemd/system/efistub-update@.service',
  pkgs: ['efibootmgr']
}, {
  src: `${rxrc}/systemd-units/system/efistub-ucode-update@.path`,
  dst: 'etc/systemd/system/efistub-ucode-update@.path',
  pkgs: ['efibootmgr', 'intel-ucode']
}, {
  src: `${rxrc}/systemd-units/system/efistub-ucode-update@.service`,
  dst: 'etc/systemd/system/efistub-ucode-update@.service',
  pkgs: ['efibootmgr', 'intel-ucode']
}, {
  src: `${rxrc}/systemd-units/system/refind-update.path`,
  dst: 'etc/systemd/system/refind-update.path',
  pkgs: ['refind']
}, {
  src: `${rxrc}/systemd-units/system/refind-update.service`,
  dst: 'etc/systemd/system/refind-update.service',
  pkgs: ['refind']
}, {
  src: `${rxrc}/systemd-units/system/netctl-auto-resume@.service`,
  dst: 'etc/systemd/system/netctl-auto-resume@.service',
  hosts: ['pixelbook', 'frigg', 'mjolnir']
}, {
  src: 'etc/pacman.conf',
  pkgs: ['pacman']
}, {
  src: 'etc/nftables.conf',
  pkgs: ['nftables']
}, {
  src: 'etc/sudoers',
  fmode: '0440',
  pkgs: ['sudo']
}, {
  src: 'etc/ssh/sshd_config',
  pkgs: ['openssh']
}, {
  src: 'etc/iwd/main.conf',
  pkgs: ['iwd']
}, {
  src: `etc/systemd/network/wired.${host}.network`,
  dst: 'etc/systemd/network/wired.network',
  hosts: ['mimir', 'sleipnir']
}, {
  src: 'etc/systemd/journald.conf.d/size.conf',
  hosts: ['pixelbook', 'mjolnir', 'gungnir']
}, {
  src: 'etc/systemd/system/systemd-resolved-resume.service',
}, {
  src: 'etc/udev/rules.d/99-lowbat.rules',
  hosts: ['pixelbook', 'mjolnir', 'gungnir']
}, {
  src: 'etc/udev/rules.d/99-backlight.rules',
  hosts: ['mjolnir', 'gungnir']
}, {
  src: 'etc/modules-load.d/loopback.conf'
}, {
  src: 'etc/modules-load.d/virtualbox.conf',
  pkgs: ['virtualbox']
}, {
  src: 'etc/modprobe.d/alsa-base.conf',
  hosts: ['pixelbook']
}, {
  src: 'etc/X11/xorg.conf.d/15-dpms.conf'
}, {
  src: 'etc/X11/xorg.conf.d/20-intel.conf',
  pkgs: ['xf86-video-intel']
}, {
  src: `etc/X11/xorg.conf.d/20-intel.${host}.conf`,
  dst: 'etc/X11/xorg.conf.d/20-intel.conf',
  pkgs: ['xf86-video-intel'],
  order: 200,
  hosts: ['pixelbook']
}, {
  src: `etc/X11/xorg.${host}.conf`,
  dst: 'etc/X11/xorg.conf',
  pkgs: ['nvidia'],
  hosts: ['mimir']
}, {
  src: 'etc/pacman.d/hooks/nvidia.hook',
  pkgs: ['nvidia']
}, {
  src: 'etc/X11/xorg.conf.d/10-keyboard.conf',
  pkgs: ['xkeyboard-config-chromebook']
}, {
  src: 'etc/X11/xorg.conf.d/50-synaptics.conf',
  pkgs: ['xf86-input-synaptics'],
  hosts: ['pixelbook']
}, {
  src: 'etc/X11/xorg.conf.d/30-touchpad.conf',
  pkgs: ['xf86-input-libinput'],
  hosts: ['mjolnir', 'gungnir']
}, {
  src: 'etc/X11/xorg.conf.d/50-mtrack.conf',
  pkgs: ['xf86-input-mtrack-git'],
  hosts: ['frigg']
}, {
  src: `${rxrc}/systemd-units/logind.conf.d/acpi.conf`,
  dst: 'etc/systemd/logind.conf.d/acpi.conf'
}, {
  src: `${rxrc}/systemd-units/coredump.conf.d/disable.conf`,
  dst: 'etc/systemd/coredump.conf.d/disable.conf'
}, {
  src: 'etc/systemd/system/chromeos-kbd_backlight.service',
  hosts: ['pixelbook']
}, {
  src: `${rxrc}/systemd-units/system/numlock.service`,
  dst: 'etc/systemd/system/numlock.service'
}, {
  src: `${rxrc}/systemd-units/system/xscreensaver-lock@.service`,
  dst: 'etc/systemd/system/xscreensaver-lock@.service',
  pkgs: ['xscreensaver-arch-logo']
}, {
  src: 'etc/lightdm/lightdm.conf',
  pkgs: ['lightdm']
}, {
  src: 'etc/lightdm/display_setup.sh',
  fmode: '0755',
  pkgs: ['lightdm']
}, {
  src: `etc/lightdm/display_setup.${host}.sh`,
  dst: 'etc/lightdm/display_setup.sh',
  fmode: '0755',
  order: 200,
  pkgs: ['lightdm'],
  hosts: ['mjolnir']
}, {
  src: 'etc/lightdm/lightdm-gtk-greeter.conf',
  pkgs: ['lightdm-gtk-greeter']
}, {
  src: `${rxrc}/archrc-private/etc/samba/smb.${host}.conf`,
  dst: 'etc/samba/smb.conf',
  pkgs: ['samba']
}, {
  src: `${rxrc}/archrc-private/etc/samba/users.${host}.map`,
  dst: 'etc/samba/users.map',
  pkgs: ['samba']
}, {
  src: `${rxrc}/archrc-private/etc/nginx/nginx.${host}.conf`,
  dst: 'etc/nginx/nginx.conf',
  pkgs: ['nginx']
}, {
  src: `${rxrc}/archutil/bin/archutil`,
  dst: 'usr/local/bin/archutil',
  fmode: '0755'
}, {
  src: 'archutil.yml',
  dst: 'usr/local/etc/archutil.yml'
}, {
  src: 'usr/local/bin/xcleanup',
  fmode: '0755',
  pkgs: ['lightdm']
}, {
  src: 'usr/local/bin/touchpad-toggle',
  fmode: '0755',
  pkgs: ['xf86-input-synaptics']
}, {
  src: 'usr/local/bin/chromeos-kbd_backlight',
  fmode: '0755',
  hosts: ['pixelbook']
}, {
  src: 'usr/local/bin/chromeos-sound-output-toggle',
  fmode: '0755',
  hosts: ['pixelbook']
}]

const symlinks = []

export default {
  unlinks,
  directories,
  files,
  symlinks,
  targetRoot,
  ioType,
  pkgType,
  defaults
}
