FROM alpine:3.21

RUN apk update && apk add --no-cache mariadb mariadb-client

COPY ./tools/maria-init.sh /usr/local/bin/maria-init.sh
RUN chmod +x /usr/local/bin/maria-init.sh

EXPOSE 3306

ENTRYPOINT [ "/usr/local/bin/maria-init.sh" ]

CMD ["mysqld", "--user=mysql"]