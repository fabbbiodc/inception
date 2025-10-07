FROM alpine:3.21

RUN apk update && apk add --no-cache nginx

RUN mkdir -p /var/www/html && \
    chown -R nobody:nobody /var/www/html

RUN sed -i 's/user nginx;/user nobody;/g' /etc/nginx/nginx.conf

COPY ./conf/default.conf /etc/nginx/http.d/default.conf

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]