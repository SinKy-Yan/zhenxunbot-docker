# [绪山真寻BOT](https://github.com/HibiKier/zhenxun_bot)的Docker版镜像🐋

![](https://img.shields.io/github/workflow/status/SinKy-Yan/zhenxunbot-docker/Build%20Docker%20image?label=%E9%95%9C%E5%83%8F%E7%BC%96%E8%AF%91&style=for-the-badge)
![](https://img.shields.io/docker/image-size/jyishit/zhenxun_bot?label=%E9%95%9C%E5%83%8F%E5%A4%A7%E5%B0%8F&style=for-the-badge)
![](https://img.shields.io/docker/pulls/jyishit/zhenxun_bot?label=%E4%B8%8B%E8%BD%BD%E6%AC%A1%E6%95%B0&style=for-the-badge)
![](https://img.shields.io/badge/Python%E7%89%88%E6%9C%AC-3.9-ff69b4?style=for-the-badge)
![](https://img.shields.io/badge/%E6%94%AF%E6%8C%81%E5%B9%B3%E5%8F%B0-arm64%7Camd64-8B008B?style=for-the-badge)

![GitHub release (latest by date)](https://img.shields.io/github/v/release/HibiKier/zhenxun_bot?label=%E7%9C%9F%E5%AF%BBBOT%E7%89%88%E6%9C%AC&style=for-the-badge)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/Mrs4s/go-cqhttp?label=gocq%E7%89%88%E6%9C%AC&style=for-the-badge)
![](https://changkun.de/urlstat?mode=github&repo=SinKy-Yan/zhenxunbot-docker)


**镜像内已集成运行BOT需要的PostgreSQL🐘、绪山真寻BOT本体、以及真寻BOT-WebUI😋**

额外还有Python3.9、PIP、PIP编译工具链、Vim、wget、Git、中文语言包

![Git](https://img.shields.io/badge/-Git-F05032?style=flat-square&logo=git&logoColor=white)
![Vim](https://img.shields.io/badge/-Vim-019733?style=flat-square&&logo=Vim&logoColor=white)
![Ubuntu](https://img.shields.io/badge/-Ubuntu-E95420?style=flat-square&&logo=ubuntu&logoColor=white)
![Ubuntu](https://img.shields.io/badge/-Python-3776AB?style=flat-square&&logo=python&logoColor=white)

<img align=right src='https://github.githubassets.com/images/mona-whisper.gif' /> 顺手点个Star⭐呗~


## 注意事项⚠

镜像有点大，解压后接近3GB，需要有足够的空间（可能会出个精简版镜像）

需要有1G以上的内存

**先确定能用go-cqhttp登录上BOT的QQ，否则需要进入容器查看日志**

## 迁移数据库📑

迁移数据库是为了如果你以前部署过真寻的话，可以继承好感度、金币等数据

请先导出旧数据库，如果你使用的是真寻文档里的搭建方法，那么应该可以用`pg_dump --host 127.0.0.1 --port 5432 --username uname  > zhenxun.sql testdb`这条命令导出数据库到当前目录并**命名为**`zhenxun.sql`

然后将`zhenxun.sql`拷贝到将要部署Docker版真寻的宿主机的`~/my_plugins`目录下，**如果该目录不存在则需要手动创建**

然后就可以了，容器创建时会检测有没有这个文件，有的话就会帮你导入的，不过只是帮你导入，数据库本身有问题的话就跟我没关系了

## 快速开始🎉

将下面命令中**单引号内**的`bot的QQ号`、`bot的QQ密码`、`管理员QQ号`、`识图API-KEY`、`WebUI用户名`、`WebUI密码`替换成对应的账号和密码之后执行就好了

⚠识图API-KEY不替换也行，但是运行之后bot的识图功能会用不了，以后你想再加上的话需要进入容器自己更改，API_KEY通过[该网址](https://saucenao.com/user.php?page=search-api)注册获取

⚠会在当前用户的用户根目录里新建一个叫`my_plugins`的文件夹，这就是自定义插件的目录，可以使用`cd ~/my_plugins`命令来进入，进入后就可以下载需要的插件了

```
docker run -itd --restart=on-failure:3 \
-e bot_qq='BOT的QQ号' \
-e bot_qq_key='BOT的QQ密码' \
-e admin_qq='管理员QQ号' \
-e api_key='识图API-KEY' \
-e webui_user='WebUI用户名' \
-e webui_passwd='WebUI密码' \
-p 8081:8081 \
-v ~/my_plugins:/home/zhenxun_bot/my_plugins \
--name=zhenxun_bot \
jyishit/zhenxun_bot
```

执行之后会开始从Docker Hub上下载镜像，下载并解压之后容器创建成功的话终端会返回一长串的容器ID，下载速度取决于你的网速，推荐设置一个镜像加速器

第一次运行容器会自动停止一次容器，不过它应该会自动重启

查看Docker日志，成功运行之后可以去`容器IP:8081`进入真寻的WebUI，如果你没有自定义账号密码的话，默认账号是`admin`，密码是`123456`

## 需要帮助🐱‍💻？

你可以点击图片加入QQ交流群，或者提一个Issue

[![加入QQ群](https://img.shields.io/badge/QQ%E7%BE%A4-1034439737-ddff95?style=for-the-badge)](https://jq.qq.com/?_wv=1027&k=u8PgBkMZ)

## 容器内文件结构📂

```
/home
├── docker-entrypoint.sh
├── go-cqhttp
│   ├── config.yml
│   ├── data
│   ├── device.json
│   ├── go-cqhttp
│   ├── gocq.log
│   ├── logs
│   └── session.token
├── zhenxun_bot
│   ├── basic_plugins
│   ├── bot.py
│   ├── configs
│   ├── data
│   ├── docs_image
│   ├── LICENSE
│   ├── log
│   ├── logo.png
│   ├── models
│   ├── my_plugins
│   ├── plugins
│   ├── poetry.lock
│   ├── pyproject.toml
│   ├── README.md
│   ├── resources
│   ├── restart.sh
│   ├── services
│   ├── update_info.json
│   ├── utils
│   └── __version__
└── zhenxun_bot_webui
    ├── babel.config.js
    ├── jsconfig.json
    ├── LICENSE
    ├── node_modules
    ├── package.json
    ├── package-lock.json
    ├── public
    ├── README.md
    ├── src
    ├── vue.config.js
    ├── webui.log
    └── yarn.lock
