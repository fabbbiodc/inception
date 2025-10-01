FROM alpine:3.18

RUN apk update && apk add --no-cache mariadb mariadb-client

RUN mkdir -p /run/mysqld
RUN chown -R mysql:mysql /run/mysqld

COPY init-mariadb.sh /usr/local/bin/init-mariadb.sh
RUN chmod +x /usr/local/bin/init-mariadb.sh

EXPOSE 3306

CMD ["/usr/local/bin/init-mariadb.sh"]