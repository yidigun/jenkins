# Jenkins Automation Server

## Jenkins License

The MIT License

See https://github.com/jenkinsci/jenkins and https://www.jenkins.io/changelog/

## Dockerfile License

It's just free. (Public Domain)

See https://github.com/yidigun/jenkins

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
  -v /data/jenkins/home:/var/jenins_home \
  -p 8080:8080/tcp \
  -e DOCKER_HOST=dind:2375 \
  --network dind \
  docker.io/yidigun/jenkins:latest
```

Check ```secrets/initialAdminPassword``` from /var/jenkins_home (/data/jenkins/home)
and proceed web configuration via http://localhost:8080

## Building

### 1. Build using created builder.

Check downloaded version and modify TAG macro.

```shell
make TAG=2.319.2
```

If you don't want push and just build image.

```shell
make TAG=2.319.2 PUSH=no
```

### 3. Test image

Local build and test image. Specify /var/jenkins_home volume and web port using TEST_ARGS macro.

```shell
mkdir jenkins_home
make test TAG=2.319.2 TEST_ARGS="-v `pwd`/jenkins_home:/var/jenkins_home -p 8080:8080/tcp -e DOCKER_HOST=dind:2375 --network=dind"
```
