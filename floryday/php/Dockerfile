FROM php:7.1-fpm

ENV TZ=Asia/Shanghai

COPY ./php-7.1.28.tar.gz /tmp/

RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update \
    && apt-get install -y --allow-remove-essential libtinfo5
RUN apt-get update && apt-get install -y libssl-dev
RUN apt-get update && apt-get install -y libssl-doc
RUN apt-get install git -y

RUN apt-get install -y vim \
    && echo "set number" >> /root/.vimrc \
    ###ll命令##
    && echo "alias ll='ls -l'" >> ~/.bashrc && /bin/bash -c "source ~/.bashrc" \
    ###ps命令###
    && apt-get update && apt-get install -y procps
    ####依赖安装###### 
#RUN && apt-get install -y libssl-dev \
RUN apt-get install -y zip \
    && apt-get install -y unzip
    ####redis
RUN yes | pecl install igbinary -o -f \
    && apt-get update && yes | pecl install -o -f redis
    ###xhprof
RUN git clone https://github.com/longxinH/xhprof.git /tmp/xhprof \
    && cd /tmp/xhprof/extension/ \
    && /usr/local/bin/phpize \
    && ./configure --with-php-config=/usr/local/bin/php-config \
    && make && make install \
    && rm -rf /var/tmp/xhprof && mkdir /var/tmp/xhprof && chmod -R 777 /var/tmp/xhprof
    ####xdebug
RUN apt-get update && yes | pecl install -o -f xdebug
    # oauth
RUN apt-get update \
    && apt-get install -y libpcre3-dev \
    && yes | pecl install oauth
    # gmp
RUN apt-get -y install libgmp-dev \ 
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
    && cp -f modules/sockets.so /usr/local/lib/php/extensions/no-debug-non-zts-20160303
    ##bz2
RUN apt-get install -y libbz2-dev bzip2-doc \
    && cd /tmp/php-7.1.28/ext/bz2/ \
    && phpize && \
    ./configure \
    --with-php-config=/usr/local/bin/php-config \
    && make clean && make && make install
    ##imap
RUN apt-get install -y libc-client-dev libkrb5-dev \
    && cd /tmp/php-7.1.28/ext/imap/ \
    && phpize && \
    ./configure \
    --with-php-config=/usr/local/bin/php-config \
    --with-kerberos \
    --with-imap-ssl \
    && make clean && make && make install
    ##libmemecached
RUN apt install -y libmemcached-dev
    ##memecached
RUN apt-get install zlib1g \
    && apt-get install zlib1g.dev \
    && cd /tmp \
    && curl -o php-memcached.zip https://codeload.github.com/php-memcached-dev/php-memcached/zip/master \
    && unzip ./php-memcached.zip \
    && cd php-memcached-master \
    && phpize && \
    ./configure \
    --with-php-config=/usr/local/bin/php-config \
    --disable-memcached-sasl \
    && make clean && make && make install
    ## opcache
RUN cd /tmp/php-7.1.28/ext/opcache/ \
    && phpize && \
    ./configure \
    --with-php-config=/usr/local/bin/php-config \
    && make clean && make && make install
RUN yes | pecl install swoole -o -f
RUN yes | pecl install apcu -o -f
RUN apt-get install graphviz -y
RUN yes | pecl install mongodb
##rabbitmq
RUN apt-get install cmake -y
RUN cd /tmp && rm -rf rabbitmq-c-0.9.0 && \
    curl -o rabbitmq-c-0.9.0.tar.gz https://codeload.github.com/alanxz/rabbitmq-c/tar.gz/v0.9.0 && \
    tar zxvf rabbitmq-c-0.9.0.tar.gz && \
    cd rabbitmq-c-0.9.0 && mkdir build && cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local/librabbitmq .. && \
    cmake --build . && \
    make clean && make && make install
RUN cp -i -rf /usr/local/librabbitmq/lib/x86_64-linux-gnu/* /usr/local/librabbitmq/lib/
RUN yes /usr/local/librabbitmq | pecl install amqp
RUN apt-get -y install libpng-dev
RUN cd /tmp/php-7.1.28/ext/gd/ \
    && phpize && \
    ./configure \
    --with-php-config=/usr/local/bin/php-config \
    && make clean && make && make install
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer
RUN chmod -R 777 /var/log/