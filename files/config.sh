#! /bin/bash
set -e

sed -i 's/xxxxxx/'$bot_qq'/g' ./go-cqhttp/config.yml
sed -i 's/yyyyyy/'$bot_qq_key'/g' ./go-cqhttp/config.yml
sed -i '3c SUPERUSERS=["'$admin_qq'"]' ./zhenxun_bot/.env.dev

mkdir ./zhenxun_bot/my_plugins
sed -i '14a nonebot.load_plugins("my_plugins")' ./zhenxun_bot/bot.py
echo -e "已添加自定义插件目录配置"

cat > /tmp/sql.sql <<-EOF
CREATE USER uname WITH PASSWORD 'zhenxun';
CREATE DATABASE testdb OWNER uname;
CREATE ROLE root superuser PASSWORD '123456' login;
EOF

get_arch=`arch`
if [[ $get_arch =~ "x86_64" ]];then
    mv /home/go-cqhttp/go-cqhttp-amd64 /home/go-cqhttp/go-cqhttp
    rm -f /home/go-cqhttp/go-cqhttp-arm64
elif [[ $get_arch =~ "aarch64" ]];then
    mv /home/go-cqhttp/go-cqhttp-arm64 /home/go-cqhttp/go-cqhttp
    rm -f /home/go-cqhttp/go-cqhttp-amd64
fi

/etc/init.d/postgresql start
su postgres -c "psql -f /tmp/sql.sql"

echo -e "已导入变量"
