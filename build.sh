#!/bin/bash

sudo docker build --no-cache -t zarafa-webmeetings-docker .

sudo docker run -it --rm -v /usr/local/bin:/target -v /etc/z-container:/conf zarafa-webmeetings-docker instl
