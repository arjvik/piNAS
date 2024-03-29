# pi NAS

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
- [Pi-hole DNS Server](https://pi-hole.net/)
  - Caches and monitors DNS queries across the network
  - Redirects external domains to intranet IPs

- [Custom IP Camera Monitor](index/cameras.html)
  - Dashboard interface to view RSTP IP Cameras
  - [MJPEG servers](https://github.com/blueimp/mjpeg-server) use `ffmpeg` to stream camera feed to browser
- [Custom Index Page](index/index.md)
  - Provides links and instructions for other services
  - Displays piNAS git commit hash


### External configuration

This docker-compose configuration assumes a [BTRFS](https://btrfs.wiki.kernel.org/index.php/Main_Page) volume mounted at `/mnt/NAS1`, with subvolumes `/@data` and `/@snapshots`.

Suggested `systemd` unit file to launch at startup (user `rpi` has uid 1000 and this Git repository cloned to `~/piNAS`):

```ini
[Unit]
Description=Launch piNAS Docker services
After=network-online.target
After=docker.service

[Service]
User=rpi
Group=rpi
Type=simple
ExecStartPre=bash -c 'git -C ~/piNAS pull && docker container prune -f'
ExecStart=docker compose -f /home/rpi/piNAS/docker-compose.yml up
ExecStop=docker compose -f /home/rpi/piNAS/docker-compose.yml down

[Install]
WantedBy=multi-user.target
```

When using `netctl` to configure network interfaces on docker host, enable `netctl-wait-online.service` (automatically a dependency of `network-online.target`) to ensure services wait for an established network connection.

A local `.gitignore`d `docker-compose.override.yml` file is used to modify bind-mount paths in order to test configurations on a local machine.

To enable the included `deploy.post-receive.hook` for Heroku-style Git deployment, run the following commands on the server:

```bash
$ git config --local receive.denyCurrentBranch warn
$ ln -sf ../../deploy.post-receive.hook .git/hooks/post-receive
```

Then, add `rpi@<server>:piNAS` as the `deploy` git remote on the dev machine and run `git push deploy` to deploy the latest commit.
