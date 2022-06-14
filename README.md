# Jenkins Automation Server

## Jenkins License

The MIT License

See https://github.com/jenkinsci/jenkins and https://www.jenkins.io/changelog/

## Dockerfile License

It's just free. (Public Domain)

See https://github.com/yidigun/jenkins

## Supported tags

Base OS is changed to [Ubuntu](https://hub.docker.com/_/ubuntu) from ```2.332.3```.
And default locale and timezone also changed to ```en_US.UTF-8``` and ```Etc/UTC```.

* ```2.332.3```, ```latest```
* ```2.319.3``` (not supported)

## Use Image

Prepare data volume. (set uid:gid to 1000:1000)

```shell
mkdir -p /data/jenkins/home
sudo chown -R 1000:1000 /data/jenkins/home
```

Create container.

```shell
docker run -d \
  --name jenkins \
  -e LANG=ko_KR.UTF-8 \
  -e TZ=Asia/Seoul \
  -v /payh/to/your/jenkins/home:/var/jenins_home \
  -p 8080:8080/tcp \
  docker.io/yidigun/jenkins:latest
```

Check ```secrets/initialAdminPassword``` from /var/jenkins_home (/data/jenkins/home)
and proceed web configuration via http://localhost:8080

### Build tools

* Java ```11.0.15``` in ```/usr/lib/jvm/java-11-openjdk-$ARCH``` (ubuntu bundled)
* Apache Maven ```3.8.6``` in ```/opt/maven```
* Gradle ```7.4.2``` in ```/opt/gradle```
* Apache Ant ```1.10.12``` in ```/usr/share/ant``` (ubuntu bundled)
* Docker CE client ```20.10.17```

### Docker in docker How-to

```docker-ce-cli``` package is installed in this image.
If you wish to build docker image in the container, consider set ```DOCKER_HOST``` variable.

```shell
docker run -d \
  --name jenkins \
  -e LANG=ko_KR.UTF-8 \
  -e TZ=Asia/Seoul \
  -v /payh/to/your/jenkins/home:/var/jenins_home \
  -p 8080:8080/tcp \
  --add-host=docker-host-machine:172.17.0.1 \
  -e DOCKER_HOST=ssh://username@docker-host-machine \
  docker.io/yidigun/jenkins:latest
```

[Docker Remote Config](https://docs.docker.com/engine/security/protect-access/)
needs to generate a "client certificate" for each client. This can annoy you somewhat.

Using SSH connection is much more simple.
Entrypoint script will generate SSH private/public key pair in your ```$JENKINS_HOME``` using ```ssh-keygen```.
You can find public key from ```docker log``` messages or ```$JENKINS_HOME/.ssh/id_rsa.pub```.

```
Genterated SSH Public Key is:
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAB...
```

You can put this public key in ```authorized_keys``` of docker host machine.

## Building

### 1. Build using created builder.

Check downloaded version and modify TAG macro.

```shell
make TAG=2.332.3
```

If you don't want push and just build image.

```shell
make TAG=2.332.3 PUSH=no
```

### 3. Test image

Local build and test image. Specify /var/jenkins_home volume and web port using TEST_ARGS macro.

```shell
mkdir jenkins_home
make test TAG=2.332.3 TEST_ARGS="-v `pwd`/jenkins_home:/var/jenkins_home -p 8080:8080/tcp"
```
