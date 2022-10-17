FROM nginx:latest
WORKDIR /usr/share/nginx
RUN apt update &&\
    apt install -y unzip &&\
    curl -LsO https://github.com/HibiKier/zhenxun_bot_webui/archive/refs/heads/main.zip &&\
    unzip ./main.zip &&\
    rm -rf ./main.zip &&\
    rm -rf ./html &&\
    mkdir ./html &&\
    mv ./zhenxun_bot_webui-main/dist/* ./html/ &&\
    rm -rf ./zhenxun_bot_webui-main
CMD ["nginx", "-g", "daemon off;"]