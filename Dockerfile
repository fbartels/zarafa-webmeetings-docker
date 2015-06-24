FROM ubuntu:trusty
MAINTAINER Felix Bartels "felix@host-consultants.de"

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y

RUN apt-get install -y curl nginx php5-fpm ssl-cert
RUN rm /etc/nginx/sites-enabled/default

RUN echo "deb http://devserver5.zarafa.com:82/zarafa-branches-7.2/Ubuntu_14.04/ /" > /etc/apt/sources.list.d/zarafa-obs.list \
	&& echo "deb http://devserver5.zarafa.com:82/zarafa-extras/Ubuntu_14.04/ /" >> /etc/apt/sources.list.d/zarafa-obs.list \
	&& curl http://devserver5.zarafa.com:82/zarafa-extras/Ubuntu_14.04/Release.key | apt-key add - \
	&& curl http://devserver5.zarafa.com:82/zarafa-branches-7.2/Ubuntu_14.04/Release.key | apt-key add -
RUN apt-get update -y
RUN apt-get install -y php5-curl zarafa-webapp zarafa-presence zarafa-webapp-plugins-meetings zarafa-webmeetings
RUN ln -s /etc/php5/apache2/conf.d/zarafa.ini /etc/php5/fpm/conf.d/50-zarafa.ini

COPY /conf/zarafa-webmeetings.conf /etc/nginx/conf.d/zarafa-webmeetings.conf
COPY /conf/nginx.conf /etc/nginx/nginx.conf

# Entry-Script
COPY /scripts/init.sh /usr/local/bin/init.sh

# Set Entrypoint
ENTRYPOINT ["/usr/local/bin/init.sh"]

# Expose ports.
EXPOSE 80
EXPOSE 443

# cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
