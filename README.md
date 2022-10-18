<!--
 * @Author: 源源圆球 1340793687@outlook.com
 * @Date: 2022-06-03 18:01:14
 * @LastEditors: error: git config user.name && git config user.email & please set dead value or install git
 * @LastEditTime: 2022-08-26 08:42:04
 * @FilePath: /zhenxunbot-docker/README.md
 * Copyright (c) 2022 by 源源圆球 1340793687@outlook.com, All Rights Reserved. 
-->
<div align=center><img width="30%" src="./image/docker.png"/></div>

# [绪山真寻BOT](https://github.com/HibiKier/zhenxun_bot)的Docker镜像

![](https://img.shields.io/github/workflow/status/SinKy-Yan/zhenxunbot-docker/Build%20Docker%20image?label=%E9%95%9C%E5%83%8F%E7%BC%96%E8%AF%91&style=for-the-badge)
![](https://img.shields.io/docker/image-size/jyishit/zhenxun_bot?label=%E9%95%9C%E5%83%8F%E5%A4%A7%E5%B0%8F&style=for-the-badge&logo=docker&logoColor=white&color=2496ED)
![](https://img.shields.io/docker/pulls/jyishit/zhenxun_bot?label=%E4%B8%8B%E8%BD%BD%E6%AC%A1%E6%95%B0&style=for-the-badge)
![](https://img.shields.io/badge/%E6%94%AF%E6%8C%81%E6%9E%B6%E6%9E%84-amd64%7Carm64-FF69B4?style=for-the-badge)
![Arduino](https://img.shields.io/badge/-Debian-A81D33?style=for-the-badge&logo=debian&logoColor=white)
![Arduino](https://img.shields.io/badge/-Python3.10-3776AB?style=for-the-badge&logo=python&logoColor=white)

**使用Docker Compose轻松管理机器人本体、数据库以及QQ客户端😋**,并且额外支持ARM架构的CPU,也就是可以在树莓派上运行;首次启动时占用内存不到1GB;并且支持数据持久化,可以轻松导出数据库

<img align=right src='https://github.githubassets.com/images/mona-whisper.gif' />

顺手点个Star⭐呗~

## 快速开始🚀

1. 你首先需要先确定你的设备已经正确安装[**Docker**](<https://www.runoob.com/docker/docker-tutorial.html>)以及[**Docker Compose**](https://www.runoob.com/docker/docker-compose.html)

2. 下载本仓库中的`docker-compose.yml`文件,可以用`wget`、`curl`或者别的你会的方法,下面是使用`wget`下载的例子

```bash
wget https://raw.githubusercontent.com/SinKy-Yan/zhenxunbot-docker/master/compose/docker-compose.yml
```

3. 编辑刚才下载好的`docker-compose.yml`,可以用`vim`、`nano`或者任何你会的编辑器,**按照文件里的注释改,最少只需要改`BOT用的QQ`、`BOT的QQ密码`、`管理员QQ号`这三行**,其他不懂什么意思的话不要动,其中数据库管理器不是必须的,不想要可以删掉那段

4. 然后执行`docker compose up`,docker compose会开始帮你自动配置所有容器,然后你需要去看名字叫`Go-cqhttp`的容器的日志,看它能不能正常登录QQ,不能的话按照提示操作

## 注意事项🧐

1. `Go-cqhttp`容器的日志中一直出现"连接到反向服务器失败"的警告是正常现象,等待机器人启动后这个警告就会消失

2. 第一次启动机器人会很久,而且还需要下载图片素材,会很慢

## 添加插件🦄

有两种方法

1. 如果你使用了示例文件的话,Docker会自动创建一个储存卷,可以使用`docker volume inspect compose_bot_data`命令来查看具体位置,像我的就是如下图`Mountpoint`所示的位置,在`/var/lib/docker/volumes/compose_bot_data/_data`中,那里面是机器人的根目录,里面有一个叫`my_plugins`的文件夹,你可以把插件放在里面

```bash
qiu@DESKTOP-5OELEC2 ~/zhenxunbot-docker (master)> docker volume inspect compose_bot_data
[
    {
        "CreatedAt": "2022-10-16T17:09:45Z",
        "Driver": "local",
        "Labels": {
            "com.docker.compose.project": "compose",
            "com.docker.compose.version": "2.6.0",
            "com.docker.compose.volume": "bot_data"
        },
        "Mountpoint": "/var/lib/docker/volumes/compose_bot_data/_data",
        "Name": "compose_bot_data",
        "Options": null,
        "Scope": "local"
    }
]
```

2. 如果你会用Debian的话,可以直接进入机器人的容器,用命令行下载插件

## 需要帮助🐱‍💻?

你可以点击图片加入QQ交流群、有关代码的问题可以提一个[issue](https://github.com/SinKy-Yan/zhenxunbot-docker/issues/new)、别的东西可以发在[讨论](https://github.com/SinKy-Yan/zhenxunbot-docker/discussions)里

[![加入QQ群](https://img.shields.io/badge/QQ%E7%BE%A4-1034439737-ddff95?style=for-the-badge)](https://jq.qq.com/?_wv=1027&k=u8PgBkMZ)

## 编译镜像🐋

你需要搞定Docker的`Buildx`环境然后克隆该仓库然后直接构建即可

```bash
docker buildx build --platform=arm64 --tag=zhenxun -o type=docker .
```

## 机器人管理网页🤖

把这一段加到`docker-compose.yml`里就行了,还有点问题好像,不保证能用

```yml
    webui:
         container_name: webui
         restart: on-failure
         image: jyishit/zhenxun_webui
         ports:
             - 8081:80
         depends_on:
             - zhenxun
         links:
             - zhenxun
```

## 数据库管理后台📄

把这一段加到`docker-compose.yml`里就行了,我相信如果你需要这个的话,你应该会用

```yml
pgadmin:
        container_name: pgadmin4
        image: dpage/pgadmin4
        restart: on-failure
        environment:
            PGADMIN_DEFAULT_EMAIL: admin@admin.com # 管理页面默认邮箱
            PGADMIN_DEFAULT_PASSWORD: root # 管理页面默认密码
        ports:
            - "5050:80" # 管理页面端口映射
        links:
            - postgres # 链接postgres数据库
        depends_on:
            - postgres # 关联postgres
```

## 仓库文件说明📂

### `./gocq`

构建gocq镜像的相关文件

### `./compose`

示例文件

### `./image`

这个readme用的图片在里面

### `./webui`

构建webui镜像的相关文件

### `./zhenxun`

构建zhenxun镜像的相关文件
