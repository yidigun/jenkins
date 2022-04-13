FROM docker.io/library/centos:7

ARG IMG_NAME
ARG IMG_TAG
ARG LANG=ko_KR.UTF-8
ARG TZ=Asia/Seoul
ARG GRADLE_VERSION=7.4.2
ARG MAVEN_VERSION=3.8.5

ENV IMG_NAME=$IMG_NAME
ENV IMG_TAG=$IMG_TAG
ENV LANG=$LANG
ENV TZ=$TZ

ENV JENKINS_VERSION=$IMG_TAG
ENV GRADLE_VERSION=$GRADLE_VERSION
ENV MAVEN_VERSION=$MAVEN_VERSION

COPY adoptopenjdk.repo /etc/yum.repos.d/
RUN if [ -n "$LANG" ]; then \
      eval `echo $LANG | \
        sed -E -e 's/([a-z]+_[a-z]+)\.([a-z0-9_-]+)/localedef -cf\2 -i\1 \1.\2/i'`; \
    fi; \
    if [ -n "$TZ" -a -f /usr/share/zoneinfo/$TZ ]; then \
      ln -sf /usr/share/zoneinfo/$TZ /etc/localtime; \
    fi; \
    (cd /etc/yum.repos.d; curl -O https://download.docker.com/linux/centos/docker-ce.repo) && \
    yum -y install epel-release && \
    yum -y install adoptopenjdk-11-hotspot docker-ce-cli git make openssh-clients unzip jq && \
    (cd /usr/local; \
    curl -L https://dlcdn.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
      -o /tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    tar zxf /tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    ln -sf apache-maven-$MAVEN_VERSION maven) && \
    (cd /usr/local; \
    curl -L https://downloads.gradle-dn.com/distributions/gradle-$GRADLE_VERSION-bin.zip \
      -o /tmp/gradle-$GRADLE_VERSION-bin.zip && \
    unzip /tmp/gradle-$GRADLE_VERSION-bin.zip && \
    ln -sf gradle-$GRADLE_VERSION gradle) && \
    (cd /usr/local/bin; \
    ln -sf ../maven/bin/mvn mvn && \
    ln -sf ../gradle/bin/gradle gradle) && \
    mkdir -p /usr/local/jenkins /var/jenkins_home && \
    curl -L https://get.jenkins.io/war-stable/$JENKINS_VERSION/jenkins.war \
      -o /usr/local/jenkins/jenkins.war && \
    groupadd -g 1000 jenkins && \
    useradd -u 1000 -g jenkins -d /var/jenkins_home jenkins && \
    chown -R jenkins:jenkins /var/jenkins_home && \
    rm -f /tmp/*.tar.gz /tmp/*.zip && \
    yum clean all && \
    rm -rf /var/cache/yum

COPY entrypoint.sh /entrypoint.sh

WORKDIR /var/jenkins_home

USER jenkins:jenkins

EXPOSE 8080/tcp
VOLUME /var/jenkins_home

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "run" ]
