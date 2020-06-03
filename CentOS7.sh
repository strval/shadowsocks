#!/bin/bash

echo -e "+-------------------------------------------"
echo -e "+ 1.安装 shadowsocks 服务"
echo -e "+ 2.启动 shadowsocks 服务"
echo -e "+ 3.停止 shadowsocks 服务"
echo -e "+ 4.重启 shadowsocks 服务"
echo -e "+ 5.退出脚本"
echo -e "+-------------------------------------------"
read -p "请输入序号:" sn

if [ $sn = "1" ]
then
	if [ -f "/etc/shadowsocks.json" ]
	then
		echo "shadowsocks 服务已安装"
		exit
	fi
	yum install -y python-setuptools && easy_install pip
	pip install shadowsocks
	read -p "请输入端口:" port
	read -p "请输入密码:" password
	config='{
	"server":"0.0.0.0",
	"server_port":'$port',
	"local_address": "127.0.0.1",
	"local_port":1080,
	"password":"'$password'",
	"timeout":300,
	"method":"aes-256-cfb",
	"fast_open": false
}'
	echo "${config}" > /etc/shadowsocks.json
	chmod +x /etc/shadowsocks.json
	firewall-cmd --zone=public --add-port=$port/tcp --permanent
	firewall-cmd --reload
	ssserver -c /etc/shadowsocks.json -d start
elif [ $sn = "2" ]
then
	if [ ! -f "/etc/shadowsocks.json" ]
	then
		echo "未安装 shadowsocks 服务"
		exit
	fi
	ssserver -c /etc/shadowsocks.json -d start
elif [ $sn = "3" ]
then
	if [ ! -f "/etc/shadowsocks.json" ]
	then
		echo "未安装 shadowsocks 服务"
		exit
	fi
	ssserver -c /etc/shadowsocks.json -d stop
elif [ $sn = "4" ]
then
	if [ ! -f "/etc/shadowsocks.json" ]
	then
		echo "未安装 shadowsocks 服务"
		exit
	fi
	ssserver -c /etc/shadowsocks.json -d restart
elif [ $sn = "5" ]
then
	exit
else
	echo "输入错误,3秒后退出"
	sleep 3s
	exit
fi
