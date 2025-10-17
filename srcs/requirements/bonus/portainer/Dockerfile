FROM alpine:3.21

RUN apk update && apk add --no-cache curl tar

# Create app directory
RUN mkdir -p /app

WORKDIR /app

# Download and install Portainer
RUN curl -L -o portainer.tar.gz "https://github.com/portainer/portainer/releases/download/2.33.2/portainer-2.33.2-linux-amd64.tar.gz" && \
    tar xvzf portainer.tar.gz --strip-components=1 && \
    rm portainer.tar.gz

EXPOSE 8000 9443

# Set the entrypoint to run Portainer
ENTRYPOINT [ "/app/portainer" ]

# Define volume for persistent data
ENTRYPOINT [ "/app/portainer", "--admin-password-file=/run/secrets/portainer_admin_password" ]