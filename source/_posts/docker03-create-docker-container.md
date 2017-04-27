---
title: Docker03 - Create a Docker Container
date: 04/27/2017 01:00
categories:
- Docker
tags:
- Docker
- CentOS
- Container
- DevOps
- Linux
---

Let's take Docker official example as demo, refer to [Get Started, Part 2: Containers](https://docs.docker.com/get-started/part2/).
*(demo codes also come from this official post)*

### Define a `Container` with a `Dockerfile`
Learn more about `Dockerfile`, please refer to official wiki.
- [`Dockerfile` Reference](https://docs.docker.com/engine/reference/builder/)
- [`Dockerfile` Best Practice](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/)

### Create an app itself

As for demo, here is a python web app, getting started with hello world, it contains two files `app.py` and its `requirements.txt`.

```bash
# tree .
.
├── app.py
├── Dockerfile
└── requirements.txt
```

### Build `Dockerfile` and its app into `Image`

then the folder structure of the python-web app is:
> `Dockerfile` define/describle how the app could be built into an docker `image`.

<!-- more -->

#### Before a `Docker Build`
before any docker containers or images created, the `docker images -a` and `docker ps -a` list `no any image and no any containers` also.

```
# docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE

# cat /var/lib/docker/image/overlay/repositories.json
{"Repositories":{}}
```

At the same time, take a loot at the status of docker lib `/var/lib/docker`, it seems that there's nothing under image / containers / swarm.

```bash
# tree /var/lib/docker/
/var/lib/docker/
├── containers
├── image
│   └── overlay
│       ├── distribution
│       │   ├── diffid-by-digest
│       │   │   └── sha256
│       │   │       └── 78445dd45222097f5f8d5a16e48dc19c4ca162dcdb80010ab6f1ccfc7e2c0fa3
│       │   └── v2metadata-by-diffid
│       │       └── sha256
│       ├── imagedb
│       │   ├── content
│       │   │   └── sha256
│       │   └── metadata
│       │       └── sha256
│       ├── layerdb
│       │   ├── mounts
│       │   ├── sha256
│       │   └── tmp
│       └── repositories.json
├── swarm
├── tmp
├── trust
└── volumes
    └── metadata.db
```
#### Build a Docker Image
Then build Dockerfile and associated files into `image` via `docker build -t pythonweb .`.
```
$ docker build -t pythonweb .

Sending build context to Docker daemon 4.608 kB
......
Step 7/7 : CMD python app.py
 ---> Running in 363f11978b86
 ---> c55347aa7def
Removing intermediate container 363f11978b86
Successfully built c55347aa7def
```
Shown as above build log, some `intermediate containers` were created and then were removed at the end, finally, a new build image with the id `c55347aa7def` was created.

#### After a `Docker Build`
Ok, let's check docker images and containers and document libs again, see what happens after a `docker build`.
```
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
pythonweb           latest              c55347aa7def        13 minutes ago      194 MB
python              2.7-slim            4a323b466a5a        43 hours ago        182 MB
```
Shown as above, there are two images `pythonweb` and `python`, so the `pythonweb` is the one we just build, and the `python` with tag `2.7-slim` is what our `pythonweb` depends on and defined in the `Dockerfile` as following.
``` python
# Use an official Python runtime as a base image
FROM python:2.7-slim
```
Then let's check the docker lib `/var/lib/docker/image/overlay/repositories.json`, shows docker image repositories.
```json
# cat /var/lib/docker/image/overlay/repositories.json
{"Repositories":{"python":{"python:2.7-slim":"sha256:4a323b466a5ac4ce65248dd970b538922c54e535700cafe9448b52a3094483ea","python@sha256:2185f75c1dfb1852f04126da57dfe807d608bbebf782f49782009a881c48ab89":"sha256:4a323b466a5ac4ce65248dd970b538922c54e535700cafe9448b52a3094483ea"},"pythonweb":{"pythonweb:latest":"sha256:c55347aa7def1cd290274456f3ce9cadaac68991bc4c40e8868f554476fabe21"}}}
```
Also, massive directories and files were `copied` *(maybe not that correct, would investigate further later)* into `/var/lib/docker/overlay/` directory...

### Run the App
Now a new created/built docker image is ready, let's run it.

As the `pythonweb` app `EXPOSE` d port `80` inner, then mapping to local machine (docker engine host machine)'s port, like `4000`.
Firstly check if local port `4000` is already allocated yet.

```bash
netstat -plnt | grep 4000
```

then run the app

```bash
docker run -p 4000:80 pythonweb
```
As we can see the `pythonweb` app is running now ~

```bash
$ docker run -p 4000:80 pythonweb
 * Running on http://0.0.0.0:80/ (Press CTRL+C to quit)
 ```

Open a browser then visit `hostname:4000`, here logs the http requests.

 ```log
192.168.226.1 - - [27/Apr/2017 00:36:54] "GET / HTTP/1.1" 200 -
192.168.226.1 - - [27/Apr/2017 00:36:54] "GET /favicon.ico HTTP/1.1" 404 -
192.168.226.1 - - [27/Apr/2017 00:37:10] "GET / HTTP/1.1" 200 -
```

The browser shows..
![](/uploads/docker03-create-container-01.png)

And also, see what happens to `Docker` after run an app.
* a new `docker container` was created with the app's image, that bind a local port `4000` to container's `EXPOSE` port `80`.

```bash
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                  NAMES
050bf22ff4c5        pythonweb           "python app.py"     7 minutes ago       Up 7 minutes        0.0.0.0:4000->80/tcp   upbeat_rosalind
```

* then take a look at port `4000`, listen by a program named `docker-proxy`.

```bash
[root@devops edworks]# netstat -plnt | grep 4000
tcp6       0      0 :::4000                 :::*                    LISTEN      61649/docker-proxy
```

* and a new directory with long-long uuid created under `/var/lib/docker/containers/`, there are `log`, `checkpoints`,`config`,`hostname`,`hosts`,`resove.conf`,`shm`, etc.
I'd checked the `hostname` it's the `container-id`.

```bash
# tree /var/lib/docker/containers/
/var/lib/docker/containers/
└── 050bf22ff4c5775fb6904e9ffd035a40af006347ff1e1b6bae5d651d9cc5b12b
    ├── 050bf22ff4c5775fb6904e9ffd035a40af006347ff1e1b6bae5d651d9cc5b12b-json.log
    ├── checkpoints
    ├── config.v2.json
    ├── hostconfig.json
    ├── hostname
    ├── hosts
    ├── resolv.conf
    ├── resolv.conf.hash
    └── shm
```

#### Run the app at `quiet` mode

Let's go back, when the app started, shows `Running on http://0.0.0.0:80/ (Press CTRL+C to quit)` as log, so when current session is break/quit, the app would be stopped.

- To start a container in `detached` mode, you use `-d=true` or just `-d` option. By design, containers started in detached mode exit when the root process used to run the container exits
- To reattach to a detached container, use docker attach command.
- Refer to [Detached (-d)](https://docs.docker.com/engine/reference/run/#detached--d)


#### Stop / Start a Docker `Container`

- Docker `run` can always creates a new container.
- Docker `start` or `stop` can stop / start an existing container without creating a new.
- References:
    - [docker `stop`](https://docs.docker.com/engine/reference/commandline/stop/)
    - [docker `start`](https://docs.docker.com/engine/reference/commandline/start/)
    - [docker `run`](https://docs.docker.com/engine/reference/commandline/run/)

### Q&A

> Q: Can the same app run with multiple containers, how to assign the port?
A: Yes the same app `can` run with multiple containers, but should be assigned to `different ports` if on same docker host machine, otherwise the container`would be created but cannot run`.

Run the app to bind a allocated port, that Error: `failed: port is already allocated.`
```bash
$ docker run -p 4000:80 pythonweb
docker: Error response from daemon: driver failed programming external connectivity on endpoint distracted_knuth (43bd1b6d4140ea22abd7eb5243f9f1573ac6e8ffacd952b23ec16a4c59c63a54): Bind for 0.0.0.0:4000 failed: port is already allocated.
```
Run the app to bind not container's `EXPOSE` port, that `app running successfully in container, but the app sevice cannot be accesss` due to `miss-configured EXPOSE d port`
```
$ docker run -p 4040:88 pythonweb
 * Running on http://0.0.0.0:80/ (Press CTRL+C to quit)
```

> ** Notice: that even a `failed: port is already allocated` error happens the `container` could be also created successfully with the status `Created`. **

```
$ docker run -p 4000:80 pythonweb
docker: Error response from daemon: driver failed programming external connectivity on endpoint gifted_raman (16eecc637261d89a20be1827aeba135c5472b5b4a0055f2a1c035be5152add38): Bind for 0.0.0.0:4000 failed: port is already allocated.

$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS                  NAMES
b263cc629e40        pythonweb           "python app.py"     16 seconds ago       Created                                    gifted_raman
```

> Q: If a port already allocated, can the app runs anyway?
A: The container would be also created, but it cannot be allocated the port and cannot run. (as above).


### Notes

### Outlines:
- Docker01 - Hello, Docker
    - What's Docker
    - What's Container
        - [What's Container](https://www.docker.com/what-container)
        - [What's containerd](https://containerd.io/)
        - Container vs VM
        - References
- Docker02 - Install Docker on CentOS 7
- Docker03 - Create a Docker Container
- Docker04 - Docker Service