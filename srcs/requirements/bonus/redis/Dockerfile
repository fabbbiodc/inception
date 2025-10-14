FROM alpine:3.21

RUN apk update && apk add --no-cache redis

RUN mkdir -p /etc/redis/inception

COPY ./conf/redis-cache.conf /etc/redis/inception/inception.conf

EXPOSE 6379

ENTRYPOINT [ "redis-server", "/etc/redis/inception/inception.conf" ]