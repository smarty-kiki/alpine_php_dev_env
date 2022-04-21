#!/bin/bash

if  [ -n "$TIMEZONE" ]
then
    cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime
    echo $TIMEZONE >/etc/timezone
fi

rc-service redis       start 1> /dev/null 2> /tmp/start_error.log &
rc-service mariadb     start 1> /dev/null 2> /tmp/start_error.log &
rc-service php-fpm7    start 1> /dev/null 2> /tmp/start_error.log &
rc-service nginx       start 1> /dev/null 2> /tmp/start_error.log &
rc-service beanstalkd  start 1> /dev/null 2> /tmp/start_error.log &
rc-service supervisord start 1> /dev/null 2> /tmp/start_error.log &

wait

if [ -f "$AFTER_START_SHELL" ]
then
    /bin/bash $AFTER_START_SHELL
fi

tmuxinator init
