---
title: Migrate TFS Project to Git
date: 04/27/2017 16:30
category:
tags:
- TFS
- Git
- Git-TF
---


### Requirements

- Git, download [Git for Windows](https://git-scm.com/download/win)
- Git-TF, download [Git-TF](https://gittf.codeplex.com/), add to `PATH` environment variable
- Java runtime (required by Git-TF), add to `PATH` environment variable
- Source TFS project to be migrated, here we name it as `tfs_project`
- A git project, here we name it as `git_project`


### Clone TFS Code
Firstly, `clone` source `tfs_project` to local diretory. `git-tf` command with the optional `--deep` flag may be used to clone each TFS changeset for the specified path into the new git repo.
```batch
git-tf clone "http://<TFS Server Name>:Port/tfs/<CollectionName> "$/TeamProjectName" –deep
```

Some errors may happen here:
#### TFS server certificate validation error
```bash
git-tf: sun.security.validator.ValidatorException: PKIX path building failed: su
n.security.provider.certpath.SunCertPathBuilderException: unable to find valid c
ertification path to requested target
```
> how to fix:

export TFS server certificate as `Base-64 encoded X.509 (.CER)` file, then add it to local JRE trust keystore, because `Git-TF` depends on it.
Maybe there's many version of JRE on your machine, use `java -version` to check current runtime.

```bash
> java -version
java version "1.8.0_111"
Java(TM) SE Runtime Environment (build 1.8.0_111-b14)
Java HotSpot(TM) Client VM (build 25.111-b14, mixed mode, sharing)
```
then use `keytool` to add TFS server certificate to `keystore`.
```bash
C:\Program Files\Java\jre1.8.0_111\bin>keytool -keystore ..\lib\security\cacerts -importcert -file your_servers_cert_file.cer -alias tfs-cert
Enter keystore password: changeit
```
`Notice that default JRE keystore password is ` **changeit**.

<!-- more -->

#### Unable to access remote Git due to SSL certificate

```
fatal: unable to access 'https://evrt-tfspro.houston.entsvcs.net/tfs/TFS03/ES_AS
IAPACIFIC_CN_APPS_GD_Devopsportal/_git/ES_GD_CN_DevOpsPortal/': SSL certificate
problem: unable to get local issuer certificate
```
> how to fix:
```
git config --global http.sslVerify false
```

** Ok, the `tfs_project` code are checkout as git repo successfully now ~ **


### Commit as Git Changes

```bash
git commit -a -m 'initial commit, migrated from TFS'
```

### Add Git Remote

```bash
git remote add origin "http://<TFS Server Name>:Port/tfs/<CollectionName>/<Team>/_git/<TeamProjectName>"
```
then validate the `remote`
```bash
git remote -v
```

### Other Git Actions
Since that the remote TFS source is already migrated to git locally, any other git actions could be taken at anytime ~

### Git Push

Then the changes migrated from TFS could be pushed to git remote. (as above, any git actions as needed)

```bash
git push origin master -f
```

**Ok, the `git_project` is pushed to TFS git successfully now ~**

![](/uploads/tfs-git.jpeg)


### `.gitignore` for .NET project
Generally, the source `tfs_project` may target on .NET platform, maybe Visual Studio project, there is useful `.gitignore` shared by [Official GitHub](https://github.com/github) on [visualstudio.ignore](https://github.com/github/gitignore/blob/master/VisualStudio.gitignore) for your reference.

### Reference
- [Git-TF](https://gittf.codeplex.com/)