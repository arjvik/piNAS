# Pi NAS

Containerized (using [docker](https://www.docker.com/products/container-runtime) and [docker-compose](https://docs.docker.com/compose/compose-file/compose-file-v3/)) setup for a NAS server, meant to run on a Raspberry Pi 4.

### Contains configuration for

- [SFTPGo server](https://github.com/drakkan/sftpgo)
  - Serve files to users over SFTP and WebDAV
  - Virtual file system used to provide shared folder access to all users
  - Password-less login allowed via SSH keys
  - Static SSH host key allows verification through restarts of ephemeral container
- [Samba server](https://www.samba.org/)
  - Used as a temporary file drop box for IoT devices that don't support the more modern and secure SFTP/WebDAV protocols
  - Restricted to only a small sub-folder of network share
- [iperf3 server](https://github.com/esnet/iperf)
  - Allows users to test internal LAN speed and bandwidth

### External configuration

This docker-compose configuration assumes a [BTRFS](https://btrfs.wiki.kernel.org/index.php/Main_Page) volume mounted at `/mnt/NAS1`, with subvolumes `/@data` and `/@snapshots`.

For best results, enable mDNS advertising (through [Avahi](https://github.com/lathiat/avahi)) on the container host to allow it to be discovered by other devices and thus used without a static IP address.

Suggested `systemd` unit file to launch at startup (user `rpi` has uid 1000 and this Git repository cloned to `~/PiNAS`):

```ini
[Unit]
Description=Launch PiNAS Docker services
After=network-online.target
After=docker.service

[Service]
User=rpi
Group=rpi
Type=simple
ExecStart=bash -c 'git -C ~/PiNAS pull && docker container prune -f && exec docker-compose -f ~/PiNAS/docker-compose.yml up'

[Install]
WantedBy=multi-user.target
```

A local `.gitignore`d `docker-compose.override.yml` file is used to modify bind-mount paths in order to test configurations on a local machine.