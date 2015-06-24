#!/bin/bash
# replace url of Zarafa host
sed -i -e 's,file:///var/run/zarafa,'${ZARAFA_HOST}',g' /etc/zarafa/webapp/config.php

# replace secrets
sed -i -e 's,GEHEIM,'${PRESENCE_SHARED_SECRET}',g' /etc/zarafa/presence.cfg
sed -i -e 's,the-default-secret-do-not-keep-me,'${WEBMEETINGS_SHARED_SECRET}',g' /etc/zarafa/webapp/config-meetings.php
sed -i -e '0,/false/s/false/true/' /etc/zarafa/webapp/config-meetings.php
sed -i -e 's,test,'${PRESENCE_SHARED_SECRET}',g' /etc/zarafa/webapp/config-meetings.php
sed -i -e 's,the-default-secret-do-not-keep-me,'${WEBMEETINGS_SESSION_SECRET}',g' /etc/zarafa/webmeetings.cfg
sed -i -e 's,tne-default-encryption-block-key,'${WEBMEETINGS_ENCRYPTION_SECRET}',g' /etc/zarafa/webmeetings.cfg
sed -i -e 's,some-secret-do-not-keep,'${WEBMEETINGS_SHARED_SECRET}',g' /etc/zarafa/webmeetings.cfg
sed -i -e 's,/webapp/plugins/spreedwebrtc/php/AngularPluginWrapper.php,../plugins/spreedwebrtc/php/AngularPluginWrapper.php,g' /etc/zarafa/webmeetings.cfg

service php5-fpm start
service nginx start
service zarafa-presence start
service zarafa-webmeetings start
/bin/bash
