# lxc-iptag

To use the Proxmox LXC IP-Tag script, run the command below in the shell.
```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/alissonchaves/lxc-iptag/refs/heads/main/lxc-iptag.sh)"
```

The installer requires root and Proxmox VE 8 or 9. It installs the worker at
`/opt/lxc-iptag/lxc-iptag`, its configuration at
`/opt/lxc-iptag/lxc-iptag.conf`, and enables the `lxc-iptag.timer` systemd
timer, which runs every five minutes.

The default configuration accepts private and carrier-grade NAT networks:

```bash
CIDR_LIST=(
  192.168.0.0/16
  172.16.0.0/12
  10.0.0.0/8
  100.64.0.0/10
)
```

Edit the configuration file to change the allowed CIDRs or check intervals.
Runtime state is stored in `/var/lib/lxc-iptag/state` so the intervals remain
effective across the independent systemd timer executions.

To inspect the installation:

```bash
systemctl status lxc-iptag.timer
journalctl -u lxc-iptag.service
```

For development, run the local shell checks with:

```bash
./tests/test.sh
```
