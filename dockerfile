FROM ubuntu:18.04

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Setting timezone 
ENV TZ=Europe/Copenhagen
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


RUN apt-get update
RUN apt-get install -y build-essential cmake zlib1g-dev libcppunit-dev git subversion wget && rm -rf /var/lib/apt/lists/*

# Install openssl
RUN wget https://www.openssl.org/source/openssl-1.0.2g.tar.gz -O - | tar -xz
WORKDIR /openssl-1.0.2g
RUN ./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl && make && make install

# Setup user 
RUN useradd -m user -p "$(openssl passwd -1 user)"
RUN usermod -aG sudo user 

# Extra
RUN apt update && apt install -y vim \
                                 ssh \
                                 openssh* \
                                 sudo \
                                 gdb \
               && rm -rf /var/lib/apt/lists/*


# Setting user and the workdir
USER user
WORKDIR /home/user 
