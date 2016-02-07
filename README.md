# IMPORTANT!

I am currently restructuring this image. So the steps below may not always work!


Before using the container you have to once start the image with the following command:
```
docker run -it --rm -v /usr/local/bin:/target -v /etc/z-container:/conf \
    fbartels/zarafa-webmeetings-docker instl
```
This installs a little helper script into **/usr/local/bin** that will be used for subsequent starts.

# Updating
The packages inside the container can be updated by executing

```docker exec zarafa-webmeetings update```

The image itself can be updated by executing

```
docker pull fbartels/zarafa-webmeetings-docker
docker stop zarafa-webmeetings
z-container-webmeetings
```


# zarafa-webmeetings-docker

**Q: what’s the benefit of having this?**

Docker provides and easy and fast way to run virtual machines for testing purposes. You only have to give this to a customer, so that he can give Web Meetings a try in his local environment, with his actual data, but without having to change anything in his current environment. 

**Q: what’s provided by this image?**

The image contains the latest released version of WebApp and Web Meetings, as well as zarafa-presence. 

**Q: what do I have to do, to get this running?**

You need to have Docker installed. After this has been done you can simply
- pull the image from the [Docker Hub](https://hub.docker.com/)

 ```docker pull fbartels/zarafa-webmeetings-docker```

- download the default configuration

 ```wget https://raw.githubusercontent.com/fbartels/zarafa-webmeetings-docker/master/env.conf```

- modify ```env.conf``` to point to your local Zarafa installation
- and then start the image

 ```docker run -it --env-file=env.conf --net=host fbartels/zarafa-webmeetings-docker```

 If you only want to change ZARAFA_HOST the following command works as well:

 ```docker run -it -e ZARAFA_HOST=http://my-zarafa:236/zarafa --net=host fbartels/zarafa-webmeetings-docker```

Just a few seconds after the last command has been issued you will be able to open the WebApp provided by the image (accessible from ```https://ip-of-your-docker-host:10443```), login and enjoy Zarafa Web Meetings.

## Building your own
This repository contains a small shell script to do a local build of this Dockerfile with the possiblity to directly start the image afterwards.
