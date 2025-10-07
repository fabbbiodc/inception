FROM alpine:3.21

RUN apk update && apk add --no-cache \
    curl \
    php83-fpm \
    php83-mysqli \
    php83-phar \
	php83-dom \
	php83-mbstring \
	php83-json \
    mariadb-client \
    netcat-openbsd

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php83/php-fpm.d/www.conf

COPY ./conf/custom.ini /etc/php83/conf.d/custom.ini

COPY ./tools/wp-init.sh /usr/local/bin/wp-init.sh
RUN chmod +x /usr/local/bin/wp-init.sh

EXPOSE 9000

ENTRYPOINT [ "wp-init.sh" ]

CMD [ "php-fpm83", "-F" ]