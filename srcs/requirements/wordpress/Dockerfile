FROM alpine:3.21

RUN apk update && apk add --no-cache \
    curl \
    php83 \
    php83-fpm \
    php83-mysqli \
    php83-json \
    php83-curl \
    php83-dom \
    php83-exif \
    php83-fileinfo \
    php83-mbstring \
    php83-openssl \
    php83-xml \
    php83-zip \
    php83-phar \
    netcat-openbsd

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php83/php-fpm.d/www.conf
COPY ./tools/wp-init.sh /usr/local/bin/wp-init.sh

RUN chmod +x /usr/local/bin/wp-init.sh

# CHECK
WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wp-init.sh"]
CMD ["php-fpm83", "-F"]