FROM alpine:3.18

RUN apk update && apk add --no-cache \
    php82-fpm \
    php82-mysqli \
    mariadb-client \
    wget

COPY www.conf /etc/php82/php-fpm.d/
COPY setup-wp.sh /usr/local/bin/init-wp.sh
RUN chmod +x /usr/local/bin/init-wp.sh

CMD ["/usr/local/bin/init-wp.sh"]

