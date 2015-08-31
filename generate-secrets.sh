#!/bin/sh

echo "WEBMEETINGS_SESSION_SECRET=$(xxd -ps -l 32 -c 32 /dev/random)" >> webmeetings-secrets.txt
echo "WEBMEETINGS_ENCRYPTION_SECRET=$(xxd -ps -l 32 -c 32 /dev/random)" >> webmeetings-secrets.txt

echo "WEBMEETINGS_SHARED_SECRET=$(xxd -ps -l 32 -c 32 /dev/random)" >> webmeetings-secrets.txt
echo "PRESENCE_SHARED_SECRET=$(xxd -ps -l 32 -c 32 /dev/random)" >> webmeetings-secrets.txt

if [ ! -e /etc/ssl/certs/dhparam.pem ]; then
	echo "creating dhparam"
	openssl dhparam -out dhparam.pem 4096
else
	echo "dhparam already exists"
fi
