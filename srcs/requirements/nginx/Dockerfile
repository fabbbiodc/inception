FROM alpine:3.21

RUN apk update && apk add --no-cache nginx openssl netcat-openbsd gettext

RUN mkdir -p /var/www/html && \
    chown -R nobody:nobody /var/www/html

RUN sed -i 's/user nginx;/user nobody;/g' /etc/nginx/nginx.conf

COPY ./nginx/conf/default.conf /etc/nginx/http.d/default.conf.template

COPY ./nginx/tools/ssl.sh /usr/local/bin/ssl.sh

RUN chmod +x /usr/local/bin/ssl.sh

COPY ./bonus/static-site/dist /var/www/html/static-site

RUN chown -R nobody:nobody /var/www/html/static-site

EXPOSE 443

ENTRYPOINT [ "ssl.sh" ]

CMD [ "nginx", "-g", "daemon off;" ]