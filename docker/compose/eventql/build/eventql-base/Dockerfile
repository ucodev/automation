# EventQL
#
# VERSION	0.1

FROM ucodev/base

MAINTAINER Pedro A. Hortas <pah@ucodev.org>
LABEL Description="Install the latest version of EventQL" Vendor="uCodev" Version="0.1"

# Install dependencies
RUN apt-get install -y g++ cmake make automake autoconf zlib1g-dev python-dev git

# Fetch source
RUN git clone https://github.com/eventql/eventql /usr/src/eventql

# Configure, compile and install EventQL
WORKDIR /usr/src/eventql
RUN ./autogen.sh && ./configure && SHELL=/bin/bash make && make install

