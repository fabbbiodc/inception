FROM alpine:3.21

RUN apk update && apk add --no-cache vsftpd linux-pam shadow

COPY ./conf/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY ./conf/vsftpd.pam /etc/pam.d/vsftpd
COPY ./tools/ftp-init.sh /usr/local/bin/ftp-init.sh

RUN chmod +x /usr/local/bin/ftp-init.sh

RUN mkdir -p /var/www/html
RUN mkdir -p /var/run/vsftpd/empty

EXPOSE 21
EXPOSE 21000-21010

ENTRYPOINT [ "/usr/local/bin/ftp-init.sh" ]

CMD [ "/usr/sbin/vsftpd", "/etc/vsftpd/vsftpd.conf" ]