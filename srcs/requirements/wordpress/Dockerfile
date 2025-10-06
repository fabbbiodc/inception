FROM alpine:3.21

RUN apk update && apk add --no-cache php83-fpm php83-mysqli

COPY ./conf/www.conf /etc/php83/php-fpm.d/www.conf

RUN mkdir -p /var/www/html

COPY ./tools/index.html /var/www/html/index.html

EXPOSE 9000

CMD [ "php-fpm83", "-F" ]
