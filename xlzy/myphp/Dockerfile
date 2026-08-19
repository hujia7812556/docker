FROM php:7.4-fpm-buster

# 替换为 archive 镜像源
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's|security.debian.org/debian-security|archive.debian.org/debian-security|g' /etc/apt/sources.list && \
    sed -i '/buster-updates/d' /etc/apt/sources.list

RUN echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    bash-completion \
    ca-certificates \
    less \
    procps \
    iputils-ping \
    telnet \
    net-tools \
    vim \
    sudo \
    git \
    libzip-dev \
    zlib1g-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    && rm -rf /var/lib/apt/lists/*

# 安装 curl-impersonate。BaseSpider 通过 /usr/local/bin/curl_chrome131
# 使用 Chrome TLS/HTTP2 指纹；按容器架构下载官方固定版本的发布包。
ARG CURL_IMPERSONATE_VERSION=1.5.6
RUN set -eux; \
    case "$(dpkg --print-architecture)" in \
        amd64) \
            asset="curl-impersonate-v${CURL_IMPERSONATE_VERSION}.x86_64-linux-gnu.tar.gz"; \
            checksum="b60344f63b9ed8806f0e9f7fd357d9f6c9a82aca279ed1e9e257d544885dcbde" ;; \
        arm64) \
            asset="curl-impersonate-v${CURL_IMPERSONATE_VERSION}.aarch64-linux-gnu.tar.gz"; \
            checksum="6766bc67fd3e8e2313875f32b36b5a3fab02beffe77e5f1cf7fc5da99731d403" ;; \
        *) echo "Unsupported architecture: $(dpkg --print-architecture)" >&2; exit 1 ;; \
    esac; \
    archive="/tmp/${asset}"; \
    curl -fsSL --retry 3 -o "${archive}" "https://github.com/lexiforest/curl-impersonate/releases/download/v${CURL_IMPERSONATE_VERSION}/${asset}"; \
    echo "${checksum}  ${archive}" | sha256sum -c -; \
    mkdir -p /opt/curl-impersonate; \
    tar -xzf "${archive}" -C /opt/curl-impersonate; \
    binary="$(find /opt/curl-impersonate -type f -name curl_chrome131 -perm -u+x | head -n 1)"; \
    test -n "${binary}"; \
    printf '#!/bin/sh\nexec "%s" "$@"\n' "${binary}" > /usr/local/bin/curl_chrome131; \
    chmod +x /usr/local/bin/curl_chrome131; \
    /usr/local/bin/curl_chrome131 --version; \
    rm -f "${archive}"

RUN { \
        echo "alias ll='ls -alF'"; \
        echo "alias la='ls -A'"; \
        echo "alias l='ls -CF'"; \
        echo "alias ls='ls --color=auto'"; \
        echo "if [ -f /usr/share/bash-completion/bash_completion ]; then . /usr/share/bash-completion/bash_completion; fi"; \
    } >> /etc/bash.bashrc

RUN curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/refs/tags/5.3.7.tar.gz \
    && cd /tmp \
    && tar xfz /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mkdir -p /usr/src/php/ext \
    && mv /tmp/phpredis-5.3.7 /usr/src/php/ext/redis \
    && docker-php-ext-install redis \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install bcmath \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install zip

# 全局安装 Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin \
    --filename=composer
    #--version=2.6.5  # 指定版本，可选

# 设置 Composer 中国镜像（可选）
#RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

# ========== 安装 Node.js 20.x（Claude Code 依赖）==========
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# 全局安装 Claude Code
RUN npm install -g @anthropic-ai/claude-code

EXPOSE 9002
