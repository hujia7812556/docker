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
    && echo "deb http://ftp.cn.debian.org/debian stretch main" >> /etc/apt/sources.list \
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
    && apt-get install -y zip \
    && apt-get install -y unzip \
    ####redis
    && yes | pecl install igbinary -o -f \
    && apt-get update && yes | pecl install -o -f redis  \
    ###xhprof
    && git clone https://github.com/longxinH/xhprof.git /tmp/xhprof \
    && cd /tmp/xhprof/extension/ \
    && /usr/local/bin/phpize \
    && ./configure --with-php-config=/usr/local/bin/php-config \
    && make && make install \
    && rm -rf /var/tmp/xhprof && mkdir /var/tmp/xhprof && chmod -R 777 /var/tmp/xhprof \
    ####xdebug
    && apt-get update && yes | pecl install -o -f xdebug \
    # oauth
    && apt-get install -y libpcre3 libpcre3-dev \
    && yes | pecl install oauth \
    # gmp
    && apt-get -y install libgmp-dev \ 
    && docker-php-ext-install gmp
RUN cd /tmp \
    && rm -rf ./php-7.1.28 \
    && tar zxvf ./php-7.1.28.tar.gz \
    ##sockets
    && cd php-7.1.28/ext/sockets/ \
    && phpize && \
    ./configure \
    --enable-sockets \
    --with-php-config=/usr/local/bin/php-config \
    && make clean && make && make install \
    && cp -f modules/sockets.so /usr/local/lib/php/extensions/no-debug-non-zts-20160303 \
    ##bz2
    && apt-get install -y libbz2-dev \
    && cd /tmp/php-7.1.28/ext/bz2/ \
    && phpize && \
    ./configure \
    --with-php-config=/usr/local/bin/php-config \
    && make clean && make && make install \
    ##imap
    && apt-get update && apt-get install -y libc-client-dev libkrb5-dev \
    && cd /tmp/php-7.1.28/ext/imap/ \
    && phpize && \
    ./configure \
    --with-php-config=/usr/local/bin/php-config \
    --with-kerberos \
    --with-imap-ssl \
    && make clean && make && make install \
    ##libmemecached
    && cd /tmp \
    && curl -O https://launchpadlibrarian.net/165454254/libmemcached-1.0.18.tar.gz \
    && tar zxvf ./libmemcached-1.0.18.tar.gz \
    && cd libmemcached-1.0.18 \
    && ./configure \
    --prefix=/usr/local/libmemcached \
    && make clean && make && make install \
    ##memcached
    && apt-get install zlib1g \
    && apt-get install zlib1g.dev \
    && cd /tmp \
    && curl -o php-memcached.zip https://codeload.github.com/php-memcached-dev/php-memcached/zip/master \
    && unzip ./php-memcached.zip \
    && cd php-memcached-master \
    && phpize && \
    ./configure \
    --with-php-config=/usr/local/bin/php-config \
    --with-libmemcached-dir=/usr/local/libmemcached \
    --disable-memcached-sasl \
    && make clean && make && make install \
    ## opcache
    && cd /tmp/php-7.1.28/ext/opcache/ \
    && phpize && \
    ./configure \
    --with-php-config=/usr/local/bin/php-config \
    && make clean && make && make install
RUN yes | pecl install swoole -o -f
RUN yes | pecl install apcu -o -f
RUN apt-get install graphviz -y
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer