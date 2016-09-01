# EventQL
#
# VERSION	0.1

FROM ucodev/base

MAINTAINER Pedro A. Hortas <pah@ucodev.org>
LABEL Description="Install the latest version of EventQL" Vendor="uCodev" Version="0.1"

# Upgrade system
RUN apt-get update && apt-get upgrade -y

# Install dependencies
RUN apt-get install -y clang cmake make automake autoconf zlib1g-dev python-dev git
RUN echo "cc manual `which clang`" | update-alternatives --set-selections
RUN echo "c89 manual `which clang`" | update-alternatives --set-selections
RUN echo "c99 manual `which clang`" | update-alternatives --set-selections
RUN echo "c++ manual `which clang++`" | update-alternatives --set-selections
RUN update-alternatives --install /usr/bin/cpp cpp /usr/bin/clang++ 15
RUN echo "cpp manual `which clang++`" | update-alternatives --set-selections
RUN apt-get remove --purge -y gcc

# Fetch source
RUN git clone https://github.com/eventql/eventql /usr/src/eventql

# Configure, compile and install EventQL
WORKDIR /usr/src/eventql
RUN ./autogen.sh
RUN ./configure --enable-mysql-tools
RUN SHELL=/bin/bash make
RUN make install

# Copy example files
RUN mkdir /root/examples
COPY files/create_db.sh /root/examples/create_db.sh
RUN chmod 755 /root/examples/*

# Cleanup
WORKDIR /
RUN rm -rf /usr/src/eventql

