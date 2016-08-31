# ZOOKEEPER
#
# Version	0.1

FROM ucodev/base

MAINTAINER Pedro A. Hortas <pah@ucodev.org>
LABEL Description="Installs a ZooKeeper instance" Vendor="uCodev" Version="0.1"

# Arguments
ARG ZOOKEEPER_CLUSTER_ID=1

# Inform about the used ports
EXPOSE 2181

# Upgrade the system
RUN apt-get update && apt-get upgrade -y

# Install zookeeper
RUN apt-get install -y zookeeper

# Set cluster ID
RUN echo ${ZOOKEEPER_CLUSTER_ID} > /etc/zookeeper/myid

# Copy /etc/rc.local
COPY files/rc.local /etc/rc.local
RUN chmod 755 /etc/rc.local

