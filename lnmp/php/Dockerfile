FROM php:7.1-fpm

ENV TZ=Asia/Shanghai

COPY ./php-7.1.28.tar.gz /tmp/

RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
	######更换国内镜像######3#
	&& mv /etc/apt/sources.list /etc/apt/sources.list.bak \
	&& echo "deb http://mirrors.aliyun.com/debian/ stretch main non-free contrib" > /etc/apt/sources.list \
	&& echo "deb-src http://mirrors.aliyun.com/debian/ stretch main non-free contrib" >> /etc/apt/sources.list \
	&& echo "deb http://mirrors.aliyun.com/debian-security stretch/updates main" >> /etc/apt/sources.list \
	&& echo "deb-src http://mirrors.aliyun.com/debian-security stretch/updates main" >> /etc/apt/sources.list \
	&& echo "deb http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib" >> /etc/apt/sources.list \
	&& echo "deb-src http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib" >> /etc/apt/sources.list \
	&& echo "deb http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib" >> /etc/apt/sources.list \
	&& echo "deb-src http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install git -y \
    ####
    && apt-get install -y vim \
    && echo "set number" >> /root/.vimrc \
    ###ll命令##
    && echo "alias ll='ls -l'" >> ~/.bashrc && /bin/bash -c "source ~/.bashrc" \
    ###ps命令###
    && apt-get update && apt-get install -y procps \
    ####依赖安装###### 
    && apt-get install -y libssl-dev \
    ####redis
    && yes | pecl install igbinary -o -f \
    && apt-get update && yes | pecl install -o -f redis  \
    ###xhprof
    && git clone https://github.com/longxinH/xhprof.git /tmp/xhprof \
    && cd /tmp/xhprof/extension/ \
    && /usr/local/bin/phpize \
    && ./configure --with-php-config=/usr/local/bin/php-config \
    && make && make install \
    ####xdebug
    && apt-get update && yes | pecl install -o -f xdebug
RUN cd /tmp \
    && rm -rf ./php-7.1.28 \
    && tar zxvf ./php-7.1.28.tar.gz \
    && cd php-7.1.28/ext/sockets/ \
    && phpize && \
    ./configure \
    --enable-sockets \
    --with-php-config=/usr/local/bin/php-config \
    && make clean && make && make install \
    && cp -f modules/sockets.so /usr/local/lib/php/extensions/no-debug-non-zts-20160303
RUN yes | pecl install swoole -o -f