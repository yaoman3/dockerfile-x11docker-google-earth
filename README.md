# x11docker/google-earth
Run Google Earth in docker on a new separate X server<br>
Use x11docker to run image on separate new X server.<br>
Get x11docker script from github: https://github.com/mviereck/x11docker<br>
Known issues:
 - Google Earth can crash suddenly because of a bug in its own libs. A patch is available and can be included in the image, but it has no static internet adress for download, what makes it impossible for me to include it in the dockerfile. (See https://productforums.google.com/forum/?fromgroups=#!category-topic/earth/linux/_h4t6SpY_II%5B1-25-false%5D). (Patch available at https://docs.google.com/file/d/0B2F__nkihfiNOUJSeEJfWUx0Vk0/edit?usp=sharing)
 - OpenGL is not supported yet. I'm checking out for possibilities.

# Don't pull image. Please build yourself
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
