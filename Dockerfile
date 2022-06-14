FROM docker.io/yidigun/ubuntu-base:22.04

ARG IMG_NAME
ARG IMG_TAG
ARG LANG=en_US.UTF-8
ARG TZ=Etc/UTC

ENV IMG_NAME=$IMG_NAME
ENV IMG_TAG=$IMG_TAG
ENV LANG=$LANG
ENV TZ=$TZ
ENV GRADLE_VERSION=7.4.2
ENV MAVEN_VERSION=3.8.6
ENV SERVER_PORT=8080

ENV JENKINS_VERSION=$IMG_TAG

RUN apt-get update && \
    apt-get -y install curl ca-certificates gnupg lsb-release jq unzip sudo \
      git make openssh-client openjdk-11-jdk-headless ant && \
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key \
      >/usr/share/keyrings/jenkins-keyring.asc && \
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
      >/etc/apt/sources.list.d/jenkins.list && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
      gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
      >/etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get -y install jenkins=$JENKINS_VERSION docker-ce-cli

RUN mkdir -p /var/jenkins_home && \
    (groupdel jenkins 2>/dev/null; \
    userdel jenkins 2>/dev/null; \
    rmdir /var/lib/jenkins 2>/dev/null; \
    groupadd -g 1000 jenkins && \
    useradd -u 1000 -g jenkins -d /var/jenkins_home jenkins) && \
    chown -R jenkins:jenkins /var/jenkins_home

RUN (cd /opt; \
    curl https://dlcdn.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | \
      tar zxf - && \
    ln -sf apache-maven-$MAVEN_VERSION maven) && \
    (cd /opt; \
    curl -L https://downloads.gradle-dn.com/distributions/gradle-$GRADLE_VERSION-bin.zip \
         -o /tmp/gradle-$GRADLE_VERSION-bin.zip && \
    unzip /tmp/gradle-$GRADLE_VERSION-bin.zip && \
    ln -sf gradle-$GRADLE_VERSION gradle && \
    rm -f /tmp/gradle-$GRADLE_VERSION-bin.zip) && \
    (cd /usr/local/bin; \
    ln -sf /opt/maven/bin/mvn mvn && \
    ln -sf /opt/gradle/bin/gradle gradle)

COPY entrypoint.sh initial-config.sh /

WORKDIR /var/jenkins_home

EXPOSE ${SERVER_PORT}/tcp
VOLUME /var/jenkins_home

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "run" ]
