FROM ubuntu:14.04
MAINTAINER anto "m07158031@o365.mcut.edu.tw"
ENV DEBIAN_FRONTEND noninteractive

USER root
WORKDIR /root

# Use C.UTF-8 locale to avoid issues with ASCII encoding
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV locale-gen en_US.UTF-8
ENV dpkg-reconfigure locales

RUN apt-get update \
	&& apt-get install -qqy x11-apps \
	&& apt-get install -y --no-install-recommends \
		openssh-server \
		build-essential \
		gcc \
		libsqlite3-dev \
		sqlite3 \
		xdg-utils \
 		nano \
		git \
		gedit \
		make \
		sudo \
		tree \
		vim \
		unzip \
		curl \ 
		wget \
		gdb \
		g++ \
		finger \
		software-properties-common \
		pkg-config \
  		python3-pip \
		python3-dev \
		dbus-x11 \
		x11-xserver-utils \
		net-tools \
		man-db \
		firefox \
		xorg \
		xterm \
	&& apt-get autoremove -y \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	&& cd /usr/local/bin \
	&& ln -s /usr/bin/python3 python \
	&& pip3 install --upgrade pip \
	&& pip install --upgrade setuptools \
	&& sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
	&& apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 \
	&& apt-get update && sudo apt-get install dpkg \
	&& apt-get install -y ros-indigo-desktop-full


# Create user "Sudoer" with sudo powers
RUN useradd -m sudoer \
	&& echo "sudoer:123456" | chpasswd \
	&& usermod -aG sudo sudoer \
	#&& echo '%sudo ALL=(ALL:ALL) ALL' >> /etc/sudoers \
	&& sudo usermod -s /bin/bash sudoer \
	&& cp /root/.bashrc /home/sudoer/ \
	&& echo "You success make a new user, good job !!" >> /etc/skel/readme.txt \
	#&& mkdir /home/sudoer/workdir \
	&& chown -R --from=root sudoer /home/sudoer \ 
	&& echo 'echo -ne "\033]10;#FFFFFF\007"' >> /etc/skel/.bashrc \
	&& echo 'echo -ne "\033]11;#2F0909\007"' >> /etc/skel/.bashrc \
	&& echo 'cd' >> /etc/skel/.bashrc

RUN sudo rosdep init \
	&& rosdep update 

WORKDIR /home/sudoer
ENV HOME /home/sudoer
ENV USER sudoer
USER sudoer
ENV PATH $HOME/.local/bin:$PATH

# Avoid first use of sudo warning.
RUN touch /home/sudoer/.sudo_as_admin_successful
RUN echo "source /opt/ros/indigo/setup.bash" >> ~/.bashrc
#setting the home directory
#RUN echo 'HOME=/home/sudoer' >> /home/sudoer/.bashrc
#RUN echo 'export NO_AT_BRIDGE=1' >> /home/sudoer/.bashrc

CMD [ "/bin/bash" ]