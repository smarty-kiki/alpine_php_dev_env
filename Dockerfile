FROM alpine:3.15.6

ENV LC_ALL C.UTF-8

EXPOSE 80 3306

RUN apk update && \
    apk add bash && \
    apk add tzdata && \
    apk add openrc --no-cache

RUN rc-status && touch /run/openrc/softlevel

RUN apk add nginx
RUN apk add mariadb
RUN rc-update add mariadb default
RUN /etc/init.d/mariadb setup
RUN apk add redis
RUN apk add beanstalkd
RUN apk add supervisor
RUN apk add php7-fpm
RUN apk add php7-cli
RUN apk add php7-redis
RUN apk add php7-curl
RUN apk add php7-pdo_mysql
RUN apk add php7-xml
RUN apk add php7-mbstring
RUN apk add php7-yaml
RUN apk add php7-dev
RUN apk add php7-zip
RUN apk add php7-gd
RUN apk add php7-pecl-mongodb

RUN apk add git
RUN apk add inotify-tools
RUN apk add composer
RUN apk add vim
RUN apk add tmux
RUN apk add ruby
RUN gem source -r https://rubygems.org/
RUN gem source -a https://gems.ruby-china.com/
RUN gem install tmuxinator

RUN apk add php7-dom
RUN apk add php7-tokenizer
RUN apk add php7-ctype
RUN apk add php7-tideways_xhprof
RUN apk add php7-phar

RUN git -C /var/www/ clone https://github.com/laynefyc/xhgui-branch.git && \
    cd /var/www/xhgui-branch && \
    php install.php

COPY ./config/nginx_config_xhgui /etc/nginx/http.d/xhgui.conf

COPY ./shell/config_init.sh /tmp/config_init.sh
RUN /bin/bash /tmp/config_init.sh

COPY ./config/bashrc /root/.bashrc
COPY ./config/tmux.conf /root/.tmux.conf

RUN mkdir -p /root/.tmuxinator
COPY ./config/tmuxinator_init.yml /root/.tmuxinator/init.yml

COPY ./shell/start.sh /bin/start
RUN chown root:root /bin/start && \
        chmod +x /bin/start

CMD start
