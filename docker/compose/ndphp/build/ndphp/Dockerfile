# ND-PHP
#
# VERSION	0.1

FROM ucodev/apache

MAINTAINER Pedro A. Hortas <pah@ucodev.org>
LABEL Description="Installs the ND PHP Framework" Vendor="uCodev" Version="0.1"

# Inform about the used ports
EXPOSE 80

# Monitoring
HEALTHCHECK --interval=2m --timeout=3s \
    CMD curl -f -XGET http://localhost/nd-php/VERSION || exit 1

# Setup the default vhost
COPY files/000-default.conf /etc/apache2/sites-available/

# Setup ND PHP dependencies
RUN apt-get install -y php-mcrypt php-gd php-curl php-memcached php-mbstring php-xml php-mysql
RUN phpenmod mcrypt gd curl memcached mbstring xml

# Fetch latest version
ADD https://github.com/ucodev/nd-php/archive/master.tar.gz /var/www/html/
RUN mkdir /var/www/html/nd-php

# Extract it
RUN tar zxvf /var/www/html/master.tar.gz --strip 1 -C /var/www/html/nd-php
RUN rm /var/www/html/master.tar.gz

# Setup permissions
RUN chown -R www-data:www-data /var/www/html/nd-php


