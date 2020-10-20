---
title: Quick Start A Local-Hosted K8S Environment
date: 10/20/2020
categories:
- 学习笔记
- K8S

tags:
- Kubernetes
- minikube
- CentOS
- Kubectl
---

# Quick Start A Local-Hosted K8S Environment

*Kubernetes* (K8S) is an open-source system for automating deployment, scaling, and management of containerized applications, which is now graduated from [CNCF](https://www.cncf.io/). 

All cloud service providers like AWS, Azure, Aliyun, Tecent Cloud are now providing cloud-based and easy-to-use K8S infrastructure.

Here use [minikue](https://minikube.sigs.k8s.io/docs/start/) to quick start a new local K8S environment for development.

![K8S Architecture](https://raw.githubusercontent.com/kubernetes/kubernetes/587d164307de060d271f10f2386f39153360fba9/docs/design/architecture.svg)

## Requirements

`Minikube` supports container or virtual machine manager, such as [Docker, Hyperkit, Hyper-V, KVM, Parallels, Podman, VirtualBox, or VMWare](https://minikube.sigs.k8s.io/docs/start/#what-youll-need). 

I start from CentOS 7 VM (*2+CPU, 4GB memory, 20+GB disk*).

- Install `Docker` 
  - refer to [Install Docker Engine on CentOS](https://docs.docker.com/engine/install/centos/)

- Install Kubectl
  - refer to [Install and Set Up kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

- Install minikube
  - refer to [minikube start](https://minikube.sigs.k8s.io/docs/start/)

## Start a new cluster

From a terminal with administrator access (but not logged in as root), run `minikube start`:

``` bash
$ minikube start
* minikube v1.14.0 on Centos 7.8.2003
* Automatically selected the docker driver
* Starting control plane node minikube in cluster minikube
* Creating docker container (CPUs=2, Memory=2200MB) ...
* Preparing Kubernetes v1.19.2 on Docker 19.03.8 ...
* Verifying Kubernetes components...
* Enabled addons: default-storageclass, storage-provisioner
* Done! kubectl is now configured to use "minikube" by default
```

if run as `root`, will throw following error:

```bash
# minikube start
* minikube v1.14.0 on Centos 7.8.2003
* Automatically selected the docker driver
* The "docker" driver should not be used with root privileges.
* If you are running minikube within a VM, consider using --driver=none:
*   https://minikube.sigs.k8s.io/docs/reference/drivers/none/

X Exiting due to DRV_AS_ROOT: The "docker" driver should not be used with root privileges.
```

After `minikube start`, let's check `minikube status`:
```bash
$ minikube status
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
```

What happens behind? `minikube start`s a new docker container named *minikube* from image `gcr.io/k8s-minikube/kicbase:v0.0.13`. the *minikube* container is the only one `node` of current K8S cluster. 

Deep dive into the `minikube` container, actually it's also a docker environment runs a minimal set components (as containers/`pods`) of k8s cluster **inside**, like *controller manager, scheduler, etcd, apiserver, proxy, coredns, storage provisioner, metric scraper, dashboard, etc* (refer to above *K8S Architecture*).

```bash
# following scripts to see k8s inside, not neccessary steps to start a k8s cluster

# minikube start a new container named minikube
$ docker ps
CONTAINER ID        IMAGE                                 COMMAND                  CREATED             STATUS              PORTS                                                                                                      NAMES
22353255b3d8        gcr.io/k8s-minikube/kicbase:v0.0.13   "/usr/local/bin/entr…"   5 minutes ago       Up 5 minutes        127.0.0.1:32779->22/tcp, 127.0.0.1:32778->2376/tcp, 127.0.0.1:32777->5000/tcp, 127.0.0.1:32776->8443/tcp   minikube

# the minikube is the only one node of current K8S cluster
$ kubectl get no -A
NAME       STATUS   ROLES    AGE     VERSION
minikube   Ready    master   6m18s   v1.19.2

# dive into the minikube container, actually there are a minimal components of k8s cluster, like,
# controller manager, scheduler, etcd, apiserver, proxy, coredns, storage provisioner, metric scraper, dashboard, etc.
$ docker exec -it minikube bash
# above equal to command 'minikube ssh' to login the minikube environment as docker user
root@minikube:$ docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Names}}"
CONTAINER ID        IMAGE                  NAMES
2c96ab880751        bad58561c4be           k8s_storage-provisioner_storage-provisioner_kube-system_f6123384-ac90-49cd-93e2-f99d9e243542_0
c42638327a87        k8s.gcr.io/pause:3.2   k8s_POD_storage-provisioner_kube-system_f6123384-ac90-49cd-93e2-f99d9e243542_0
d31089f8f566        bfe3a36ebd25           k8s_coredns_coredns-f9fd979d6-g8vjq_kube-system_cfe2bef7-f7a1-4aa4-9c93-1383d69c4293_0
26f42373a94b        d373dd5a8593           k8s_kube-proxy_kube-proxy-rsw7l_kube-system_8ea9d442-8d6d-4c00-b272-df32d0fc3e5d_0
7b94b2d4e6e5        k8s.gcr.io/pause:3.2   k8s_POD_coredns-f9fd979d6-g8vjq_kube-system_cfe2bef7-f7a1-4aa4-9c93-1383d69c4293_0
dbabb0c1f811        k8s.gcr.io/pause:3.2   k8s_POD_kube-proxy-rsw7l_kube-system_8ea9d442-8d6d-4c00-b272-df32d0fc3e5d_0
f6f333c19a28        607331163122           k8s_kube-apiserver_kube-apiserver-minikube_kube-system_f7c3d51df5e2ce4e433b64661ac4503c_0
a0a8ee250949        0369cf4303ff           k8s_etcd_etcd-minikube_kube-system_d186e6390814d4dd7e770f47c08e98a2_0
4940ac2f1f0c        2f32d66b884f           k8s_kube-scheduler_kube-scheduler-minikube_kube-system_ff7d12f9e4f14e202a85a7c5534a3129_0
9815051dbc4b        8603821e1a7a           k8s_kube-controller-manager_kube-controller-manager-minikube_kube-system_dcc127c185c80a61d90d8e659e768641_0
59b8793a0a3e        k8s.gcr.io/pause:3.2   k8s_POD_kube-apiserver-minikube_kube-system_f7c3d51df5e2ce4e433b64661ac4503c_0
c0becce7b87d        k8s.gcr.io/pause:3.2   k8s_POD_etcd-minikube_kube-system_d186e6390814d4dd7e770f47c08e98a2_0
49f74073f3f3        k8s.gcr.io/pause:3.2   k8s_POD_kube-scheduler-minikube_kube-system_ff7d12f9e4f14e202a85a7c5534a3129_0
eaad3ec1c277        k8s.gcr.io/pause:3.2   k8s_POD_kube-controller-manager-minikube_kube-system_dcc127c185c80a61d90d8e659e768641_0
```
> So we can have a quick view that *minikube* created a docker container with all neccessary k8s compoments inside, the container plays as the single *node* of k8s *cluster*.

## K8S Dashboard and Proxy

*minikube* bundles the K8S [Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/), a Web UI allows us to get easily management to the K8S enviroment:

```bash
# start a dashboard at backend
# it will try to open default brower
minikube dashboard
$ minikube dashboard &
* Enabling dashboard ...
* Verifying dashboard health ...
* Launching proxy ...
* Verifying proxy health ...
* Opening http://127.0.0.1:44278/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/ in your default browser...
  - http://127.0.0.1:44278/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/

# optional to forward it to vm host with default 8081 port, or '--port=xxxx' to specify another port
$ kubectl proxy --address='0.0.0.0' --disable-filter=true &
Request filter disabled, your proxy is vulnerable to XSRF attacks, please be cautious
Starting to serve on [::]:8001

# or start dashboard and proxy at backend at the same time
minikube dashboard & kubectl proxy --address='0.0.0.0' --disable-filter=true &
```

![K8S Dashboard](https://d33wubrfki0l68.cloudfront.net/349824f68836152722dab89465835e604719caea/6e0b7/images/docs/ui-dashboard.png)

visit dashboard via: `http://{localhost-or-forwarded-host}:8001/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/#/workloads?namespace=_all`

## Deploy Applications

K8S manages *containered* applications, based on images from public registries like [DockerHub](https://hub.docker.com/) and also private regitries.

Here is our private registry, plain HTTP without SSL, for internal use only.
```ini
# our private registry, for internal use only
registry: chszctnr02:8082
user: dockeradmin
pass: 123456
```

### Use Privacy Registry

As we see that minikube starts a node in container, we can use `kubectl` to manage credential to registry as `secret`.

If the registry is a insecure registry (HTTP, not HTTPS), minikube can start with `--insecure-registry` option to pass into k8s nodes, e.g.
`minikube start --insecure-registry=chszctnr02:8082`

```bash
# create namespace, e.g. cecs
$ kubectl create namespace cecs
namespace/cecs created

# create secret for private registry
$ kubectl create secret docker-registry chszctnr02-registry --docker-server=chszctnr02:8082 --docker-username=dockeradmin --docker-password=123456 --namespace cecs

# (optional) configure minikube
$ minikube config set insecure-registry chszctnr02:8082

# (optional) view minikube config
$ minikube config view
- insecure-registry: chszctnr02:8082

# then try to start minikube with --insecure-registry option
$ minikube start --insecure-registry=chszctnr02:8082

# if above minikube start with --insecure-registry does not work
# do `minikube delete` first and try again
```

Then we can create k8s `workload` with `yaml` spec,
```yaml
spec:
  #...
  template:
    spec:
      container:
        - name: some-app
          image: 'chszctnr02:8082/somenamespace/someapp:tag'  # image for private registry
      imagePullSecrets:
        - name: chszctnr02-registry                           # private registry secret name
  #...
```

(Optional) If  use private regitry from AWS, Azure, DockerHub, `minikube` offers the `registry-creds` addon to easily haddle the credentials. Please refer to [minikube: Using a Private Registry](https://minikube.sigs.k8s.io/docs/handbook/registry/).

(Optional) If we use `docker` directly without `kubectl`, following steps to use an insecure registry.

```bash
# (optional) login to private registry
# it will store credential in ~/.docker/config.json
$ docker login chszctnr02:8082
Username: dockeradmin
Password: 
WARNING! Your password will be stored unencrypted in /home/edworks/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

# (optional) trust insecure-registries, and restart docker ()
$ vi /etc/docker/daemon.json 
{
  "insecure-registries" : ["chszctnr02:8082"]
}

# restart docker to take effects
$ systemctl restart docker
```

### Deployment

Now it's a k8s environment ready to deploy applications on your own ~

Following content are our own project deployments.

- Bundle all config items into one `ConfigMap` to easily manage configs
  
```bash
# create a configmap holds all config files for specific Environment
# (optional) set item key (e.g. app-settings) to specific config file, otherwise the item key should be the same with file name(e.g. appsettings.Development.json)
$ kubectl create configmap is-sts-conf-dev \ 
--from-file app-settings=./appsettings.Development.json \ 
--from-file portal-settings=./portal.Development.json \ 
--from-file serilog-settings=serilog.Development.json \ 
--namespace cecs
# configmap/is-sts-conf-dev created
```

- [Using ConfigMaps as files from a pod](https://kubernetes.io/docs/concepts/configuration/configmap/#using-configmaps-as-files-from-a-pod)

```yaml
#create a deployment (partial, the volumes and mounts)
spec:
      volumes:
        - name: app-conf-volume                       # mount ConfigMap in a volume
          configMap:
            name: is-sts-conf-files-prod
            defaultMode: 420
      containers:
        - name: dev-nop
          image: 'chszctnr02:8082/echosens-cecs/is-sts:0.dev.0.201019.ed1730bb'
          env:
            - name: ASPNETCORE_ENVIRONMENT
              value: Development
          resources: {}
          volumeMounts:
            - name: app-conf-volume
              mountPath: /app/portal.json             # target file in container
              subPath: portal.Development.json        # source item in ConfigMap
            - name: app-conf-volume
              mountPath: /app/appsettings.json
              subPath: appsettings.Development.json
            - name: app-conf-volume
              mountPath: /app/serilog.json
              subPath: serilog.Development.json
```

then apply to deveployment, we can see the configmap items will be map to pods/containers, like:

``` bash
# dive into pod:
# config items will be map into pods/container, OVERWRITE if exists
root@pod: /app $ ls | grep json
appsettings.json
portal.json
serilog.json

# if .spec.containers[].volumeMounts[].subPath is not speficifed, it will map all items to a dir
```

- Create Secret to store senstive informations such as passwords, tokens, ssk keys.

`Secret` used with a Pod in three ways: 
  a. a file in `volume` mounted to pods
  b. as container environment variable
  c. by the `kubelet` when pulling images (see above registry secret)

```bash
# create secret --from-file or --from-literal
kubectl create secret generic localhost-cert \ 
--from-file cert-file=./localhost.pfx \ 
--from-literal cert-pass=somepass \ 
--namespace cecs

#secret/localhost-cert created, type is Opaque
$ kubectl get secrets -n cecs | grep cert
localhost-cert        Opaque    2     11m
```

```yaml
spec:
      volumes:
        - name: cert-volume                 # secret as a volume
          secret:
            secretName: localhost-cert      # the secret name
      containers:
        - name: is-sts
          image: 'chszctnr02:8082/echosens-cecs/is-sts:1.0.8.200929.3226b1e1'
          env:
            - name: ASPNETCORE_ENVIRONMENT
              value: Development
            - name: CertificateConfiguration__PfxFilePassword
              valueFrom:                    # usage#b, value from secret item as a env variable
                secretKeyRef:
                    key: cert-pass          # the key to secret
                    name: localhost-cert    # the secret name
                    optional: false
          resources: {}
          volumeMounts:
            - name: cert-volume             # usage#a, mount secret as files
              mountPath: /app/cert          # all items in secret will be map to files under this dir, here, /app/cert/cert-file, /app/cert-pass.
```

then apply to deveployment, we can see the secret will be map to pods/containers, like:

``` bash
# dive into pod:
# usage#b, the raw secret item was set to env variable
/app# env | grep Pfx
CertificateConfiguration__PfxFilePassword=somepass

# usage#a, the secret items were map to files.
/app# ls ./cert
cert-file  cert-pass
```

- Create a Service to expose as network service

`Service` is an abstract way to expose an application runing on a set of Pods as a network service, more about service please refer to [Kubernetes Serviece](https://kubernetes.io/docs/concepts/services-networking/service/).

```yaml
# expose pod 80 port to service 80 port
apiVersion: v1
kind: Service
metadata:
  name: is-sts-service
  namespace: cecs
spec:
  selector:
  app: MyApp
  ports:
  - name: 80-80-tcp
    port: 80              # incoming port
    protocol: TCP
    targetPort: 80        # expose port
  type: NodePort
```

then apply, we can see we can see a `service` is created.

```bash
# a service is created
$ kubectl get svc -n cecs
NAMESPACE    NAME               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)              AGE
cecs         is-sts-service     NodePort    10.104.125.235   <none>        80:30971/TCP         2m30s
```

Usually, for deployement, we can use `kubectl port-forward` to expose deployment directly without service.

- Port forwarding to access applications in a K8S cluster

```bash
# forward deployment 80 to expose 8080
$ kubectl -n cecs --address 0.0.0.0 port-forward deployment/is-sts 8080:80
# port is forwarding
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
# handle requests
Handling connection for 8080

# (optional) open firewall port
$ firewall-cmd --add-port=8080/tcp --permanent
$ firewall-cmd --reload
```

## Reference

- [Install Docker Engine on CentOS](https://docs.docker.com/engine/install/centos/)
- [Install and Set Up kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [minikube start](https://minikube.sigs.k8s.io/docs/start/)
- [minikube Drivers](https://minikube.sigs.k8s.io/docs/drivers/)
- [Using a Private Registry / Enabling Insecure Registries](https://minikube.sigs.k8s.io/docs/handbook/registry/)
- [Using ConfigMaps as files from a Pod](https://kubernetes.io/docs/concepts/configuration/configmap/#using-configmaps-as-files-from-a-pod)
- [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- [Kubernetes Serviece](https://kubernetes.io/docs/concepts/services-networking/service/)
- [Kubectl Commands Reference](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands)
- [Understanding Kubernetes Architecture With Diagrams](https://phoenixnap.com/kb/understanding-kubernetes-architecture-diagrams)
- [How To Open A Port In CentOS / RHEL 7](https://www.thegeekdiary.com/how-to-open-a-ports-in-centos-rhel-7/#:~:text=How%20To%20Open%20A%20Port%20In%20CentOS%20%2F,firewall%20ports%205.%20Check%20newly%20added%20port%20status)
