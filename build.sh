#!/bin/bash

sudo docker rm zarafa-webmeetings

sudo docker build -t zarafa-webmeetings-docker .

sudo docker run --name=zarafa-webmeetings -it --rm -v /usr/local/bin:/target -v /etc/z-container:/conf zarafa-webmeetings-docker instl
