# [绪山真寻BOT](https://github.com/HibiKier/zhenxun_bot)的Docker版

![](https://img.shields.io/github/workflow/status/SinKy-Yan/zhenxunbot-docker/Build%20Docker%20image?label=%E9%95%9C%E5%83%8F%E7%BC%96%E8%AF%91&style=for-the-badge)
![](https://img.shields.io/docker/image-size/jyishit/zhenxun_bot?label=%E9%95%9C%E5%83%8F%E5%A4%A7%E5%B0%8F&style=for-the-badge)
![](https://img.shields.io/docker/pulls/jyishit/zhenxun_bot?label=%E4%B8%8B%E8%BD%BD%E6%AC%A1%E6%95%B0&style=for-the-badge)
![](https://img.shields.io/badge/Python%E7%89%88%E6%9C%AC-3.8-ff69b4?style=for-the-badge)
![](https://img.shields.io/badge/%E6%94%AF%E6%8C%81%E5%B9%B3%E5%8F%B0-arm64%7Camd64-8B008B?style=for-the-badge)

## **镜像内已集成运行BOT必须的PostgreSQL、绪山真寻BOT本体、以及真寻BOT-WebUI**

额外还有Python3.8、PIP、PIP编译工具链、Vim、wget、git、中文语言包

## 注意事项

镜像有点大，解压后接近3GB，需要有足够的空间（可能会出个精简版镜像）

**先确定能用go-cqhttp登录上BOT的QQ，否则需要进入容器查看日志**

## 快速开始

将下面命令中**单引号内**的`bot的QQ号`，`bot的QQ密码`，`管理员QQ号`替换成对应的QQ号和密码之后执行就好了

```
docker run -itd --restart=on-failure:3 \
-e bot_qq='bot的QQ号' \
-e bot_qq_key='bot的QQ密码' \
-e admin_qq='管理员QQ号' \
-p 8081:8081 \
-v ~/my_plugins:/home/zhenxun_bot/my_plugins \
--name=zhenxun_bot \
jyishit/zhenxun_bot
```

查看Docker日志，成功运行之后可以去`容器IP:8081`进入真寻的WebUI