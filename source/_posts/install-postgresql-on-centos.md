---
title: How to Install PostgreSQL on CentOS 7?
date: 05/11/2017 17:00
categories:
- 学习笔记
tags:
- CentOS
- PostgreSQL
---


### Installation

CentOS's default repositories contain Postgres packages, so we can install them without a hassle using the yum package system.

#### Install PostgreSQL server and contrib
Install the `postgresql-server` package and the `contrib` package, that adds some additional utilities and functionality.
```bash
$ sudo yum install postgresql-server postgresql-contrib -y
```
#### Initial a PostgreSQL cluster
```bash
$ sudo postgresql-setup initdb
```

> Note: that a default PostgreSQL user account would be created during installation, called `postgres` with the default `Postgres` role.

#### Config host-based authentication
By default, PostgreSQL does not allow password authentication. We will change that by editing its host-based authentication (HBA) configuration. open `pg_hba.conf` with `vi` or other editors.
```
$ sudo vi /var/lib/pgsql/data/pg_hba.conf
```
Find the lines that looks like this, near the bottom of the file:
```bash
#   pg_hba.conf excerpt (original)
host    all             all             127.0.0.1/32            ident
host    all             all             ::1/128                 ident
```
then replace `ident` with `md5`, also add one more record `host     all     all     0.0.0.0/0       md5`, so that the configurations like this:
```bash
#   pg_hba.conf excerpt (updated)
host    all             all             127.0.0.1/32            md5
host    all             all             ::1/128                 md5
host    all             all             0.0.0.0/0               md5
```

#### Enable start on boot (`optional`)
use `systemd` to manage the `postgresql` service to start when the system boots.
```bash
$ sudo systemctl start postgresql
$ sudo systemctl enable postgresql
```

Then check the status of `PostgreSQL`, *Ready Now ~*
```
# systemctl status postgresql
● postgresql.service - PostgreSQL database server
   Loaded: loaded (/usr/lib/systemd/system/postgresql.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2017-04-26 10:26:38 CST; 23h ago
  Process: 35747 ExecStop=/usr/bin/pg_ctl stop -D ${PGDATA} -s -m fast (code=exited, status=0/SUCCESS)
  Process: 35754 ExecStart=/usr/bin/pg_ctl start -D ${PGDATA} -s -o -p ${PGPORT} -w -t 300 (code=exited, status=0/SUCCESS)
  Process: 35748 ExecStartPre=/usr/bin/postgresql-check-db-dir ${PGDATA} (code=exited, status=0/SUCCESS)
 Main PID: 35758 (postgres)
   Memory: 12.9M
   CGroup: /system.slice/postgresql.service
           ├─35758 /usr/bin/postgres -D /var/lib/pgsql/data -p 5432
           ├─35759 postgres: logger process
           ├─35761 postgres: checkpointer process
           ├─35762 postgres: writer process
           ├─35763 postgres: wal writer process
           ├─35764 postgres: autovacuum launcher process
           └─35765 postgres: stats collector process
```

#### Expose to listen to ports (`optional`)
Acctually, that the PostgreSQL is ready now. But if external clients cannot connect to the service, it maybe the default `5432` port not be listen. then edit `postgresql.conf`.
```bash
$ sudo cat /var/lib/pgsql/data/postgresql.conf
```
then change the connection setting `listen_addresses` from default `localhost` to `*`.
```bash
$ listen_addresses = '*'
```

restart postgres to take effect.
```bash
$ systemctl restart postgresql
```

Now take a loot at external connection to `PostgreSQL` via `Navicat` (or any other tools).
![](/uploads/postgres-navicat.jpg)

### Q&A
**Q1. what's the default password for PostgreSQL?**
There is `NO` default password for the default created user `postgres`, because that the default authentication mode for PostgreSQL is `Ident`. (refer to Q2)
```
# IPv4 local connections:
host    all              all             127.0.0.1/32             ident
# IPv6 local connections:
host    all              all             ::1/128                  ident
```

And, as above, **`config host-based authentication`** section we can change default `Ident` authentication mode to `host-based authentication`. then we'd change the password of default user `postgres` with `psql` the `\password {POSTGRES_USER}` command.
```bash
postgres-# \password POSTGRES_USER
Enter new password:
```

**Q2. what's the `Indent` authentication mode for PostgreSQL?**
It works by taking the OS username now operating as, to compare with the `allowed` database username(s). *This means that in order to connect to PostgreSQL you must be logged in as the correct OS user that allowed in PostgreSQL*.

For example, if you login OS as `root`, but the `root` username not allowed in PostgreSQL, that you cannot connect to PostgreSQL, otherwise you can directly connect to it with `psql`.

However, it's available to switch to PostgreSQL users.
```bash
$ sudo -i -u postgres
```
then you can connect to PostgreSQL with `psql`.

### Reference

- [How To Install and Use PostgreSQL on CentOS 7](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-centos-7) [from `DigitalOcean`]

- [connect to PostgreSQL server: FATAL: no pg_hba.conf entry for host](https://dba.stackexchange.com/questions/83984/connect-to-postgresql-server-fatal-no-pg-hba-conf-entry-for-host) [from `StackExchange`]

- [What is the Default Password for PostgreSQL?](https://www.liquidweb.com/kb/what-is-the-default-password-for-postgresql/)
