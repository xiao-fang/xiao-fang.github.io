---
title: Lightweight Docker Image with Node.js + Git Runtime
date: 11/08/2017 10:30
categories:
- 学以致用
- Docker

tags:
- Docker
- Node.Js
- Git
---

It's now very popular and convinient to use `docker` as powerful development and deployment tool. For me, node.js and git are heavily used in daily works.

#### Official Image Variants of Node.js
There are official [`Node`](https://hub.docker.com/_/node/) images on `Docker Hub` with many many tags, as following:
- `9.x.x` / `latest` are the standard images with common packages
- `alpine` bases on very small linux distribution [`Alpine`](https://alpinelinux.org)
- `slim` does not contain the common packages contained in the default tag and only contains the minimal packages needed to run node, highly recommend using the default image of this repository.

Now let's take a look at these images, that `node:alpine` is only ~67MB, and the `node:slim` is 230MB larger, but the `node:lastest` is about 650MB huge!

> If it only need a Node.js runtime, that `node:latest` is too heavy and the `node:slim` is recommened but the `node:alpine` is the most lightweight.

``` bash
# docker images | grep node
node        slim                992fa76c5ada        3 days ago          230 MB
node        alpine              d06e52d14cac        3 days ago          67.4 MB
node        boron               cf1a65507771        3 months ago        656 MB
node        latest              d2ea9785e1cb        3 months ago        665 MB
```

#### `node:alpine` + Git

Now what I need is Node.Js runtime with Git available, so I take `node:alpine` as base image then pre-install the `git`. The `Dockerflie` is as following:

``` docker
FROM node:alpine

LABEL maintainer Fang Xiao <xiao.fang@outlook.com>

RUN apk --update add git openssh && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

CMD ["git", "--help"]
```

It's pretty easy, right. Now I pushed it on [`Docker Hub`](https://hub.docker.com) as [`realedward/node-git-alpine`](https://hub.docker.com/r/realedward/node-git-alpine/), and the source code hosted on https://github.com/xiao-fang/node-git-alpine


``` bash
# docker pull realedward/node-git-alpine
```

Now we can see the size of `realedward/node-git-alpine` image is only about *90MB* ~

``` bash
realedward/node-git-alpine  latest              ae12ac0300d1        18 hours ago        92.8 MB

```