#!/bin/bash

ROOT_DIR="$(cd "$(dirname $0)" && pwd)"

sed -i -e "s/^zlib\.output_compression\ = .*/zlib\.output_compression = \On/g" /etc/php7/php.ini
sed -i -e "s/^;max_input_vars\ = .*/max_input_vars\ =\ 20000/g" /etc/php7/php.ini
sed -i -e "s/^listen\ = .*/listen = \/var\/run\/php-fpm\.sock/g" /etc/php7/php-fpm.d/www.conf
sed -i -e "s/^error_log\ = .*/error_log = \/var\/log\/php7\/error\.log/g" /etc/php7/php-fpm.conf
sed -i -e "s/^bind\-address/#bind\-address/g" /etc/my.cnf.d/mariadb-server.cnf

mkdir -p /var/log/mysql
chown -R mysql:mysql /var/log/mysql

cat << EOF >>/etc/my.cnf
general_log=On
general_log_file=/var/log/mysql/mysql_log.log
slow_query_log=On
slow_query_log_file=/var/log/mysql/slow.log
log_error=On
log_error=/var/log/mysql/error.log
log_slow_verbosity=query_plan,explain
log-queries-not-using-indexes
query_cache_limit = 0M
query_cache_size = 0M
skip-name-resolve
long_query_time = 0.5
EOF

sed -i -e "s/^JOB_SIZE=.*/JOB_SIZE=\"524280\"/g" /etc/conf.d/beanstalkd
sed -i -e "s/'extension'.*$/'extension'\ =>\ 'tideways_xhprof',/g" /var/www/xhgui-branch/config/config.default.php
sed -i -e "s/'db\.host'.*$/'db\.host'\ =>\ 'mongodb\:\/\/mongo\:27017',/g" /var/www/xhgui-branch/config/config.default.php
