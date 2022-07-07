#!/bin/sh
SU="sudo -E -H -u jenkins -- "

# try to set locale and timezone
if locale -a 2>/dev/null | grep -q "$LANG"; then
  : do nothing
else
  locale-gen $LANG 2>/dev/null
  update-locale LANG=$LANG 2>/dev/null
fi
if [ -n "$TZ" -a -f /usr/share/zoneinfo/$TZ ]; then
  ln -sf /usr/share/zoneinfo/$TZ /etc/localtime
fi

# System configs
JENKINS_HOME=/var/jenkins_home
JAVA_HOME=${JAVA_HOME:-`java -XshowSettings:properties -version 2>&1 > /dev/null | grep 'java.home' | awk '{print $3}'`}
SERVER_PORT=${SERVER_PORT:-8080}
export JAVA_HOME JENKINS_HOME SERVER_PORT

$SU /initial-config.sh

CMD=$1; shift
case $CMD in
  start|run)
    exec $SU /usr/bin/jenkins --httpPort=${SERVER_PORT} --javaHome="${JAVA_HOME}"
    ;;

  sh|bash|/bin/sh|/bin/bash|/usr/bin/bash)
    exec /bin/sh "$@"
    ;;

  *)
    echo usage: "$0 { start [ args ... ] | sh [ args ... ] }"
    ;;

esac
