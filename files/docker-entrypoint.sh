#! /bin/bash
set -e
#只是判断了，没有做出回应，等一个有缘人帮我完善
if [ ! "$bot_qq" ];then
    echo -e "未设置 bot 使用的 QQ 号"
fi
if [ ! "$bot_qq_key" ];then
    echo -e "未设置 bot 的 QQ 号密码"
fi
if [ ! "$admin_qq" ];then
    echo -e "未设置超级管理员 QQ 号"
fi

. ./config.sh || echo -e "不是第一次运行,不进行设置"
rm -f ./config.sh

git -C ./zhenxun_bot pull
echo -e "更新真寻 bot✔"
sleep 1s
git -C ./zhenxun_bot_webui pull
echo -e "更新 WebUI✔"
sleep 2s

/etc/init.d/postgresql start
echo -e "Postgresql 开始运行✔"
sleep 2s

cd /home/go-cqhttp
nohup ./go-cqhttp -faststart >> gocq.log 2>&1 &
echo -e "go-cqhttp 开始运行✔，详细日志请到 /home/go-cqhttp/gocq.log 查看"
sleep 2s

cd /home/zhenxun_bot_webui
nohup yarn run serve >> webui.log 2>&1 &
echo -e "WebUI 开始运行✔，详细日志请到 /home/zhenxun_bot_webui/webui.log 查看"
sleep 2s

cd /home/zhenxun_bot
echo -e "准备启动 bot"
sleep 2s

python ./bot.py

exec $@
