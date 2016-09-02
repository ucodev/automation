# SWAGGER-UI
#
# VERSION	0.1

FROM ucodev/base

MAINTAINER Pedro A. Hortas <pah@ucodev.org>
LABEL Description="Install the swagger-ui" Vendor="uCodev" Version="0.1"

# Inform about the used ports
EXPOSE 80

# Upgrade the system
RUN apt-get update && apt-get upgrade -y

# Install dependencies
RUN apt-get install -y apache2 git

# Install swagger-core
WORKDIR /usr/src
RUN git clone https://github.com/swagger-api/swagger-ui
WORKDIR /usr/src/swagger-ui
RUN cp -r ./dist/* /var/www/html/

# Add rc.local
COPY files/rc.local /etc/rc.local
RUN chmod 755 /etc/rc.local

