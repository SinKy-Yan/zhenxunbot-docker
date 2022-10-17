FROM alpine:latest as gocq-downloader
ENV TZ Asia/Shanghai

ARG BIN_LINK=https://github.com/Mrs4s/go-cqhttp/releases/download/v1.0.0-rc3/go-cqhttp_linux_amd64.tar.gz
WORKDIR /app/amd64
RUN apk --no-cache add curl tar yasm tzdata &&\
    curl -LJo ./bin.tar.gz ${BIN_LINK} &&\
    tar -zxvf ./bin.tar.gz &&\
    chmod +x go-cqhttp

ARG BIN_LINK=https://github.com/Mrs4s/go-cqhttp/releases/download/v1.0.0-rc3/go-cqhttp_linux_arm64.tar.gz
WORKDIR /app/arm64
RUN curl -LJo ./bin.tar.gz ${BIN_LINK} &&\
    tar -zxvf ./bin.tar.gz &&\
    chmod +x go-cqhttp

###############################################################################

FROM alpine:latest as gocq-env
ENV TZ Asia/Shanghai
RUN apk --no-cache add ffmpeg
COPY --from=gocq-downloader /app /home
WORKDIR /home
COPY ./docker-entrypoint.sh /home
COPY ./config.yml /home
CMD /home/docker-entrypoint.sh
# ENTRYPOINT [ "/bin/sh" ]