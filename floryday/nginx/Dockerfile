FROM nginx

COPY ./conf/conf.d /etc/nginx/conf.d
COPY ./conf/app-snippets /etc/nginx/app-snippets
COPY ./conf/ssl /etc/nginx/ssl

ENV TZ=Asia/Shanghai

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
    ####
    && apt-get install -y vim \
    && echo "set number" >> /root/.vimrc \
    ###ll命令##
    && echo "alias ll='ls -l'" >> ~/.bashrc && /bin/bash -c "source ~/.bashrc" \
    ###ps命令###
    && apt-get update && apt-get install -y procps \