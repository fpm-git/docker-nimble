Update build and push
=======================
Check what the latest version is, https://softvelum.com/nimble/install/. I just do the following
```
jonathon@jonathon-framework:~/git/docker-nimble$ sudo apt-get install nimble -s 
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  libzip4
The following NEW packages will be installed:
  libzip4 nimble
0 upgraded, 2 newly installed, 0 to remove and 12 not upgraded.
Inst libzip4 (1.7.3-1ubuntu2 Ubuntu:22.04/jammy [amd64])
Inst nimble (4.1.0-9 jammy [amd64])
Conf libzip4 (1.7.3-1ubuntu2 Ubuntu:22.04/jammy [amd64])
Conf nimble (4.1.0-9 jammy [amd64])
```

Then run the following

```
jonathon@jonathon-framework:~/git/docker-nimble$ docker build -t ghcr.io/fpm-git/docker-nimble:v1.0.0upv4.1.0-9 .
[+] Building 0.6s (9/9) FINISHED                                                                                                                                                                                                                                           docker:default
 => [internal] load .dockerignore                                                                                                                                                                                                                                                    0.0s
 => => transferring context: 2B                                                                                                                                                                                                                                                      0.0s
 => [internal] load build definition from Dockerfile                                                                                                                                                                                                                                 0.0s
 => => transferring dockerfile: 829B                                                                                                                                                                                                                                                 0.0s
 => [internal] load metadata for docker.io/phusion/baseimage:jammy-1.0.1                                                                                                                                                                                                             0.5s
 => [1/4] FROM docker.io/phusion/baseimage:jammy-1.0.1@sha256:7faf4efcd96870fe090d969703ef8e727cc9de4f465c8442047ffd26f8094e6b                                                                                                                                                       0.0s
 => [internal] load build context                                                                                                                                                                                                                                                    0.0s
 => => transferring context: 225B                                                                                                                                                                                                                                                    0.0s
 => CACHED [2/4] RUN    echo "deb http://nimblestreamer.com/ubuntu jammy/" > /etc/apt/sources.list.d/nimble.list     && curl -L -s http://nimblestreamer.com/gpg.key | apt-key add -     && apt-get update     && DEBIAN_FRONTEND=noninteractive apt-get install -y nimble     && a  0.0s
 => CACHED [3/4] ADD files/my_init.d /etc/my_init.d                                                                                                                                                                                                                                  0.0s
 => CACHED [4/4] ADD files/service /etc/service                                                                                                                                                                                                                                      0.0s
 => exporting to image                                                                                                                                                                                                                                                               0.0s
 => => exporting layers                                                                                                                                                                                                                                                              0.0s
 => => writing image sha256:49ec766e3cb34c7005bd72f20867838bf73f8c08bb2574523048a38a3230dae9                                                                                                                                                                                         0.0s
 => => naming to ghcr.io/fpm-git/docker-nimble:v1.0.0upv4.1.0-9                                                                                                                                                                                                                      0.0s
jonathon@jonathon-framework:~/git/docker-nimble$ docker push ghcr.io/fpm-git/docker-nimble:v1.0.0upv4.1.0-9
The push refers to repository [ghcr.io/fpm-git/docker-nimble]
168b81f88f0e: Layer already exists 
7f0453e9bbd5: Layer already exists 
c0f70acc00dd: Layer already exists 
bcb7e1bba665: Layer already exists 
31ee2011b350: Layer already exists 
7f5cbd8cc787: Layer already exists 
v1.0.0upv4.1.0-9: digest: sha256:c1c8acc9fa598e3202c8827611b07d78f25f0f4086d4e41d2711f53666e349fd size: 1576
```


Nimble streaming server
=======================

This container provides a [nimble](https://es.wmspanel.com/nimble) streaming server listening on ports **8081** (http) and **1935** (RTMP).

Nimble is "freemium" software, it is freely distributed but must be managed through the [WMSPanel Portal](https://wmspanel.com/). You will need to get an account to be able to use this application.

Usage
-----

From Docker registry:

```
docker pull rjrivero/nimble
```

Or build yourself:

```
git clone https://github.com/rjrivero/docker-nimble.git
docker build --rm -t rjrivero/nimble docker-nimble
```

Running the image:

```
docker run --rm -p 8081:8081 -p 1935:1935 \
    -h instance-hostname \
    -e WMSPANEL_USER=your@user.name \
    -e WMSPANEL_PASS=your_password  \
    --name nimble rjrivero/nimble
```

Configuration
-------------

All configuration is managed through the WMSPanel portal. The first time you run the container, you must provide your portal credentials to have the server register itself. You provide the credentials through the following environment variables:

  - **WMSPANEL_USER**: WMSPanel portal username, e.g. your@email.com
  - **WMSPANEL_PASS**: WMSPanel password.
  - **WMSPANEL_SLICES**: Optional, list of slices to register this server to.

The container registers the server and stores all configuration settings under */etc/nimble/*. You may want to have that path mounted from an external volume.

Once */etc/nimble/nimble.conf* is populated with the right account and key data, you no longer need to provide the username and password as environment variables to the container.

If you change your username and/or password, and need to register the server again, you should remove the */etc/nimble/nimble.conf* file and restart the container, providing the new user and pass.

Volumes
-------

You may want to mount to external volumes to the following paths:

  - */etc/nimble*: This is the configuration folder. It is bootstrapped the first time you run the container with a WMSPanel username and password.
  - */var/cache/nimble*: This is used to save temporary files and stats.

The ownership of both paths is changed to the user **nimble** before starting the service.

Ports
-----

The container exposes ports **8081** (HTTP) and **1935** (RTMP)
