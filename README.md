# Arch Linux Configuration

[![Release](https://img.shields.io/github/release/rxrc/archrc.svg)](https://github.com/rxrc/archrc/releases)

My Arch Linux configuration managed with [Curator] and [archutil].

[archutil]: https://github.com/razor-x/archutil
[Curator]: https://github.com/rxrc/curator

## Requirements

* [Zsh].
* [Node.js] with [npm].

Note: these requirements are handled automatically
when bootstrapping a new system (see the instructions below).

[Node.js]: https://nodejs.org/
[npm]: https://www.npmjs.com/
[Zsh]: https://www.zsh.org/

## Installation and Usage

### Bootstrapping a new system

Follow the normal install process.
Be sure to set the Hardware clock first

```
# timedatectl set-ntp true
# hwclock --systohc --utc
```

Prepare disks, mount partitions, run pacstrap and genfstab.

#### As root

After chroot, install some required packages

```
# pacman-key --init
# pacman-key --populate archlinux
# pacman -S git reflector zsh inetutils openssh
```

For systems with wireless cards:

```
# pacman -S iwd
```

Update the mirrorlist with reflector, e.g.,

```
# reflector -l 5 -c US -p https --sort rate --save /etc/pacman.d/mirrorlist
# pacman -Syy
# pacman -Su
```

Clone this

```
# git clone https://github.com/rxrc/archrc.git /root/archrc
```

Manually install the `sudoers` file

```
# cp /root/archrc/etc/sudoers /etc/sudoers
```

At this point you need to create and switch to a non-root user.
This user must have sudo privileges.
For example

```
# useradd -m -G wheel not-root
# passwd not-root
# su -l not-root
```

Optionally, add this user to the autologin group now,

```
# groupadd -r autologin
# gpasswd -a not-root autologin
```

#### As non-root user

Create your own archrc with

```bash
$ curl -L https://git.io/vJARg | sh
$ cd ~/archrc
```

If this repository or any of the dependencies are private,
generate an ssh key pair with

```bash
$ ssh-keygen -C "$(whoami)@$(hostname)-$(date -I)"
```

and grant read access through the public key.

If you manage `/etc/fstab` with archrc,
and your partitions have changed with a fresh install,
you need to backup the working fstab before bootstrapping
and restore it afterwards.

Bootstrap with

```
# cd ~/archrc
# ./bootstrap.zsh Hostname
```

This will set the hostname to Hostname,
install archutil and Config Curator,
and install the configuration.

Install Aura with

```
# ./aura.zsh
```

Install packages with

```bash
$ /usr/local/bin/archutil install --sets main user gui
```

Setup systemd units with

```bash
$ ./units.zsh
```

#### Final tasks

Run the bootstrap script one more time.
This will be needed if you have configuration
that only installs when certain packages are installed.

```
# ./bootstrap.zsh Hostname
# ./units.zsh
```

Remove root's archrc clone with

```
# rm -rf ~/archrc
```

Before first reboot, complete any final tasks, e.g.,
set the root password and configure anything needed to boot.
Reinstall the `linux` package before rebooting.

#### First boot

Set the hardware clock to UTC and enable systemd-timesyncd sync with

```bash
$ timedatectl set-local-rtc 0
$ timedatectl set-ntp true
```

Set the local timezone, for example

```bash
$ timedatectl set-timezone America/Los_Angeles
```

Additional manual configuration is documented in
[NOTES.md](./NOTES.md).

### Updating configuration

After the initial bootstrapping,
configuration should be managed by a normal user.

Install dependencies with

```bash
$ npm install
```

Install the configuration with

```bash
$ npm start
```

Setup systemd units with

```bash
$ ./units.zsh
```

Alternatively, run all of these commands with

```bash
$ ./install.zsh
```

Install packages with

```bash
$ /usr/local/bin/archutil install --sets main user gui
```

[rbenv]: https://github.com/sstephenson/rbenv
[RVM]: https://rvm.io/

## Contributing

Please submit and comment on bug reports and feature requests.

To submit a patch:

1. Fork it (https://github.com/rxrc/archrc/fork).
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Make changes.
4. Commit your changes (`git commit -am 'Add some feature'`).
5. Push to the branch (`git push origin my-new-feature`).
6. Create a new Pull Request.

## License

These configuration files are licensed under the MIT license.

## Warranty

This software is provided by the copyright holders and contributors "as is" and
any express or implied warranties, including, but not limited to, the implied
warranties of merchantability and fitness for a particular purpose are
disclaimed. In no event shall the copyright holder or contributors be liable for
any direct, indirect, incidental, special, exemplary, or consequential damages
(including, but not limited to, procurement of substitute goods or services;
loss of use, data, or profits; or business interruption) however caused and on
any theory of liability, whether in contract, strict liability, or tort
(including negligence or otherwise) arising in any way out of the use of this
software, even if advised of the possibility of such damage.
