# Manual Configuration Notes

$> sudo groupadd plugdev
$> sudo usermod -aG plugdev $USER

## Bumblebee

Add user to bumblebee group with

```bash
$ gpasswd -a $USER bumblebee
```

In `/etc/bumblebee/bumblebee.conf` add

```
[driver-nvidia]
# Module name to load, defaults to Driver if empty or unset
KernelDriver=nvidia
PMMethod=bbswitch
```

In `/etc/bumblebee/xorg.conf.nvidia` set BusID via `lspci`
(e.g. `PCI:01:00:0`).
