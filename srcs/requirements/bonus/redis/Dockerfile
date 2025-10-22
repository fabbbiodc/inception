FROM alpine:3.21

RUN apk update && apk add --no-cache redis

RUN mkdir -p /data /etc/redis/inception

RUN chown -R redis:redis /data

COPY ./conf/redis-cache.conf /etc/redis/inception/inception.conf

EXPOSE 6379

ENTRYPOINT [ "redis-server", "/etc/redis/inception/inception.conf" ]