#!/bin/sh

# System configs
LANG=${LANG:=ko_KR.UTF-8}
TZ=${TZ:-Asia/Seoul}
JENKINS_HOME=/var/jenkins_home
JAVA_HOME=${JAVA_HOME:-`java -XshowSettings:properties -version 2>&1 > /dev/null | grep 'java.home' | awk '{print $3}'`}
export LANG TZ JAVA_VERSION JAVA_HOME JENKINS_HOME

CMD=$1; shift
case $CMD in
  start|run)
    exec $JAVA_HOME/bin/java \
      -DJENKINS_HOME="$JENKINS_HOME" \
      -Djava.awt.headless=true \
      $JAVA_OPTS \
      -jar /usr/local/jenkins/jenkins.war "$@"
    ;;

  sh|bash|/bin/sh|/bin/bash|/usr/bin/bash)
    exec /bin/sh "$@"
    ;;

  *)
    echo usage: "$0 { start [ args ... ] | sh [ args ... ] }"
    ;;

esac
