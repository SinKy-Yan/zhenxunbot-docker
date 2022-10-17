#!/bin/bash
###
 # @Author: 源源球球✨ 1340793687@outlook.com
 # @Date: 2022-06-22 12:57:13
 # @LastEditors: SinKy-Yan 1340793687@outlook.com
 # @LastEditTime: 2022-07-06 00:29:55
 # @FilePath: /zhenxunbot-docker/SetUP.sh
 # Copyright (c) 2022 by 源源球球✨ 1340793687@outlook.com, All Rights Reserved. 
###

#预设颜色
red='\e[91m'
green='\e[92m'
yellow='\e[93m'
magenta='\e[95m'
cyan='\e[96m'
none='\e[0m'
_red() { echo -e ${red}$*${none}; }
_green() { echo -e ${green}$*${none}; }
_yellow() { echo -e ${yellow}$*${none}; }
_magenta() { echo -e ${magenta}$*${none}; }
_cyan() { echo -e ${cyan}$*${none}; }

# 预设语句
docker_is_running=`systemctl status sshd | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1`

read_config()
{
    clear
    whiptail --title "真寻Docker辅助脚本" --msgbox "✨请按照接下来的提示输入信息,按回车继续" 10 40
    container_name=$(whiptail --title "真寻Docker辅助脚本" --inputbox "容器的名字" 10 40 zhenxun 3>&1 1>&2 2>&3)
    bot_qq=$(whiptail --title "真寻Docker辅助脚本" --inputbox "Bot使用的QQ号:" 10 40 3>&1 1>&2 2>&3)
    bot_qq_key=$(whiptail --title "真寻Docker辅助脚本" --inputbox "Bot使用的QQ密码:" 10 40 3>&1 1>&2 2>&3)
    admin_qq=$(whiptail --title "真寻Docker辅助脚本" --inputbox "超级用户的QQ号:" 10 40 3>&1 1>&2 2>&3)
    webui_user=$(whiptail --title "真寻Docker辅助脚本" --inputbox "WebUI的用户名:" 10 40 admin 3>&1 1>&2 2>&3)
    webui_passwd=$(whiptail --title "真寻Docker辅助脚本" --inputbox "WebUI的密码:" 10 40 123456 3>&1 1>&2 2>&3)
    webui_port=$(whiptail --title "真寻Docker辅助脚本" --inputbox "WebUI的端口:" 10 40 8080 3>&1 1>&2 2>&3)
    plugins_dir=$(whiptail --title "真寻Docker辅助脚本" --inputbox "创建自定义插件目录的绝对位置:" 10 40 ~/my_plugins 3>&1 1>&2 2>&3)

    whiptail --title "真寻Docker辅助脚本" --yesno "容器名字:$container_name \
        Bot的QQ号:$bot_qq \
        Bot的QQ密码:$bot_qq_key \
        超级用户的QQ号:$admin_qq \
        WebUI的用户名:$webui_user \
        WebUI的密码:$webui_passwd \
        WebUI的端口:$webui_port \
        插件目录:$plugins_dir \
        是否继续?" 15 40 3>&1 1>&2 2>&3

    # if [ $? -eq 0 ]; then
    #     pass
    # else
    #     exit 1
    # fi
}

docker_create_if_error()
{
    if [[ $docker_run_log =~ "You have to remove (or rename) that container to be able to reuse that name" ]];then
        whiptail --title "真寻Docker辅助脚本" --msgbox "❌错误:已经有一个叫$container_name的容器了" 10 40 && exit 1
    elif [[ $docker_run_log =~ "address already in use" ]];then
        whiptail --title "真寻Docker辅助脚本" --msgbox "❌错误:端口$webui_port被占用" 10 40 && exit 1
    else
        echo $docker_run_log
    fi
}

docker_pull()
{
    # 设置加速器
    if [ $if_use_systemctl -eq 1 ]; then
        if [ ! -f /etc/docker/daemon.json ];then
            echo "🚀没有发现Docker配置,创建Docker配置文件目录"
            mkdir -p /etc/docker
            echo "🐋正在设置镜像下载加速器"
            echo -e "{\n\"registry-mirrors\": [\"https://hyqkgfgr.mirror.aliyuncs.com\"]\n}" > /etc/docker/daemon.json
            # 重启Docker
            echo "重新加载Docker设置"
            systemctl daemon-reload
            echo "重启Docker"
            systemctl restart docker
            if [ $? -eq 0 ]; then
                echo -e "\033[32m🐋Docker重启成功\033[0m"
            else
                echo -e "\033[31m❌Docker重启失败...\033[0m"
                exit 1
            fi
        else
            echo "🐋Docker配置文件已存在,不设置加速器"
        fi
    fi

    # 下载镜像
    docker pull jyishit/zhenxun_bot > /tmp/docker_pull.log 2>&1 &
    if [ $? -eq 0 ]; then
        {
            while true
            do
            Pulling=$(grep -o 'Pulling fs layer' /tmp/docker_pull.log | wc -l)
            Waiting=$(grep -o 'Waiting' /tmp/docker_pull.log | wc -l)
            Verifying=$(grep -o 'Verifying Checksum' /tmp/docker_pull.log | wc -l)
            Download_complete=$(grep -o 'Download complete' /tmp/docker_pull.log | wc -l)
            Pull_complete=$(grep -o 'Pull complete' /tmp/docker_pull.log | wc -l)
            persent=$((($Pulling+$Waiting+$Verifying+$Download_complete+$Pull_complete)*2))
            Downloaded=$(cat /tmp/docker_pull.log)
            if [[ $Downloaded =~ "Downloaded" ]];then
                break
            fi
            sleep 1s
            echo $persent
            done
        } | whiptail --gauge "正在下载镜像" 6 50 0
    else
        whiptail --title "真寻Docker辅助脚本" --msgbox "❌镜像下载失败" 10 40 && exit 1
    fi
}

