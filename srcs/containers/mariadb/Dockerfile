FROM alpine:3.18

RUN apk update && add mariadb mariadb-client

EXPOSE 3306

CMD ["/usr/bin/mysqld", "--user=mysql"]