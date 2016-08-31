# EventQL Cluster Node
#
# VERSION	0.1

FROM ucodev/eventql-base

MAINTAINER Pedro A. Hortas <pah@ucodev.org>
LABEL Description="Setup an EventQL cluster node" Vendor="uCodev" Version="0.1"

# Arguments
ARG EVENTQL_CLIENT_HOST="localhost"
ARG EVENTQL_CLIENT_PORT="9175"
ARG EVENTQL_SERVER_NAME="evql-cluster-01.somedomain.tld"
ARG EVENTQL_SERVER_DATADIR="/var/lib/eventql/"
ARG EVENTQL_SERVER_LISTEN="0.0.0.0:9175"
ARG EVENTQL_SERVER_INDEXBUILD_THREADS="2"
ARG EVENTQL_SERVER_CLIENT_AUTH_BACKEND="trust"
ARG EVENTQL_SERVER_PIDFILE="/var/run/eventql.pid"
ARG EVENTQL_CLUSTER_NAME="mycluster"
ARG EVENTQL_CLUSTER_COORDINATOR="zookeeper"
ARG EVENTQL_CLUSTER_ZOOKEEPER_HOSTS="evql-zookeeper-01.somedomain.tld:2181"

# Inform about the used ports
EXPOSE 9175


# Configure EventQL host
RUN echo "[client]" > /etc/evql.conf
RUN echo "host = ${EVENTQL_CLIENT_HOST}" >> /etc/evql.conf
RUN echo "port = ${EVENTQL_CLIENT_PORT}" >> /etc/evql.conf

RUN echo "[server]" > /etc/evqld.conf
RUN echo "name = ${EVENTQL_SERVER_NAME}" >> /etc/evqld.conf
RUN echo "datadir = ${EVENTQL_SERVER_DATADIR}" >> /etc/evqld.conf
RUN echo "listen = ${EVENTQL_SERVER_LISTEN}" >> /etc/evqld.conf
RUN echo "indexbuild_threads = ${EVENTQL_SERVER_INDEXBUILD_THREADS}" >> /etc/evqld.conf
RUN echo "client_auth_backend = ${EVENTQL_SERVER_CLIENT_AUTH_BACKEND}" >> /etc/evqld.conf
RUN echo "pidfile = ${EVENTQL_SERVER_PIDFILE}" >> /etc/evqld.conf

RUN echo >> /etc/evqld.conf

RUN echo "[cluster]" >> /etc/evqld.conf
RUN echo "name = ${EVENTQL_CLUSTER_NAME}" >> /etc/evqld.conf
RUN echo "coordinator = ${EVENTQL_CLUSTER_COORDINATOR}" >> /etc/evqld.conf
RUN echo "zookeeper_hosts = ${EVENTQL_CLUSTER_ZOOKEEPER_HOSTS}" >> /etc/evqld.conf


# Create data directory
RUN mkdir -p "${EVENTQL_SERVER_DATADIR}"


# Setup /etc/rc.local
COPY files/rc.local /etc/rc.local
RUN chmod 755 /etc/rc.local
WORKDIR /

