FROM docker.io/library/alpine:3

ARG IMG_NAME
ARG IMG_TAG
ARG LANG=ko_KR.UTF-8
ARG TZ=Asia/Seoul

ENV IMG_NAME=$IMG_NAME
ENV IMG_TAG=$IMG_TAG
ENV LANG=$LANG
ENV TZ=$TZ

ENV JENKINS_VERSION=$IMG_TAG

RUN apk update && \
    apk add tzdata curl openssh-client ttf-dejavu openjdk11 \
      docker-cli docker-cli-compose docker-cli-buildx git gradle maven make && \
    mkdir -p /usr/local/jenkins /var/jenkins_home && \
    curl -L https://get.jenkins.io/war-stable/$JENKINS_VERSION/jenkins.war \
      -o /usr/local/jenkins/jenkins.war && \
    addgroup -g 1000 jenkins && \
    adduser -u 1000 -D -H -S -G jenkins -h /var/jenkins_home jenkins && \
    chown -R jenkins:jenkins /var/jenkins_home && \
    ln -sf /usr/share/zoneinfo/$TZ /etc/localtime

COPY entrypoint.sh /entrypoint.sh

WORKDIR /var/jenkins_home

USER jenkins:jenkins

EXPOSE 8080/tcp
VOLUME /var/jenkins_home

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "run" ]
