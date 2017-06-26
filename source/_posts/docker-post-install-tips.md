---
title: General Post-Installation Steps for Docker on CentOS
date: 04/25/2017 16:00
categories:
- 学习笔记
- Docker
tags:
- CentOS
- Docker
- Docker CE
- DevOps
- Linux
---

<blockquote class="blockquote-center" >
Original Post: [Post-installation steps for Linux](https://docs.docker.com/engine/installation/linux/linux-postinstall/)
by `Docker`
</blockquote>

### Manage Docker as a non-root user
* The docker daemon binds to a Unix socket instead of a TCP port. By default that Unix socket is owned by the user root and other users can only access it using sudo. The docker daemon always runs as the root user.
* If you don’t want to use sudo when you use the docker command, create a Unix group called docker and add users to it. When the docker daemon starts, it makes the ownership of the Unix socket read/writable by the docker group.

When use docker commands as a non-root (or sudo) role, `permission denined` as following.
```log
# use docker command as non-root(or equal) role
$ docker images
# Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.27/images/json: dial unix /var/run/docker.sock: connect: permission denied
```

> **Warning**: The `docker` group grants privileges equivalent to the `root` user.

To create the docker group and add your user:
* Create the `docker` group.
```bash
$ sudo groupadd docker
```
* Add your user to the `docker` group.
```bash
$ sudo usermod -aG docker YOUR_USER_NAME
```
* Log out and log back in so that your group membership is re-evaluated.

* Verify that you can run **any** `docker` commands without `sudo`.

<!-- more -->

### Configure Docker to start on boot
> Most current Linux distributions (RHEL, CentOS, Fedora, Ubuntu 16.04 and higher) use `systemd` to manage which services start when the system boots. Ubuntu 14.10 and below use upstart.

#### systemd
```bash
# enable start on boot
$ sudo systemctl enable docker
# Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.

# disable start on boot
$ sudo systemctl disable docker
# Removed symlink /etc/systemd/system/multi-user.target.wants/docker.service
```
#### chkconfig
Use `chkconfig` to check the config status of `Docker`.
```bash
$ chkconfig docker
# Note: Forwarding request to 'systemctl is-enabled docker.service'.
# enabled
```

### References
[Post-installation steps for Linux](https://docs.docker.com/engine/installation/linux/linux-postinstall/)
[How To Use Systemctl to Manage Systemd Services and Units](https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units)