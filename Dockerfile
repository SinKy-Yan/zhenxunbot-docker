FROM bitnami/git as Git-Clone
WORKDIR /usr/local/code
RUN git clone https://github.com/HibiKier/zhenxun_bot_webui.git && git clone https://github.com/HibiKier/zhenxun_bot.git

###############################################################################

FROM python:3.9-slim-bullseye as Python-Whl-Builder
RUN apt update && apt install -y --no-install-recommends gcc libc6-dev  && \
pip install -r https://raw.githubusercontent.com/zhenxun-org/zhenxun_bot-deploy/master/requirements.txt && \
pip install rich requests jinja2 thefuzz aiocache baike imageio

##############################################################################

FROM python:3.9-slim-bullseye as Python-ENV
WORKDIR /home
#拷贝git下载的东西
COPY --from=Git-Clone /usr/local/code /home
#拷贝安装好的python依赖
COPY --from=Python-Whl-Builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=Python-Whl-Builder /usr/local/bin/playwright /usr/local/bin/playwright
#拷贝预先准备好的文件
COPY files ./
#环境变量
ENV bot_qq=${bot_qq}
ENV bot_qq_key=${bot_qq_key}
ENV admin_qq=${admin_qq}
ENV webui_passwd={$webui_passwd}
ENV webui_user={$webui_user}
ENV api_key={$api_key}

# apt安装依赖,切换目录是为了后面WebUI可以直接连着减少镜像层数
WORKDIR /home/zhenxun_bot_webui
RUN apt update && \
apt upgrade -y && \
apt install -y --no-install-recommends \
#解决重启BUG
net-tools \
#WebUI要用的node.js
nodejs \
npm \
#PostgreSQL数据库
postgresql \
postgresql-contrib \
#BOT运行需要的依赖
ffmpeg \
libgl1 \
libnss3 \
libatk1.0-0 \
libatk-bridge2.0-0 \
libcups2 \
libxcomposite1 \
#中文字体，解决原神黄历方块字问题
fonts-wqy-microhei && \
#清缓存
apt clean && \
# 调时区
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
echo 'Asia/Shanghai' > /etc/timezone && \
# 安装web_ui
npm install -g @vue/cli yarn && \
yarn && \
yarn cache clean

WORKDIR /home
ENTRYPOINT ["./docker-entrypoint.sh"]