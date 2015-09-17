# Manual Configuration Notes

## Linux Samus

Refer to the instructions for [linux-samus sound setup.
Most of that configuration is already handled by this configuration.

Some manual steps must be taken to enable full sound support.
In particular, from inside a clone of the repository, initialize with

``` bash
$ cd scripts/setup
$ ALSA_CONFIG_UCM=ucm/ alsaucm -c bdw-rt5677 set _verb HiFi
```

Finally, make sure

```
load-module module-alsa-source device=hw:0,1
load-module module-alsa-source device=hw:0,2
```

exists in `/etc/pulse/default.pa` before the line

```
load-module module-udev-detect
```

[linux-samus sound setup]: https://github.com/raphael/linux-samus#enabling-sound-step-by-step
