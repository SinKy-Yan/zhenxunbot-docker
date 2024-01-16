#! /bin/bash
###
# @Author: 源源圆球 1340793687@outlook.com
# @Date: 2022-06-03 22:20:16
# @LastEditors: 源源圆球 1340793687@outlook.com
# @LastEditTime: 2022-06-04 19:40:48
# @FilePath: /docker/files/docker-entrypoint.sh
# @Description: 每次启动容器的时候运行
# Copyright (c) 2022 by 源源圆球 1340793687@outlook.com, All Rights Reserved.
###
set -e

. ./config.sh || echo -e "\033[33m不是第一次运行,不进行初始化设置\033[0m"
rm -f ./config.sh

if grep -q "my_plugins" ./zhenxun_bot/bot.py; then
    echo "已设置加载自定义插件目录"
else
    sed -i '14a nonebot.load_plugins("my_plugins")' ./zhenxun_bot/bot.py
fi

cd /home/zhenxun_bot
poetry run python bot.py
