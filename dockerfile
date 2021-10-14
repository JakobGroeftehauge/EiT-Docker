FROM ros:melodic-ros-base

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Setting timezone 
ENV TZ=Europe/Copenhagen
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Opencv 3
COPY ./install-opencv.sh /
RUN sh -e /install-opencv.sh 


RUN apt-get update
RUN apt-get install -y build-essential cmake zlib1g-dev libcppunit-dev git subversion wget && rm -rf /var/lib/apt/lists/*

# Install ROS-Packages 
RUN apt update
RUN apt install ros-melodic-rgbd-launch ros-melodic-openni2-camera ros-melodic-openni2-launch -y
RUN apt install ros-melodic-image-transport


# Install openssl
RUN wget https://www.openssl.org/source/openssl-1.0.2g.tar.gz -O - | tar -xz
WORKDIR /openssl-1.0.2g
RUN ./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl && make && make install

# Setup user 
RUN useradd -m user -p "$(openssl passwd -1 user)"
RUN usermod -aG sudo user 

# Extra
RUN apt update && apt install -y nano \
                                 ssh \
                                 openssh* \
                                 sudo \
                                 gdb \
               && rm -rf /var/lib/apt/lists/*


# Setting user and the workdir
USER user
WORKDIR /home/user 
