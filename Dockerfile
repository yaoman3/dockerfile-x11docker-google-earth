# x11docker/google-earth
# V 1.1 from 26.09.2015
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
#
# changelog:
# 26.09.2015: V 1.1   included check if google-earth is installed


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

# script to check if google-earth is installed; if not, show error&exit; if yes, run google-earth
RUN echo "#! /bin/bash                                                          \n\
command -v google-earth >/dev/null 2>&1 || {                                    \n\
echo 'Error: Google Earth is not installed. Please enable installation of       \n\
Google Earth in Dockerfile und build docker image yourself.                     \n\
See https://hub.docker.com/r/x11docker/google-earth/ for details and reasons.   \n\
To install Google Earth:                                                        \n\
                                                                                \n\
  *  save Dockerfile on your computer                                           \n\
  *  enable lines "RUN wget ..." and "RUN dpkg ..."                             \n\
  *  build image with command:                                                  \n\
        docker build -t google-earth /PATH/TO/DOCKERFILE/                       \n\
  *  Run image with command:                                                    \n\
        x11docker run google-earth'                                             \n\
  exit 1                                                                        \n\
}                                                                               \n\
google-earth                                                                    \n\
" > /usr/local/bin/check-google-earth
RUN chmod +x /usr/local/bin/check-google-earth


CMD check-google-earth
