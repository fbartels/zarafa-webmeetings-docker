#!/bin/bash

sudo docker build -t zarafa-webmeetings-docker .

echo
read -p "Run this build?? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
	sudo docker run -it --env-file=env.conf \
	-p 10080:80 -p 10443:443 \
	zarafa-webmeetings-docker /bin/bash
fi
