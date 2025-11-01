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

const unlinks = []

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
  src: 'etc/security/faillock.conf'
}, {
  src: 'etc/sysctl.d/99-sysctl.conf'
}, {
  src: `${rxrc}/archrc-private/etc/fstab.${host}`,
  dst: 'etc/fstab'
}, {
  src: `${rxrc}/archrc-private/loader/loader.conf`,
  dst: 'boot/loader/loader.conf',
  hosts: ['gungnir', 'freyja', 'fenrir', 'sleipnir', 'frigg']
}, {
  src: `${rxrc}/archrc-private/loader/entries/arch.${host}.conf`,
  dst: 'boot/loader/entries/arch.conf',
  hosts: ['gungnir', 'freyja', 'fenrir', 'sleipnir', 'frigg']
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
  hosts: ['fenrir', 'sleipnir', 'frigg']
}, {
  src: 'etc/systemd/journald.conf.d/size.conf',
}, {
  src: 'etc/systemd/system/systemd-resolved-resume.service',
}, {
  src: 'etc/udev/rules.d/50-zsa.rules',
}, {
  src: 'etc/xdg/reflector/reflector.conf',
  pkgs: ['reflector']
}, {
  src: 'etc/udev/rules.d/99-lowbat.rules',
  hosts: ['gungnir']
}, {
  src: 'etc/udev/rules.d/99-backlight.rules',
  hosts: ['gungnir']
}, {
  src: 'etc/modules-load.d/loopback.conf'
}, {
  src: 'etc/modules-load.d/virtualbox.conf',
  pkgs: ['virtualbox']
}, {
  src: 'etc/X11/xorg.conf.d/15-dpms.conf'
}, {
  src: 'etc/X11/xorg.conf.d/20-intel.conf',
  pkgs: ['xf86-video-intel']
}, {
  src: `etc/X11/xorg.conf.d/10-monitor.${host}.conf`,
  dst: 'etc/X11/xorg.conf.d/10-monitor.conf',
  order: 200,
  hosts: ['freyja']
}, {
  src: `etc/X11/xorg.conf.d/20-intel.${host}.conf`,
  dst: 'etc/X11/xorg.conf.d/20-intel.conf',
  pkgs: ['xf86-video-intel'],
  order: 200,
  hosts: ['gungnir', 'freyja']
}, {
  src: 'etc/pacman.d/hooks/nvidia.hook',
  pkgs: ['nvidia']
}, {
  src: 'etc/X11/xorg.conf.d/10-keyboard.conf',
  pkgs: ['xkeyboard-config-chromebook']
}, {
  src: 'etc/X11/xorg.conf.d/30-touchpad.conf',
  pkgs: ['xf86-input-libinput'],
  hosts: ['gungnir']
}, {
  src: `${rxrc}/systemd-units/logind.conf.d/acpi.conf`,
  dst: 'etc/systemd/logind.conf.d/acpi.conf'
}, {
  src: `${rxrc}/systemd-units/coredump.conf.d/disable.conf`,
  dst: 'etc/systemd/coredump.conf.d/disable.conf'
}, {
  src: `${rxrc}/systemd-units/system/numlock.service`,
  dst: 'etc/systemd/system/numlock.service'
}, {
  src: 'etc/lightdm/lightdm.conf',
  pkgs: ['lightdm']
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
