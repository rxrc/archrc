# Arch Linux Configuration

[![MIT License](https://img.shields.io/badge/license-MIT-red.svg)](./LICENSE.txt)

My Arch Linux configuration managed with [Config Curator] and [archutil].

[archutil]: https://github.com/razor-x/archutil
[Config Curator]: https://github.com/razor-x/config_curator

## Requirements

* [Bower]
* [Ruby]
* [Zsh]

[Bower]: http://bower.io/
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

```bash
ntpd -qg
hwclock --systohc --utc
```

Prepare disks, mount partitions, run pacstrap and genfstab.

#### As root

After chroot, install some required packages

```bash
$ pacman -S git reflector zsh
```

Update the mirrorlist with reflector, e.g.,

```bash
$ reflector -l 5 -c US -p https --sort rate --save /etc/pacman.d/mirrorlist
$ pacman -Syy
$ pacman -Su
```

If this repository or any of the Bower dependencies are private,
generate an ssh key pair with `ssh-keygen` and grant read access.

Clone this with

```bash
$ curl -L https://git.io/jguX | sh
```

or

```bash
$ git clone https://github.com/razor-x/archrc.git /root/archrc
```

Bootstrap with

```bash
$ cd ~/archrc
$ ./bootstrap.zsh Hostname
```

This will set the hostname to Hostname,
install archutil and Config Curator,
and install the configuration.

Install Aura with

```bash
$ ./aura.zsh
```

At this point you need to create and switch to a non-root user.
This user must have sudo privileges.
For example

```bash
$ useradd -m -G wheel not-root
$ passwd not-root
$ su -l not-root
```

#### As non-root user

Remove root's archrc clone and create your own with

```bash
$ sudo rm -rf /root/archrc
$ curl -L https://git.io/jguX | sh
$ cd ~/archrc
```

Install packages with

```bash
$ /usr/local/bin/archutil install --sets main
```

Setup systemd units with

```bash
$ ./units.zsh
```

Before first reboot, complete any final tasks, e.g.,
set the root password and configure anything needed to boot.

### Updating configuration

After the initial bootstrapping,
configuration should be managed by a normal user.

You can continue using the system Ruby,
or install Ruby with [rbenv] or [RVM].

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
$ /usr/local/bin/archutil install --sets main
```

Setup systemd units with

```bash
$ ./units.zsh
```

[rbenv]: https://github.com/sstephenson/rbenv
[RVM]: https://rvm.io/
[Bundler]: http://bundler.io/

## Contributing

Please submit and comment on bug reports and feature requests.

To submit a patch:

1. Fork it (https://github.com/razor-x/archrc/fork).
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
