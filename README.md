# x11docker/google-earth
 * Run Google Earth in docker
 * Use x11docker to run image. 
 * Get x11docker and x11docker-gui from github: 
 *   https://github.com/mviereck/x11docker 

# Don't pull image. Please build yourself
Download of Google Earth is disabled in the Dockerfile,
because it is a copyright problem to publish 
the binaries of Google Earth on Docker Hub.
To install Google Earth:
  * get Dockerfile from github:<br>
https://raw.githubusercontent.com/mviereck/dockerfile-x11docker-google-earth/master/Dockerfile
  * enable lines 'RUN wget ...' and 'RUN dpkg ...'
  * build image with command:<br>
    docker build -t google-earth /PATH/TO/DOCKERFILE/
  * Run image with command:<br>
    x11docker google-earth
    
