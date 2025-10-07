FROM alpine:3.21

RUN apk update && apk add --no-cache nginx

RUN sed -i 's/user nginx;/user nobody;/g' /etc/nginx/nginx.conf

COPY ./conf/default.conf /etc/nginx/http.d/default.conf

RUN chown nobody:nobody /etc/nginx/http.d/default.conf && \
    chmod 644 /etc/nginx/http.d/default.conf

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]