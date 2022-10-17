FROM bitnami/git as Git-Clone
WORKDIR /usr/local/code
RUN git clone https://github.com/HibiKier/zhenxun_bot.git

###############################################################################

FROM python:3.9-slim-bullseye as Python-Whl-Builder
RUN apt update && apt install -y --no-install-recommends gcc libc6-dev  && \
    pip install -r https://raw.githubusercontent.com/zhenxun-org/zhenxun_bot-deploy/master/requirements.txt

##############################################################################

FROM python:3.9-slim-bullseye as Python-ENV
WORKDIR /home
#拷贝git下载的东西
COPY --from=Git-Clone /usr/local/code /home
#拷贝安装好的python依赖
COPY --from=Python-Whl-Builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

# apt安装依赖
RUN apt update && \
    apt upgrade -y && \
    apt install -y --no-install-recommends \
    #解决重启BUG
    net-tools \
    #BOT运行需要的依赖
    ffmpeg \
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

#拷贝预先准备好的文件,这里的文件来源目录使用的工作目录是上一级,为了github action改的
COPY ./zhenxun/files ./

#环境变量
ENV admin_qq=${admin_qq}

WORKDIR /home
# ENTRYPOINT ["/bin/bash"]
ENTRYPOINT [ "/home/docker-entrypoint.sh" ]