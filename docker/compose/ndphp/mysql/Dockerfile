# DBMS
#
# VERSION	0.1

FROM ucodev/base

MAINTAINER Pedro A. Hortas <pah@ucodev.org>
LABEL Description="Installs the MySQL Server" Vendor="uCodev" Version="0.1"

# Arguments
ARG MYSQL_ROOT_PASSWORD=password
ARG MYSQL_USER_DATABASE=userdb
ARG MYSQL_USER_USERNAME=username
ARG MYSQL_USER_PASSWORD=password

# Inform about the used ports
EXPOSE 3306

# Monitoring
HEALTHCHECK --interval=2m --timeout=3s \
    CMD service mysql status || exit 1

# Install MySQL (noninteractive to prevent installer to ask for password)
RUN /bin/bash -c "DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server mysql-client"
COPY files/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

# Start MySQL Server to allow password change via mysqladmin. Then stop it.
RUN /bin/bash -c "service mysql start; mysqladmin password \"${MYSQL_ROOT_PASSWORD}\"; service mysql stop"

# Create database, user/pass and grant access
RUN /bin/bash -c "service mysql start; echo \"CREATE DATABASE \\\`${MYSQL_USER_DATABASE}\\\`; CREATE USER '${MYSQL_USER_USERNAME}' IDENTIFIED BY '${MYSQL_USER_PASSWORD}'; GRANT ALL PRIVILEGES ON \\\`${MYSQL_USER_DATABASE}\\\`.* TO '${MYSQL_USER_USERNAME}'; FLUSH PRIVILEGES;\" | mysql -uroot -p\"${MYSQL_ROOT_PASSWORD}\"; service mysql stop"

