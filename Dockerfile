FROM ubuntu:trusty
MAINTAINER Felix Bartels "felix@host-consultants.de"

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y

RUN apt-get install -y curl wget nginx php5-fpm ssl-cert
RUN rm /etc/nginx/sites-enabled/default

# Use Zarafa Debian Repo (internal only)
#RUN echo "deb http://devserver5.zarafa.com:82/zarafa-branches-7.2/Ubuntu_14.04/ /" > /etc/apt/sources.list.d/zarafa-obs.list \
#	&& echo "deb http://devserver5.zarafa.com:82/zarafa-extras/Ubuntu_14.04/ /" >> /etc/apt/sources.list.d/zarafa-obs.list \
#	&& curl http://devserver5.zarafa.com:82/zarafa-extras/Ubuntu_14.04/Release.key | apt-key add - \
#	&& curl http://devserver5.zarafa.com:82/zarafa-branches-7.2/Ubuntu_14.04/Release.key | apt-key add -

# Use packages from download.zarafa.com
# Downloading and installing Zarafa packages
RUN mkdir -p /root/packages \
        && wget --no-check-certificate --quiet \
        https://download.zarafa.com/zarafa/drupal/download_platform.php?platform=beta/7.2/7.2.1-49597/zcp-7.2.1-49597-ubuntu-14.04-x86_64-forhome.tar.gz -O- \
        | tar xz -C /root/packages --strip-components=1

WORKDIR /root/packages

# Downloading WebApp packages
RUN wget --quiet -p -r -nc -nd -l 1 -e robots=off -A deb --no-check-certificate https://download.zarafa.com/community/final/WebApp/2.0.2/ubuntu-14.04/

# Packing everything into a local repository and installing it
RUN apt-ftparchive packages . | gzip -9c > Packages.gz && echo "deb file:/root/packages ./" > /etc/apt/sources.list.d/zarafa.list

# Downloading latest Web Meetings release
RUN mkdir -p /root/webmeetings \
	&& wget --no-check-certificate --quiet \
	https://download.zarafa.com/zarafa/drupal/download_webmeetings.php?file=Zarafa-WebMeetings-1.0.49748.tar.gz -O- \
	| tar xz -C /root/webmeetings --strip-components=2

WORKDIR /root/webmeetings/ubuntu-14.04/x86_64

# Build local repo for Web Meetings
RUN apt-ftparchive packages . | gzip -9c > Packages.gz && echo "deb file:/root/webmeetings/ubuntu-14.04/x86_64/ ./" >> /etc/apt/sources.list.d/zarafa.list

# Installing packages (from here on its the same for devserver5 and the latest release)
RUN apt-get update -y
RUN apt-get install --allow-unauthenticated --assume-yes \
	php5-curl \
	zarafa-webapp \
	zarafa-presence \
	zarafa-webapp-plugins-meetings \
	zarafa-webmeetings

# Instal some more WebApp plugins
RUN apt-get install --allow-unauthenticated --assume-yes \
	zarafa-webapp-extbox \
	zarafa-webapp-files \
	zarafa-webapp-folderwidgets \
	zarafa-webapp-pdfbox \
	zarafa-webapp-titlecounter \
	zarafa-webapp-webappmanual

RUN ln -s /etc/php5/apache2/conf.d/zarafa.ini /etc/php5/fpm/conf.d/50-zarafa.ini

COPY /conf/zarafa-webmeetings.conf /etc/nginx/conf.d/zarafa-webmeetings.conf
COPY /conf/nginx.conf /etc/nginx/nginx.conf

# Entry-Script
COPY /scripts/init.sh /usr/local/bin/init.sh

# Set Entrypoint
ENTRYPOINT ["/usr/local/bin/init.sh"]
CMD ["nginx"]

# Expose ports.
EXPOSE 80
EXPOSE 443

# cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/packages /root/webmeetings