docker_create()
{
    # 创建容器
    echo "🐋开始创建容器"
    docker run -itd \
    -e bot_qq=$bot_qq \
    -e bot_qq_key=$bot_qq_key \
    -e admin_qq=$admin_qq \
    -e webui_user=$webui_user \
    -e webui_passwd=$webui_passwd \
    -p $webui_port:8081 \
    -v $plugins_dir/my_plugins:/home/zhenxun_bot/my_plugins \
    --name=$container_name \
    jyishit/zhenxun_bot > /tmp/docker_run.log 2>&1
    docker_run_log=$(cat /tmp/docker_run.log)
    if [ $? -eq 0 ]; then
        echo -e "\033[32m🎉Bot容器创建成功!\033[0m"
        echo "🐋容器ID是$docker_run_log"
        echo -e "这个脚本好用的话给个Star⭐呗~"
        sed -i '$a\container_name='$container_name'' /etc/profile
        source /etc/profile
        exit 0
    else
        docker_create_if_error
        echo -e "\033[31m❌Bot容器创建失败\033[0m"
        exit 1
    fi
}

docker_start()
{
    echo "正在启动Bot容器..."
    docker start $container_name
    if [ $? -eq 0 ]; then
        echo "🎉Bot容器启动成功"
    else
        echo "❌Bot容器启动失败"
    fi
}

docker_stop()
{
    echo "正在停止Bot容器..."
    docker stop $container_name
    if [ $? -eq 0 ]; then
        echo "🎉Bot容器停止成功"
    else
        echo "❌Bot容器停止失败"
    fi
}

docker_remove()
{
    echo "正在删除Bot容器..."
    docker rm $container_name
    if [ $? -eq 0 ]; then
        echo "🎉Bot容器删除成功"
    else
        echo "❌Bot容器删除失败"
    fi
}

docker_restart()
{
    echo "正在重启Bot容器..."
    docker restart $container_name
    if [ $? -eq 0 ]; then
        echo "🎉Bot容器重启成功"
    else
        echo "❌Bot容器重启失败"
    fi
    docker pull jyishit/zhenxun_bot > /tmp/docker_pull.log 2>&1 &
}

main()
{
    clear
    OPTION=$(whiptail --title "真寻Docker辅助脚本" --menu "选择你要执行的功能" --notags 15 30 5 \
            "1" "创建容器" \
            "2" "启动容器" \
            "3" "停止容器" \
            "4" "删除容器" \
            "5" "重启容器" 3>&1 1>&2 2>&3)
    
    if [ $? = 0 ]; then
        if [ $OPTION = 1 ]; then
            read_config
            docker_pull
            docker_create
        elif [ $OPTION = 2 ]; then
            docker_start
        elif [ $OPTION = 3 ]; then
            docker_stop
        elif [ $OPTION = 4 ]; then
            docker_remove
        elif [ $OPTION = 5 ]; then
            docker_restart
        fi
    fi
}

# 从这里开始执行
# 判断root权限
clear
if [ "$UID" -ne "0" ] ;then
    whiptail --title "真寻Docker辅助脚本" --msgbox "请使用Root权限运行此脚本,按回车退出" 10 40 && exit 1
fi

systemctl > /tmp/docker_shell_run.log 2>&1
if [ $? -eq  0 ]; then
    if_use_systemctl=1
else
    if_use_systemctl=0
    whiptail --title "真寻Docker辅助脚本" --msgbox "⚠你的设备不是使用systemctl管理服务,将不会自动管理你的Docker服务,按回车继续" 10 40
fi

# 检查Docker
docker -v > /tmp/docker_shell_run.log 2>&1
if [ $? -eq  0 ]; then
    pass
else
    whiptail --title "真寻Docker辅助脚本" --msgbox "❌你没有安装Docker,请先安装后再执行此脚本~(^_^),按回车退出" 10 40 && exit 1
fi

# docker服务有没有运行
if [ $if_use_systemctl -eq 1 ]; then
    if [ "$docker_is_running" == "running" ]
    then
        pass
    else
        systemctl start docker
        if [ $? -eq 0 ]; then
            pass
        else
            whiptail --title "真寻Docker辅助脚本" --msgbox "❌Docker启动失败,按回车退出" 10 40 && exit 1
        fi
    fi
fi

# 判断系统
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    if [ -f /etc/redhat-release ]; then
        whiptail --title "真寻Docker辅助脚本" --msgbox "⚠检测到您的系统为CentOS,这个系统还未经测试" 10 40
    elif [ -f /etc/arch-release ]; then
        whiptail --title "真寻Docker辅助脚本" --msgbox "⚠检测到您的系统为ArchLinux,这个系统还未经测试" 10 40
    elif [ -f /etc/debian_version ]; then
        pass
    else
        whiptail --title "真寻Docker辅助脚本" --msgbox "⚠这个脚本很可能在你的系统上无法正常运行" 10 40
    fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        whiptail --title "真寻Docker辅助脚本" --msgbox "⚠检测到您的系统为macOS,这个系统还未经测试" 10 40
    else
        whiptail --title "真寻Docker辅助脚本" --msgbox "⚠这个脚本很可能在你的系统上无法正常运行" 10 40
fi

# 判断架构
get_arch=`arch`
if [[ $get_arch =~ "x86_64" ]];then
    main
elif [[ $get_arch =~ "aarch64" ]];then
    main
else
    whiptail --title "真寻Docker辅助脚本" --msgbox "❌检测到你的设备不是amd64或arm64架构,请使用amd64或arm64架构的设备运行此脚本" 10 40 && exit 1
fi
