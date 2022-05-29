#! /bin/bash
set -e

sed -i 's/xxxxxx/'$bot_qq'/g' ./go-cqhttp/config.yml
echo -e "已设置BOT的QQ号为"$bot_qq
sed -i 's/yyyyyy/'$bot_qq_key'/g' ./go-cqhttp/config.yml
echo -e "已设置BOT的QQ密码为"$bot_qq_key
sed -i 's/qqqqqq/'$api_key'/g' ./zhenxun_bot/configs/config.yaml
echo -e "已设置识图API-KEY为"$api_key
sed -i 's/root/'$webui_user'/g' ./zhenxun_bot/configs/config.yaml
echo -e "已设置WebUI的用户名为"$webui_user
sed -i 's/123456/'$webui_passwd'/g' ./zhenxun_bot/configs/config.yaml
echo -e "已设置WebUI的密码为"$webui_passwd
sed -i '3c SUPERUSERS=["'$admin_qq'"]' ./zhenxun_bot/.env.dev
echo -e "已设置超级管理员的QQ为"$admin_qq

mkdir ./zhenxun_bot/my_plugins
sed -i '14a nonebot.load_plugins("my_plugins")' ./zhenxun_bot/bot.py
echo -e "已添加自定义插件目录配置"

get_arch=`arch`
if [[ $get_arch =~ "x86_64" ]];then
    mv ./go-cqhttp/go-cqhttp-amd64 ./go-cqhttp/go-cqhttp
    rm -f ./go-cqhttp/go-cqhttp-arm64
    echo -e "检测到你的设备是amd64架构"
elif [[ $get_arch =~ "aarch64" ]];then
    mv ./go-cqhttp/go-cqhttp-arm64 ./go-cqhttp/go-cqhttp
    rm -f ./go-cqhttp/go-cqhttp-amd64
    echo -e "检测到你的设备是arm64架构"
fi

cat > /tmp/sql.sql <<-EOF
CREATE USER uname WITH PASSWORD 'zhenxun';
CREATE DATABASE testdb OWNER uname;
CREATE ROLE root superuser PASSWORD '123456' login;
EOF

/etc/init.d/postgresql start
su postgres -c "psql -f /tmp/sql.sql"
echo -e "已创建数据库"

if [ -f "./zhenxun_bot/my_plugins/zhenxun.sql" ]; then
    echo "检测到数据库文件，开始导入"
    sleep 2s
    su postgres -c "psql -U postgres testdb < ./zhenxun_bot/my_plugins/zhenxun.sql"
    echo "已导入数据库"
else 
    echo "没有检测到数据库文件，不导入旧数据库"
fi


echo -e "已完成新容器配置,5秒后自动继续"
sleep 5s