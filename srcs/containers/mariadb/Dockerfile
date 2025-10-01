FROM alpine:3.18

RUN apk update && apk add --no-cache mariadb mariadb-client

COPY init-mariadb.sh /usr/local/bin/init-mariadb.sh
RUN chmod +x /usr/local/bin/init-mariadb.sh

EXPOSE 3306

CMD ["/usr/local/bin/init-mariadb.sh"]