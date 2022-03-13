# pi NAS

[![Built With: Love](https://forthebadge.com/images/badges/built-with-love.svg)](https://github.com/arjvik/) [![Designed In: Etch-A-Sketch](https://forthebadge.com/images/badges/designed-in-etch-a-sketch.svg)](https://github.com/arjvik/piNAS/#contains-configuration-for) [![Powered By: Black Magic](https://forthebadge.com/images/badges/powered-by-black-magic.svg)](https://www.docker.com/) [![Uses: Badges](https://forthebadge.com/images/badges/uses-badges.svg)](https://forthebadge.com/)

Containerized (using [docker](https://www.docker.com/products/container-runtime) and [docker-compose](https://docs.docker.com/compose/compose-file/compose-file-v3/)) setup for a Network Attached Storage (NAS) server, meant to run on a Raspberry Pi 4.

### Contains configuration for

- [Traefik Proxy](https://doc.traefik.io/traefik/)
  - Ingress controller proxies requests from single endpoint to other containers
  - Automated HTTPS certificate provisioning via LetsEncrypt
  - Metric monitoring via Traefik Pilot (cloud)
- [SFTPGo Server](https://github.com/drakkan/sftpgo)
  - Serve files to users over SFTP and WebDAV
  - Virtual file system provides shared folder access to all users
  - Password-less login via SSH keys
  - Static SSH host key allows verification through restarts of ephemeral container
- [Samba Server](https://www.samba.org/)
  - Temporary file drop box for IoT devices that don't support the more modern SFTP/WebDAV protocols
  - Restricted to small sub-folder of network share
- [iperf3 Server](https://github.com/esnet/iperf)
  - Allows users to test internal LAN speed and bandwidth
- Custom IP Camera Monitor
  - Dashboard interface to view RSTP IP Cameras
  - [MJPEG servers](https://github.com/blueimp/mjpeg-server) use `ffmpeg` to stream camera feed to browser

- Custom Index Page
  - Provides links and instructions for other services
  - Displays piNAS git commit hash


### External configuration

This docker-compose configuration assumes a [BTRFS](https://btrfs.wiki.kernel.org/index.php/Main_Page) volume mounted at `/mnt/NAS1`, with subvolumes `/@data` and `/@snapshots`.

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
