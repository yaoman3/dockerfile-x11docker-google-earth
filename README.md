# x11docker/google-earth
Run Google Earth in docker on a new separate X server<br>
Use x11docker to run image on separate new X server.<br>
Get x11docker script from github: https://github.com/mviereck/x11docker<br>

# Installation: Please build yourself
Download of Google Earth is disabled in the Dockerfile,
because it could be a copyright problem to publish 
the binaries of Google Earth in an image on Docker Hub.
To install Google Earth:
  * save Dockerfile on your computer
  * enable lines 'RUN wget ...' and 'RUN dpkg ...'
  * build image with command:<br>
    docker build -t google-earth /PATH/TO/DOCKERFILE/
  * Run image with command:<br>
    x11docker run google-earth
