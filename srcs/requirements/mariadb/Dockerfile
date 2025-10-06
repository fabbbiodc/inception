FROM alpine:3.21

RUN apk update && apk add --no-cache mariadb mariadb-client

RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

COPY ./conf/my.cnf /etc/my.cnf.d/my.cnf
COPY ./tools/maria-init.sh /usr/local/bin/maria-init.sh
RUN chmod +x /usr/local/bin/maria-init.sh

EXPOSE 3306

ENTRYPOINT [ "/usr/local/bin/maria-init.sh" ]

CMD ["mariadbd", "--user=mysql", "--bind-address=0.0.0.0", "--port=3306"]