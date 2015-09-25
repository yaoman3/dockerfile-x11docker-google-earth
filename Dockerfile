# x11docker/google-earth
# V 1.0 from 25.09.2015
#
# Run Google Earth in docker. 
# Use x11docker to run image on separate new X server.
# Get x11docker script from github: https://github.com/mviereck/x11docker
#
# NOTE:
# Download of Google Earth is disabled in this Dockerfile,
# because it could be a copyright problem to publish 
# the binaries in an image on Docker Hub.
# To install Google Earth:
#  * save this Dockerfile on your computer
#  * enable lines 'RUN wget ...' and 'RUN dpkg ...'
#  * build image with command:
#    docker build -t google-earth /PATH/TO/DOCKERFILE
#  * Run image with command:
#    x11docker run google-earth

FROM phusion/baseimage:latest

RUN apt-get  update

# Set environment variables 
ENV HOME /root 
ENV DEBIAN_FRONTEND noninteractive 
ENV LC_ALL en_US.UTF-8 
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US.UTF-8

# fix problems with dictionaries-common
# See https://bugs.launchpad.net/ubuntu/+source/dictionaries-common/+bug/873551
RUN apt-get install -y apt-utils
RUN /usr/share/debconf/fix_db.pl
RUN apt-get install -y -f

# install wget and some dependencies for google earth
RUN apt-get install -y --no-install-recommends wget
RUN apt-get install -y --no-install-recommends xdg-utils
RUN apt-get install -y xvfb
RUN apt-get install -y libfontconfig1
RUN apt-get install -y libxrender1
RUN apt-get install -y libglu1-mesa

###################
# Enable the following two commands to download and install Google Earth current
#RUN wget https://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb
#RUN dpkg --force-all -i google-earth-stable_current_amd64.deb
###################

RUN apt-get -y -f install 
RUN apt-get clean

CMD google-earth
