# Use the same base image as your other services
FROM alpine:3.21

# Install necessary packages, including 'gettext' for envsubst
RUN apk update && apk add --no-cache nginx openssl netcat-openbsd gettext

# Create web root and set permissions (same as your original file)
RUN mkdir -p /var/www/html && \
    chown -R nobody:nobody /var/www/html

# Use non-privileged user for Nginx (same as your original file)
RUN sed -i 's/user nginx;/user nobody;/g' /etc/nginx/nginx.conf

# Copy the Nginx configuration TEMPLATE
COPY ./nginx/conf/default.conf /etc/nginx/http.d/default.conf.template
# Copy SSL script (path is now relative to the new context)
COPY ./nginx/tools/ssl.sh /usr/local/bin/ssl.sh
RUN chmod +x /usr/local/bin/ssl.sh

# ---- NEW: Copy your pre-built static site ----
# Copy the contents of the 'dist' folder to a new '/static-site' subdirectory in Nginx
COPY ./bonus/static-site/dist /var/www/html/static-site
# Ensure the permissions are correct for the web server user
RUN chown -R nobody:nobody /var/www/html/static-site

EXPOSE 443

# Entrypoint remains your SSL script
ENTRYPOINT [ "ssl.sh" ]

# Default command to run Nginx in the foreground
CMD [ "nginx", "-g", "daemon off;" ]