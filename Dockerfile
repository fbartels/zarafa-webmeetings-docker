FROM fbartels/zarafa-base
MAINTAINER Felix Bartels "felix@host-consultants.de"

RUN apt-get update -y

RUN apt-get install -y supervisor nginx php5-fpm ssl-cert
RUN rm /etc/nginx/sites-enabled/default

# Installing packages
RUN apt-get install --allow-unauthenticated --assume-yes \
	php5-curl \
	zarafa-presence \
	zarafa-webapp \
	zarafa-webapp-desktopnotifications \
	zarafa-webapp-files \
	zarafa-webapp-folderwidgets \
	zarafa-webapp-plugins-delayeddelivery \
	zarafa-webapp-plugins-filepreviewer \
	zarafa-webapp-plugins-meetings \
	zarafa-webapp-plugins-smime \
	zarafa-webapp-plugins-spell \
	zarafa-webapp-plugins-spell-de-de \
	zarafa-webapp-plugins-spell-en \
	zarafa-webapp-plugins-spell-nl \
	zarafa-webapp-titlecounter \
	zarafa-webapp-webappmanual \
	zarafa-webmeetings

RUN ln -s /etc/php5/apache2/conf.d/zarafa.ini /etc/php5/fpm/conf.d/50-zarafa.ini

COPY /conf/zarafa-webmeetings.conf /etc/nginx/conf.d/zarafa-webmeetings.conf
COPY /conf/nginx.conf /etc/nginx/nginx.conf

# helper scripts
COPY /scripts/instl /bin/instl
COPY /scripts/z-container-webmeetings /root/
COPY /conf/env.conf /root/
COPY /conf/supervisord.conf /etc/supervisord.conf

# Entry-Script
#COPY /scripts/init.sh /usr/local/bin/init.sh

# Set Entrypoint
CMD ["/usr/bin/supervisord -c /etc/supervisord.conf"]

# Buildtime environment variables to only define ZARAFA_HOST at startup
ENV HTTP_PORT 80
ENV HTTPS_PORT 443
ENV SERVER_NAME webapp.zarafa.local
ENV WEBMEETINGS_SESSION_SECRET d19a330d6a58bee2c6d6580fde169d9e4ed3d51d970e3ea2a823d17c72d26616
ENV WEBMEETINGS_ENCRYPTION_SECRET 93b3b642b40a8cc8fb9e684d466abf69ef983806c0dce342f99527f4516dd59f
ENV WEBMEETINGS_SHARED_SECRET 6d0a022e3a8e77022edd97bd4331d86e378f9811cd8ae82e2c4e9b27f16b7adf
ENV PRESENCE_SHARED_SECRET bb92a42fb7b5ab6acb85dba03961444269d23382c0f0b663e29b084e54f995b5

EXPOSE 80 443

# cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
