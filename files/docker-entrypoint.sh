#! /bin/bash
###
 # @Author: 源源圆球 1340793687@outlook.com
 # @Date: 2022-06-03 22:20:16
 # @LastEditors: 源源圆球 1340793687@outlook.com
 # @LastEditTime: 2022-06-04 19:40:48
 # @FilePath: /docker/files/docker-entrypoint.sh
 # @Description: 每次启动容器的时候运行
 # 
 # Copyright (c) 2022 by 源源圆球 1340793687@outlook.com, All Rights Reserved. 
### 
set -e

. ./config.sh || echo -e "\033[33m不是第一次运行,不进行设置\033[0m"
rm -f ./config.sh

/etc/init.d/postgresql start
echo -e "\033[32m✔Postgresql 开始运行\033[0m"
sleep 3s

cd /home/go-cqhttp
nohup ./go-cqhttp -faststart >> /home/zhenxun_bot/my_plugins/gocq.log 2>&1 &
echo -e "\033[32m✔go-cqhttp 开始运行\033[0m，详细日志请到 ~/my_plugins/gocq.log 查看"
sleep 3s

cd /home/zhenxun_bot_webui
nohup yarn run serve >> /home/zhenxun_bot/my_plugins/webui.log 2>&1 &
echo -e "\033[32m✔WebUI 开始运行\033[0m，详细日志请到 ~/my_plugins/webui.log 查看"
sleep 3s

cd /home/zhenxun_bot
echo -e "\033[32m✔准备启动 bot\033[0m"
sleep 3s

python ./bot.py

exec $@
