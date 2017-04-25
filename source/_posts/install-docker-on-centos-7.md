---
title: Install Docker On CentOS 7
date: 04/25/2017 14:00
categories:
- Notes
- DevOps
tags:
- CentOS
- Docker
- Docker CE
- DevOps
---

Here are the quick steps to get started with Docker on CentOS, now install `Docker CE` on `CentOS` 7.

### Prerequisites
* 64-bit version of CentOS 7

#### Update CentOs as Latest

Firstly, update `CentOS` to latest.
```bash
$ sudo yum update
```
#### Config Web Proxy on CentOs
Sometimes, network connection errors may happen if it's in Intranet environment, here a web proxy should be configured for yum. Please refer to [Configuring Web Proxy on CentOS](http://www.thesysadminhimself.com/2013/08/configuring-web-proxy-on-centos.html). *[Optional]*
Here it's only yum should be configured a web proxy for me, as following.
```bash
# vi /etc/yum.conf
proxy=http://proxy-server-host:port
# notice: the proxy should NOT be ended with '/'
```

#### Uninstall old Versions
Older versions of Docker were called `docker` or `docker-engine`. If these are installed, uninstall them, along with associated dependencies.
```bash
$ sudo yum remove docker docker-common container-selinux docker-selinux docker-engine
```

### Install Docker CE via Repository

#### Install `yum-utils`, which provides the `yum-config-manager` utility:
```bash
$ sudo yum install -y yum-utils
$ sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
$ sudo yum makecache fast
```

<!-- more -->

#### Install Docker CE

```bash
$ sudo yum install docker-ce
```

#### Start Docker

``` bash
$ sudo systemctl start docker
```
#### Test Docker installation
Now verify the docker installation by running a `hello-world` container.
``` bash
$ sudo docker run hello-world
```
Generally, it will show logs as following, that's a new `hello-world` image pulled from docker library.
``` log
$ sudo docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
78445dd45222: Pull complete
Digest: sha256:c5515758d4c5e1e838e9cd307f6c6a0d620b5e07e6f927b07d05f6d12a1ac8d7
Status: Downloaded newer image for hello-world:latest
```
Then use `docker images` command to list images, the `hello-world` image was just downloaded.
``` log
$ sudo docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
hello-world         latest              48b5124b2768        3 months ago        1.84 kB
```
### Uninstall Docker

> In case of uninstalling docker.

#### Uninstall Docker CE package
``` bash
$ 	sudo yum remove docker-ce
```
#### Remove related resources
* Images, containers, volumes, or customized configuration files on your host are not automatically removed. To delete all images, containers, and volumes:

```bash
$ sudo rm -rf /var/lib/docker
```

* Any other edited configurations should be deleted manually.

### Reference
 * [Configuring Web Proxy on CentOS](http://www.thesysadminhimself.com/2013/08/configuring-web-proxy-on-centos.html)
 * [Get Docker for CentOS](https://docs.docker.com/engine/installation/linux/centos/)
 * [Docker Community Edition for CentOS](https://store.docker.com/editions/community/docker-ce-server-centos?tab=description)