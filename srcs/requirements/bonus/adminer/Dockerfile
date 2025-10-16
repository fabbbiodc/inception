FROM alpine:3.21

RUN apk update && apk add --no-cache \
	curl \
	php83-fpm \
	php83-mysqli \
	php83-session \
	netcat-openbsd

RUN rm /etc/php83/php-fpm.d/www.conf

COPY ./conf/adminer.conf /etc/php83/php-fpm.d/adminer.conf

RUN mkdir -p /run/php

COPY ./tools/adminer-init.sh /root/

RUN chmod +x /root/adminer-init.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT [ "/root/adminer-init.sh" ]

CMD [ "php-fpm83", "-F" ]