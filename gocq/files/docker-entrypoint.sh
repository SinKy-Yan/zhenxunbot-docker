#!/bin/sh
get_arch=`arch`
if [[ $get_arch =~ "x86_64" ]];then
    mv /home/amd64/go-cqhttp /home/go-cqhttp
elif [[ $get_arch =~ "aarch64" ]];then
    mv /home/arm64/go-cqhttp /home/go-cqhttp
fi
rm -rf /home/amd64
rm -rf /home/arm64
sed -i 's/xxxxxx/'$bot_qq'/g' /home/config.yml
echo -e "已设置BOT的QQ号为"$bot_qq
sed -i 's/yyyyyy/'$bot_passwd'/g' /home/config.yml
echo -e "已设置BOT的QQ密码为"$bot_passwd
/home/go-cqhttp -faststart