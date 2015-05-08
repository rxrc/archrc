# Arch Linux Configuration

[![Release](https://img.shields.io/github/release/rxrc/archrc.svg)](https://github.com/rxrc/archrc/releases)
[![MIT License](https://img.shields.io/github/license/rxrc/archrc.svg)](./LICENSE.txt)

My Arch Linux configuration managed with [Config Curator] and [archutil].

[archutil]: https://github.com/razor-x/archutil
[Config Curator]: https://github.com/razor-x/config_curator

## Requirements

* [Bower]
* [Ruby] with [Bundler]
* [Zsh]

Note: these requirements are handled automatically
when bootstrapping a new system (see the instructions below).

[Bower]: http://bower.io/
[Bundler]: http://bundler.io/
[Ruby]: https://www.ruby-lang.org/
[Zsh]: http://www.zsh.org/

## Installation and Usage

If you prefer a clean start, clone the `minimal` branch:
it has the same structure and tools but with
a very minimal configuration.
Tagged releases are based on that branch.

### Bootstrapping a new system

Follow the normal install process.
Be sure to set the Hardware clock first

```
# ntpd -qg
# hwclock --systohc --utc
```

Prepare disks, mount partitions, run pacstrap and genfstab.

#### As root

After chroot, install some required packages

```
# pacman-key --init
# pacman-key --populate archlinux
# pacman -S git reflector zsh
```

Update the mirrorlist with reflector, e.g.,

```
# reflector -l 5 -c US -p https --sort rate --save /etc/pacman.d/mirrorlist
# pacman -Syy
# pacman -Su
```

If this repository or any of the Bower dependencies are private,
generate an ssh key pair with

```
# pacman -S openssh
# ssh-keygen -C "$(whoami)@$(hostname)-$(date -I)"
```

and grant read access through the public key.

Clone this with

```
# curl -L https://git.io/vJARg | sh
```

or

```
# git clone https://github.com/rxrc/archrc.git /root/archrc
```

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

At this point you need to create and switch to a non-root user.
This user must have sudo privileges.
For example

```
# useradd -m -G wheel not-root
# passwd not-root
# su -l not-root
```

#### As non-root user

Create your own archrc with

```bash
$ curl -L https://git.io/vJARg | sh
$ cd ~/archrc
```

Again, if this repository or any of the Bower dependencies are private,
generate an ssh key pair with

```bash
$ ssh-keygen -C "$(whoami)@$(hostname)-$(date -I)"
```

and grant read access through the public key.

Install packages with

```bash
$ /usr/local/bin/archutil install --sets main user gui
```

Setup systemd units with

```bash
$ ./units.zsh
```

#### Final tasks

Switch back to root and run the bootstrap script one more time.
This will be needed if you have configuration
that only installs when certain packages are installed.

```
$ logout
# cd ~/archrc
# ./bootstrap.zsh Hostname
# ./units.zsh
```

Remove root's archrc clone with

```
# rm -rf ~/archrc
```

Before first reboot, complete any final tasks, e.g.,
set the root password and configure anything needed to boot.

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

### Updating configuration

After the initial bootstrapping,
configuration should be managed by a normal user.

You can continue using the system Ruby,
or install Ruby with [rbenv] or [RVM].
Bower should be installed manually using [npm].


Install [Bundler] with

```bash
$ gem install bundler
```

Install dependencies with

```bash
$ bower update
$ bundle update
```

Install the configuration with

```bash
$ curate
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

Setup systemd units with

```bash
$ ./units.zsh
```

[npm]: https://www.npmjs.com/
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

This software is provided "as is" and without any express or
implied warranties, including, without limitation, the implied
warranties of merchantibility and fitness for a particular
purpose.
