FROM alpine

ENV LC_ALL C.UTF-8

EXPOSE 80 3306

RUN apk update && \
    apk add tzdata && \
    apk add openrc --no-cache

RUN rc-status && touch /run/openrc/softlevel

RUN apk add nginx && \
    apk add mariadb && rc-update add mariadb default && /etc/init.d/mariadb setup && \
    apk add redis && \
    apk add beanstalkd && \
    apk add supervisor && \
    apk add php7-fpm php7-cli php7-redis php7-curl php7-pdo_mysql php7-xml php7-mbstring php7-yaml php7-dev php7-zip php7-gd php7-pecl-mongodb

RUN apk add git && \
    apk add inotify-tools && \
    apk add composer && \
    apk add vim && \
    apk add tmux && \
    apk add ruby && gem source -r https://rubygems.org/ && gem source -a https://gems.ruby-china.com/ && gem install tmuxinator

RUN apk add php7-dom && \
        apk add php7-tokenizer && \
        apk add php7-ctype && \
        apk add php7-tideways_xhprof

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
