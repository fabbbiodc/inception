FROM alpine:3.18

RUN apk update && apk add php82-fpm

COPY www.conf /etc/php82/php-fpm.d/

CMD ["php-fpm82", "-F"]

