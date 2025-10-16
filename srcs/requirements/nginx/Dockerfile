FROM alpine:3.21

RUN apk update && apk add --no-cache nginx openssl netcat-openbsd
RUN mkdir -p /var/www/html && \
    chown -R nobody:nobody /var/www/html

RUN sed -i 's/user nginx;/user nobody;/g' /etc/nginx/nginx.conf

COPY ./conf/default.conf /etc/nginx/http.d/default.conf

COPY ./tools/ssl.sh /usr/local/bin/ssl.sh

RUN chmod +x /usr/local/bin/ssl.sh

EXPOSE 443

ENTRYPOINT [ "ssl.sh" ]

CMD [ "nginx", "-g", "daemon off;" ]
