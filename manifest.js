const os = require('os')

const host = os.hostname().toLowerCase()
const rxrc = 'node_modules/@rxrc'

const io = 'linux'
const pkg = 'pacman'

const unlinks = []

const directories = [{
  src: `${rxrc}/systemd-units/system/user@.service.d`,
  dst: 'etc/systemd/system/user@.service.d'
}]

const files = [{
  src: `etc/mkinitcpio.${host}.conf`,
  pkgs: ['mkinitcpio']
}, {
  src: 'etc/locale.gen'
}, {
  src: 'etc/locale.conf'
}, {
  src: 'etc/sysctl.d/99-sysctl.conf'
}, {
  src: `${rxrc}/archrc-private/etc/fstab.${host}`,
  dst: `etc/fstab`
}, {
  src: `${rxrc}/archrc-private/refind/refind.conf`,
  dst: 'boot/efi/EFI/refind/refind.conf',
  hosts: ['Sleipnir']
}, {
  src: `${rxrc}/archrc-private/refind/refind_linux.${host}.conf`,
  dst: 'boot/refind_linux.conf',
  hosts: ['Sleipnir']
}, {
  src: `${rxrc}/archrc-private/loader/loader.conf`,
  dst: 'boot/efi/loader/loader.conf',
  hosts: ['Frigg']
}, {
  src: `${rxrc}/archrc-private/loader/entries/arch.conf`,
  dst: 'boot/efi/loader/entries/arch.conf',
  hosts: ['Frigg']
}, {
  src: 'etc/default/grub',
  pkgs: ['grub']
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
  pkgs: ['refind-efi']
}, {
  src: `${rxrc}/systemd-units/system/refind-update.service`,
  dst: 'etc/systemd/system/refind-update.service'
}, {
  src: `${rxrc}/systemd-units/system/netctl-auto-resume@.service`,
  dst: 'etc/systemd/system/netctl-auto-resume@.service'
}, {
  src: 'etc/pacman.conf',
  pkgs: ['pacman']
}, {
  src: 'etc/nftables.conf',
  pkgs: ['nftables']
}, {
  src: 'etc/sudoers',
  mod: '0440',
  pkgs: ['sudo']
}, {
  src: 'etc/ssh/sshd_config',
  pkgs: ['openssh']
}, {
  src: 'etc/systemd/network/wired.network',
  hosts: ['Mimir', 'Sleipnir']
}, {
  src: 'etc/systemd/journald.conf.d/size.conf',
  hosts: ['Gungnir']
}, {
  src: 'etc/udev/rules.d/99-lowbat.rules',
  hosts: ['Gungnir']
}, {
  src: 'etc/modules-load.d/virtualbox.conf',
  pkgs: ['virtualbox']
}, {
  src: 'etc/modprobe.d/alsa-base.conf',
  pkgs: ['linux-samus4']
}, {
  src: 'etc/X11/xorg.conf.d/10-monitor.conf',
  hosts: ['Mimir']
}, {
  src: 'etc/X11/xorg.conf.d/15-dpms.conf'
}, {
  src: 'etc/X11/xorg.conf.d/20-intel.conf',
  pkgs: ['xf86-video-intel']
}, {
  src: 'etc/X11/xorg.conf.d/10-keyboard.conf',
  pkgs: ['xkeyboard-config-chromebook']
}, {
  src: 'etc/X11/xorg.conf.d/50-synaptics.conf',
  pkgs: ['xf86-input-synaptics'],
  hosts: ['Gungnir']
}, {
  src: 'etc/X11/xorg.conf.d/50-mtrack.conf',
  pkgs: ['xf86-input-mtrack-git'],
  hosts: ['Frigg']
}, {
  src: `${rxrc}/systemd-units/logind.conf.d/acpi.conf`,
  dst: 'etc/systemd/logind.conf.d/acpi.conf'
}, {
  src: `${rxrc}/systemd-units/coredump.conf.d/disable.conf`,
  dst: 'etc/systemd/coredump.conf.d/disable.conf'
}, {
  src: 'etc/systemd/system/chromeos-kbd_backlight.service',
  pkgs: ['linux-samus4']
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
  src: 'etc/lightdm/lightdm-gtk-greeter.conf',
  pkgs: ['lightdm-gtk-greeter']
}, {
  src: `${rxrc}/archrc-private/etc/samba/smb.conf`,
  dst: 'etc/samba/smb.conf',
  pkgs: ['samba']
}, {
  src: `${rxrc}/archrc-private/etc/samba/users.map`,
  dst: 'etc/samba/users.map',
  pkgs: ['samba']
}, {
  src: `${rxrc}/archrc-private/etc/nginx/nginx.conf`,
  dst: 'etc/nginx/nginx.conf',
  pkgs: ['nginx']
}, {
  src: `${rxrc}/archutil/bin/archutil`,
  dst: 'usr/local/bin/archutil',
  mod: '0755'
}, {
  src: 'archutil.yml',
  dst: 'usr/local/etc/archutil.yml'
}, {
  src: 'usr/local/bin/xcleanup',
  mod: '0755',
  pkgs: ['lightdm']
}, {
  src: 'usr/local/bin/touchpad-toggle',
  mod: '0755',
  pkgs: ['xf86-input-synaptics']
}, {
  src: 'usr/local/bin/chromeos-kbd_backlight',
  mod: '0755',
  pkgs: ['linux-samus4']
}, {
  src: 'usr/local/bin/chromeos-sound-output-toggle',
  mod: '0755',
  pkgs: ['linux-samus4']
}]

const symlinks = []

module.exports = {
  unlinks,
  directories,
  files,
  symlinks,
  io,
  pkg
}
