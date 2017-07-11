---
title: Join CentOS into Windows Active Directory Domain
date: 07/11/2017 15:30
categories:
- 学以致用
- CentOS

tags:
- CentOS
- Active Directory
- AD
- Domain
---

This tutorial guides how to join a CentOS machine into a Windows AD (Active Directory) domain.

> Ref: [Join in Windows Active Directory](https://www.server-world.info/en/note?os=CentOS_7&p=realmd) @ [**Server-World**](https://www.server-world.info)

## Prerequisites
- `Windows AD` (Active Directory) domain service reachable.
- `CentOS` machine or virtual machine. (make sure the machine is connected into your LAN)
- Sometimes, according to specific company Domain policy, a fully-qualified machine name should be requested firstly then it can be assigned.

## Install some required packages
Install some required packages as following.
```bash
	sudo yum -y install realmd sssd oddjob oddjob-mkhomedir adcli samba-common
```

## Change hostname `(Optional)`

For example, here I change the hostname to `testvm`
```bash
[root@localhost ~]# hostname testvm
```

<!-- more -->

## Align the machine's DNS to AD's one

- Firstly, check the network interface name, here my network interface name is `eno16777736`.

```bash
[root@testvm ~]# ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eno16777736: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT qlen 1000
    link/ether 00:0c:29:ed:af:0c brd ff:ff:ff:ff:ff:ff
```

- Then change the CentOS DNS to AD's one. (__refer to__: [How to check DNS setting?](https://www.cs.cmu.edu/~help/networking/check-dns-settings.html) )

```bash
# change the DNS to AD's one
[root@testvm ~]# nmcli c modify eno16777736 ipv4.dns xx.xxx.xxx.xxx
[root@testvm ~]# nmcli c down eno16777736; nmcli c up eno16777736
Connection 'eno16777736' successfully deactivated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/0)
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/2)
```

## Discovery AD domain

For example, here the demo AD domain is `domain.hostname.com`

```bash
[root@testvm ~]# realm discover domain.hostname.com
domain.hostname.com
  type: kerberos
  realm-name: DOMAIN.HOSTNAME.COM
  domain-name: domain.hostname.com
  configured: no
  server-software: active-directory
  client-software: sssd
  required-package: oddjob
  required-package: oddjob-mkhomedir
  required-package: sssd
  required-package: adcli
  required-package: samba-common-tools
```

## Join into AD domain

Attempt to Join into domain, should provide AD admin user authentication.

```bash
[root@testvm ~]# realm join -U adminuser --computer-name testvm DOMAIN.HOSTNAME.COM
Password for adminuser:  # AD's Administrator password here
```

Here in CentOS 7, errors may happen as following, because necessary packages are not installed. just go ahead to install them on.  `(Optional)`

``` bash
# errors
See: journalctl REALMD_OPERATION=r1408.50942
realm: Couldn't join realm: Necessary packages are not installed: oddjob, oddjob-mkhomedir, sssd, samba-common-tools

# install on neccessary packages
[root@testvm ~]# yum install -y ddjob oddjob-mkhomedir sssd samba-common-tool
```

## Have a check

> Note: Though joined into domain successfully as above, it may still take some time to sync to take effect for following check. (It takes above 20 minutes in my demo environment.)

- list realms, here should list the domain just added.

```bash
[root@testvm ~]# realm list
domain.hostname.com
  type: kerberos
  realm-name: DOMAIN.HOSTNAME.COM
  domain-name: domain.hostname.com
  configured: kerberos-member
  server-software: active-directory
  client-software: sssd
  required-package: oddjob
  required-package: oddjob-mkhomedir
  required-package: sssd
  required-package: adcli
  required-package: samba-common-tools
  login-formats: %U@domain.hostname.com
  login-policy: allow-realm-logins
```

- Get AD user info

```bash
[root@testvm ~]# id DOMAIN\\XXUSER      # use the REAL ad user here
# expected: list domain user info here
```

- Switch to login via AD user

```bash
[root@testvm ~]# su - DOMAIN\\XXUSER      # use the REAL ad user here
# expected: switched to XXUSER
```

- Print fully-qualified hostname

```bash
[root@testvm ~]# hostname -f
# expected: testvm.domain.hostname.com
```

## Configure to not use fully qualified user name `(Optional)`
It's always to long to use fully qualified AD user name, that it can be configured to NOT. `use_fully_qualified_names = False`.

```bash
[root@testvm ~]# vi /etc/sssd/sssd.conf
# change use_fully_qualified_names to False
use_fully_qualified_names = False

# restart sssd to take effect
[root@testvm ~]# systemctl restart sssd
```