# SWAGGER-CORE
#
# VERSION	0.1

FROM ucodev/base

MAINTAINER Pedro A. Hortas <pah@ucodev.org>
LABEL Description="Install the swagger-core" Vendor="uCodev" Version="0.1"

# Upgrade the system
RUN apt-get update && apt-get upgrade -y

# Install dependencies
RUN apt-get install -y openjdk-8-jdk maven git

# Install swagger-core
WORKDIR /usr/src
RUN git clone https://github.com/swagger-api/swagger-core
WORKDIR /usr/src/swagger-core
RUN mvn -N
RUN mvn install

