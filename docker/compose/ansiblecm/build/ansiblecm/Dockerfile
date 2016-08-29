# Ansible Control Machine
#
# VERSION	0.1

FROM ucodev/base

MAINTAINER Pedro A. Hortas <pah@ucodev.org>
LABEL Description="Installs an Ansible Control Machine" Vendor="uCodev" Version="0.1"

# Inform about the used ports
EXPOSE 22

# Install required services
RUN apt-get install -y ssh openssh-server

# Install ansible from ubuntu repositories
RUN apt-add-repository -y ppa:ansible/ansible
RUN apt-get update
RUN apt-get install -y ansible

# Create management directory
RUN mkdir -p /opt/ansiblecm

