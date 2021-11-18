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
RUN apt-get install software-properties-common -y
RUN apt-get install -y build-essential cmake zlib1g-dev libcppunit-dev git subversion wget && rm -rf /var/lib/apt/lists/*

RUN rm /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python 

# packages needed to run ROS melodic with python2.7
RUN apt update
RUN apt install python2.7
RUN apt-get install -y python-pip 
RUN apt-get install -y python3-pip 
RUN pip install catkin_pkg
RUN pip install rospkg
RUN pip install netifaces
RUN pip install rosdep
RUN pip install defusedxml
RUN pip install scipy
RUN rosdep update 

# Install ROS-Packages 
RUN apt install ros-melodic-rgbd-launch ros-melodic-openni2-camera ros-melodic-openni2-launch -y
RUN apt install ros-melodic-image-transport ros-melodic-tf2-tools ros-melodic-tf -y
RUN apt install ros-melodic-cv-bridge -y
RUN apt install ros-melodic-rqt-reconfigure -y


RUN add-apt-repository ppa:sdurobotics/ur-rtde
RUN apt-get update
RUN apt install librtde librtde-dev

RUN pip install --upgrade pip
RUN pip install ur_rtde


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

RUN cd /home/user/ && \
		wget https://www.coppeliarobotics.com/files/CoppeliaSim_Edu_V4_2_0_Ubuntu18_04.tar.xz && \
		tar -xf CoppeliaSim_Edu_V4_2_0_Ubuntu18_04.tar.xz && \
		rm CoppeliaSim_Edu_V4_2_0_Ubuntu18_04.tar.xz
