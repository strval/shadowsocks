#!/bin/sh

#清理
docker rm -f redis
docker rm -f mysql
docker rm -f php
docker rm -f nginx
rm -rf /var/lib/mysql
rm -rf /var/www
rm -rf /etc/nginx

#获取mysql密码
echo "请设置mysql密码:"
read passwd

#安装redis
docker run --name redis -d redis:6.2-alpine

#安装mysql
mkdir -p /var/lib/mysql
docker run --name mysql -v /var/lib/mysql:/var/lib/mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=$passwd -d mysql:5.7

#安装php
mkdir -p /var/www
docker run --name php --link redis:redis --link mysql:mysql -v /var/www:/var/www -d php:7.4-fpm-alpine

#安装nginx
mkdir -p /var/www
mkdir -p /etc/nginx/conf.d
docker run --name nginxTmp -d nginx:1.12.2-alpine
docker cp nginxTmp:/etc/nginx/conf.d /etc/nginx
docker rm -f nginxTmp
docker run --name nginx --link php:php -v /var/www:/var/www -v /etc/nginx/conf.d:/etc/nginx/conf.d -p 80:80 -p 443:443 -d nginx:1.12.2-alpine
