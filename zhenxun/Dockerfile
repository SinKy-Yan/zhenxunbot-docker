FROM bitnami/git as Git-Clone
WORKDIR /usr/local/code
RUN git clone https://github.com/HibiKier/zhenxun_bot.git

##############################################################################

FROM python:3.9-slim-bullseye as Python-ENV

# 拷贝git下载的东西
WORKDIR /home
COPY --from=Git-Clone /usr/local/code /home

# apt安装依赖
RUN apt update && \
    apt upgrade -y && \
    apt install -y --no-install-recommends \
    gcc \
    #解决重启BUG
    net-tools \
    #BOT运行需要的依赖
    ffmpeg \
    libc6-dev \
    libgl1 \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libxcomposite1 \
    #中文字体,解决原神黄历方块字问题
    fonts-wqy-microhei && \
    #清缓存
    apt clean && \
    # 调时区
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo 'Asia/Shanghai' > /etc/timezone

# poetry 安装 python 包
WORKDIR /home/zhenxun_bot
RUN pip install poetry
RUN poetry install
RUN poetry run playwright install chromium
RUN poetry run playwright install-deps chromium

# 拷贝预先准备好的文件,这里的文件来源目录使用的工作目录是上一级,为了github action改的
WORKDIR /home
COPY ./zhenxun/files ./
RUN chmod +x /home/docker-entrypoint.sh

#环境变量
ENV admin_qq=${admin_qq}

WORKDIR /home
# ENTRYPOINT ["/bin/bash"]
ENTRYPOINT [ "/home/docker-entrypoint.sh" ]
