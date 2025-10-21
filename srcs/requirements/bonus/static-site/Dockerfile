# Use the same Alpine base as your other services
FROM alpine:3.21

RUN apk update && apk add nginx netcat-openbsd

COPY ./dist /var/www/localhost/htdocs

COPY ./conf/nginx.conf /etc/nginx/http.d/default.conf

RUN chown -R nginx:nginx /var/www/localhost/htdocs && \
    chmod -R 755 /var/www/localhost/htdocs

RUN mkdir -p /run/nginx && \
    chown -R nginx:nginx /run/nginx

EXPOSE 8080


CMD ["nginx", "-g", "daemon off;"]