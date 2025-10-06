FROM alpine:3.18

RUN apk update && apk add nginx

RUN mkdir -p /run/nginx
COPY default.conf /etc/nginx/http.d/

RUN mkdir -p /etc/nginx/ssl

COPY ./ssl/inception.crt /etc/nginx/ssl/
COPY ./ssl/inception.key /etc/nginx/ssl/

CMD ["nginx", "-g", "daemon off;"]
