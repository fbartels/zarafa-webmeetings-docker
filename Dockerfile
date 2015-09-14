FROM fbartels/zarafa-base
MAINTAINER Felix Bartels "felix@host-consultants.de"

RUN apt-get update -y

RUN apt-get install -y nginx php5-fpm ssl-cert
RUN rm /etc/nginx/sites-enabled/default

WORKDIR /root/packages

# Downloading WebApp packages
RUN wget --quiet -p -r -nc -nd -l 1 -e robots=off -A deb --no-check-certificate https://download.zarafa.com/community/beta/WebApp/2.1.0/RC1/ubuntu-14.04/
RUN wget https://download.zarafa.com/community/final/WebApp/plugins/SMIME%201.0/ubuntu-14.04/x86_64/zarafa-webapp-plugins-smime_1.0_all.deb

# Packing everything into a local repository and installing it
RUN apt-ftparchive packages . | gzip -9c > Packages.gz && echo "deb file:/root/packages ./" > /etc/apt/sources.list.d/zarafa.list

# Downloading latest Web Meetings release
ENV DOWNLOADURL https://download.zarafa.com/zarafa/drupal/download_webmeetings.php?file=Zarafa-WebMeetings-1.1-RC1.tar.gz
RUN mkdir -p /root/webmeetings \
	&& wget --no-check-certificate --quiet \
	$DOWNLOADURL -O- | tar xz -C /root/webmeetings --strip-components=2

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
	zarafa-webapp-desktopnotifications \
	zarafa-webapp-extbox \
	zarafa-webapp-files \
	zarafa-webapp-folderwidgets \
	zarafa-webapp-pdfbox \
	zarafa-webapp-plugins-delayeddelivery \
	zarafa-webapp-plugins-smime \
	zarafa-webapp-titlecounter \
	zarafa-webapp-webappmanual \
	zarafa-webapp-webodf

RUN ln -s /etc/php5/apache2/conf.d/zarafa.ini /etc/php5/fpm/conf.d/50-zarafa.ini

COPY /conf/zarafa-webmeetings.conf /etc/nginx/conf.d/zarafa-webmeetings.conf
COPY /conf/nginx.conf /etc/nginx/nginx.conf

# Entry-Script
COPY /scripts/init.sh /usr/local/bin/init.sh

# Set Entrypoint
ENTRYPOINT ["/usr/local/bin/init.sh"]
CMD ["nginx"]

# Buildtime environment variables to only define ZARAFA_HOST at startup
ENV HTTP_PORT 10080
ENV HTTPS_PORT 10443
ENV SERVER_NAME webapp.zarafa.local
ENV WEBMEETINGS_SESSION_SECRET d19a330d6a58bee2c6d6580fde169d9e4ed3d51d970e3ea2a823d17c72d26616
ENV WEBMEETINGS_ENCRYPTION_SECRET 93b3b642b40a8cc8fb9e684d466abf69ef983806c0dce342f99527f4516dd59f
ENV WEBMEETINGS_SHARED_SECRET 6d0a022e3a8e77022edd97bd4331d86e378f9811cd8ae82e2c4e9b27f16b7adf
ENV PRESENCE_SHARED_SECRET bb92a42fb7b5ab6acb85dba03961444269d23382c0f0b663e29b084e54f995b5

EXPOSE 10080 10443

# cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/packages /root/webmeetings /etc/apt/sources.list.d/zarafa.list
