#! /bin/bash
set -e

#只是判断了，没有做出回应，等一个有缘人帮我完善
if [ ! "$bot_qq" ];then
    echo -e "未设置bot使用的QQ号"
fi
if [ ! "$bot_qq_key" ];then
    echo -e "未设置bot的QQ号密码"
fi
if [ ! "$admin_qq" ];then
    echo -e "未设置超级管理员QQ号"
fi

. ./config.sh || echo -e "不是第一次运行,不导入变量"
rm -f ./config.sh

/etc/init.d/postgresql start
echo -e "postgresql 开始运行✔"

cd /home/go-cqhttp
nohup ./go-cqhttp -faststart >> gocq.log 2>&1 &
echo -e "go-cqhttp 开始运行✔，详细日志请到/home/go-cqhttp/gocq.log查看"

cd /home/zhenxun_bot_webui
nohup yarn run serve >> webui.log 2>&1 &
echo -e "web-ui 开始运行✔，详细日志请到/home/zhenxun_bot_webui/webui.log查看"

cd /home/zhenxun_bot
echo -e "准备启动bot"
python ./bot.py

exec $@