#!/bin/bash
# replace url of Zarafa host
sed -i -e 's,file:///var/run/zarafa,'${ZARAFA_HOST}',g' /etc/zarafa/webapp/config.php

service php5-fpm start
service nginx start
service zarafa-presence start
service zarafa-webmeetings start
/bin/bash
