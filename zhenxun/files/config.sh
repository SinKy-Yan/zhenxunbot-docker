#! /bin/bash
#这个文件为了在第一次运行容器的时候进行一些配置
set -e

sed -i 's/root/'$webui_user'/g' ./zhenxun_bot/configs/config.yaml
echo -e "已设置WebUI的用户名为"$webui_user
sed -i 's/123456/'$webui_passwd'/g' ./zhenxun_bot/configs/config.yaml
echo -e "已设置WebUI的密码为"$webui_passwd
sed -i '3c SUPERUSERS=["'$admin_qq'"]' ./zhenxun_bot/.env.dev
echo -e "已设置超级管理员的QQ为"$admin_qq
sed -i '15c HOST = 0.0.0.0' ./zhenxun_bot/.env.dev

mkdir ./zhenxun_bot/my_plugins >/dev/null 2>&1
