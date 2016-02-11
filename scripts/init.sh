#!/bin/bash

#if [ -z $ZARAFA_HOST ]; then
#	cat << EOF
#
#ERROR:
#This image needs a set of environment variables specified. The example configuration can be found at https://github.com/fbartels/zarafa-webmeetings-docker/blob/master/env.conf.
#
#With this file you can then start the container in the following way:
#
#docker run -it --env-file=env.conf --net=host zarafa-webmeetings-docker
#
#EOF
#	exit 1
#fi

cat << EOF

This Docker container helps you run/test Zarafa Web Meetings. All your data remains on your current server and this container only serves as a (disposable) frontend.

All you have to do is set ZARAFA_HOST to point to your current server in the accompanying env.conf. For added security you can also customise the individual secrects and add your own ssl certificates.

Zarafa Web Meetings and a custom Zarafa WebApp will be available shortly via https://IP-of-your-docker-host:$HTTPS_PORT (regular http requests will be redirected).

EOF

# replace url of Zarafa host
sed -i -e 's,file:///var/run/zarafa,'${ZARAFA_HOST}',g' /etc/zarafa/webapp/config.php

# set http(s) ports and server name
sed -i -e 's,HTTP_PORT,'${HTTP_PORT}',g' /etc/nginx/conf.d/zarafa-webmeetings.conf
sed -i -e 's,HTTPS_PORT,'${HTTPS_PORT}',g' /etc/nginx/conf.d/zarafa-webmeetings.conf
sed -i -e 's,SERVER_NAME,'${SERVER_NAME}',g' /etc/nginx/conf.d/zarafa-webmeetings.conf

# replace secrets
sed -i -e 's,GEHEIM,'${PRESENCE_SHARED_SECRET}',g' /etc/zarafa/presence.cfg
sed -i -e 's,the-default-secret-do-not-keep-me,'${WEBMEETINGS_SHARED_SECRET}',g' /etc/zarafa/webapp/config-meetings.php
sed -i -e '0,/false/s/false/true/' /etc/zarafa/webapp/config-meetings.php
sed -i -e 's,/webapp/,/,g' /etc/zarafa/webapp/config-meetings.php
sed -i -e 's,test,'${PRESENCE_SHARED_SECRET}',g' /etc/zarafa/webapp/config-meetings.php
sed -i -e 's,the-default-secret-do-not-keep-me,'${WEBMEETINGS_SESSION_SECRET}',g' /etc/zarafa/webmeetings.cfg
sed -i -e 's,tne-default-encryption-block-key,'${WEBMEETINGS_ENCRYPTION_SECRET}',g' /etc/zarafa/webmeetings.cfg
sed -i -e 's,some-secret-do-not-keep,'${WEBMEETINGS_SHARED_SECRET}',g' /etc/zarafa/webmeetings.cfg
sed -i -e 's,/webapp/plugins/spreedwebrtc/php/AngularPluginWrapper.php,/plugins/spreedwebrtc/php/AngularPluginWrapper.php,g' /etc/zarafa/webmeetings.cfg

if [[ ! -z $SSL_CERTIFICATE ]] || [[ ! -z $SSL_CERTIFICATE_KEY ]]; then
	echo "using certificate specified in env.conf"
	echo -e "$SSL_CERTIFICATE" > /etc/ssl/certs/ssl-cert-snakeoil.pem
	echo -e "$SSL_CERTIFICATE_KEY" > /etc/ssl/private/ssl-cert-snakeoil.key
fi

if [[ ! -z $SSL_DHPARAM ]]; then
	echo "using dhparam from env.conf"
	echo -e "$SSL_DHPARAM" > /etc/ssl/certs/dhparam.pem
	sed -i '/ssl_dhparam/s/^#//g' /etc/nginx/conf.d/zarafa-webmeetings.conf
fi

service php5-fpm start
service zarafa-presence start
service zarafa-webmeetings start

# exec CMD
echo "Starting $@ .."
exec supervisor -c /etc/supervisor.conf
