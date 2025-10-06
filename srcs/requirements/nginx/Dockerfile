FROM alpine:3.21

RUN apk update && apk add --no-cache nginx

COPY ./conf/default.conf /etc/nginx/http.d/default.conf

RUN mkdir -p /var/www/html

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]