#!/bin/sh
# PHP 容器启动脚本
# 自动设置 Redis 端口转发：容器内 127.0.0.1:6379 -> 宿主机 Redis

#HOST_IP="192.168.110.155"

# 启动 socat 端口转发（后台运行）
#socat TCP-LISTEN:6379,fork,reuseaddr,bind=127.0.0.1 TCP:${HOST_IP}:6379 &

# 启动 PHP-FPM（容器原本的启动命令）
exec php-fpm
