# BASE
#
# VERSION	0.1

FROM ubuntu

MAINTAINER Pedro A. Hortas <pah@ucodev.org>
LABEL Description="Installs the base system" Vendor="uCodev" Version="0.1"

# Setup base system
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y software-properties-common
RUN apt-add-repository multiverse
RUN apt-get update && apt-get -y upgrade

# Install network utilities
RUN apt-get install -y net-tools inetutils-ping inetutils-telnet inetutils-traceroute inetutils-ftp tcpdump curl wget

# Install a text editor
RUN apt-get install -y vim

