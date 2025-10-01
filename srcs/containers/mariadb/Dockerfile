FROM alpine:3.18

RUN apk update && add --no-cache mariadb mariadb-client

COPY init-db.sh /usr/local/bin/init-mariadb.sh
RUN chmod +x /usr/local/bin/init-mariadb.sh

EXPOSE 3306

CMD ["/usr/local/bin/init-mariadb.sh"]