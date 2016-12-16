# x11docker/google-earth
 * Run Google Earth in docker
 * Use [x11docker and x11docker-gui from github](https://github.com/mviereck/x11docker) to run image (allows you to run GUI applications in docker). 

# Don't pull image. Please build yourself
Download of Google Earth is disabled in Dockerfile due to copyright problems. (Google does not allow 3rd party deployment of its binaries). But it is allowed to download it during your own build.
To install Google Earth:

  * Get [Dockerfile from github](https://raw.githubusercontent.com/mviereck/dockerfile-x11docker-google-earth/master/Dockerfile)
  * Enable lines `RUN wget ...` and `RUN dpkg ...`
  * Build image with command: `docker build -t google-earth /PATH/TO/DOCKERFILE/`
  * Run image with command: `x11docker google-earth`
    
