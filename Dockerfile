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
#
# Update 2015-10-05: * fixed bug using a patch from amirpli
#                    * improved installation routine
#                    * creating config file for google earth

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

# install wget and some dependencies for google earth (minimal to get it running)
RUN apt-get install -y xorg
RUN apt-get install -y --no-install-recommends wget
RUN apt-get install -y --no-install-recommends xdg-utils
RUN apt-get install -y gdebi-core
RUN apt-get install -y libfreeimage3
RUN apt-get install -y tar
RUN apt-get install -y mrxvt                               # terminal emulator

###################
# Enable the following two commands to download and install Google Earth current
#RUN wget https://dl.google.com/dl/earth/client/current/google-earth-stable_current_amd64.deb
#RUN gdebi -n google-earth-stable_current_amd64.deb
###################

RUN apt-get install -y mesa-utils
RUN apt-get install -y xserver-xorg-video-all

# Patch for google earth from amirpli to fix some bugs in google earth
# See https://productforums.google.com/forum/?fromgroups=#!category-topic/earth/linux/_h4t6SpY_II%5B1-25-false%5D
# and Readme-file https://docs.google.com/file/d/0B2F__nkihfiNMDlaQVoxNVVlaUk/edit?pli=1 for details
# Quote: "Update: This solution works fine also on Ubuntu 12.10 and 13.04 if you uncheck 
#        the "Compress" box in Tools->Options->3D View (under "Texture Colors")."
RUN mkdir -p /opt/google/earth
RUN cd /opt/google/earth
RUN cp -a /opt/google/earth/free /opt/google/earth/free.newlibs
RUN wget -O /opt/google/earth/free.newlibs/ge7.1.1.1580-0.x86_64-new-qt-libs-debian7-ubuntu12.tar.xz "https://doc-0k-24-docs.googleusercontent.com/docs/securesc/ha0ro937gcuc7l7deffksulhg5h7mbp1/6nggrqasnsdh7ffc403adado6siv9uba/1444032000000/12191820241974564035/*/0B2F__nkihfiNOUJSeEJfWUx0Vk0?e=download"
RUN tar xvf /opt/google/earth/free.newlibs/ge7.1.1.1580-0.x86_64-new-qt-libs-debian7-ubuntu12.tar.xz
RUN mv /usr/bin/google-earth /usr/bin/google-earth.old
RUN ln -s /opt/google/earth/free.newlibs/googleearth /usr/bin/google-earth

RUN apt-get clean

# create config file for google earth
# * no tips on startup
# * no tourguide filmstrip
# * don't send usage stats to google
# * disable texture compression to avoid ugly shapes
RUN mkdir -p /root/.config/Google
RUN echo '[General]            \n\
enableTips=false               \n\
UsageStats=false               \n\
[TourGuide]                    \n\
Filmstrip\Enabled=false        \n\
[Render]                       \n\
TextureCompression=false       \n\
' > /root/.config/Google/GoogleEarthPlus.conf


# script to check if google-earth is installed; if not, show error&exit; if yes, run google-earth
RUN echo "#! /bin/bash                                                          \n\
command -v google-earth >/dev/null 2>&1 || {                                    \n\
echo 'Error: Google Earth is not installed. Please enable installation of       \n\
Google Earth in Dockerfile und build docker image yourself.                     \n\
See https://hub.docker.com/r/x11docker/google-earth/ for details and reasons.   \n\
To install Google Earth:                                                        \n\
                                                                                \n\
  *  save Dockerfile on your computer                                           \n\
  *  enable lines "RUN wget ..." and "RUN gdebi ..."                            \n\
  *  build image with command:                                                  \n\
       docker build -t google-earth /PATH/TO/DOCKERFILE/                        \n\
      (replace /PATH/TO/DOCKERFILE to the folder where you saved the Dockerfile)\n\
  *  Run image with command:                                                    \n\
       x11docker run google-earth'                                              \n\
  exit 1                                                                        \n\
}                                                                               \n\
echo 'Please uncheck the Compress box in Tools->Options->3D View (under Texture'\n\
echo 'Colors) to get clean graphics in Google Earth.'                           \n\
google-earth                                                                    \n\
" > /usr/local/bin/check-google-earth
RUN chmod +x /usr/local/bin/check-google-earth


CMD check-google-earth
