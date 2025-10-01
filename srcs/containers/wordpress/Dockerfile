FROM alpine:3.18

RUN apk update && apk add --no-cache \
    php82-fpm \
    php82-mysqli \
    php82-cli \
    mariadb-client \
    wget

# Create symlink for WP-CLI compatibility
RUN ln -s /usr/bin/php82 /usr/bin/php

COPY www.conf /etc/php82/php-fpm.d/
COPY init-wp.sh /usr/local/bin/init-wp.sh
RUN chmod +x /usr/local/bin/init-wp.sh

CMD ["/usr/local/bin/init-wp.sh"]

