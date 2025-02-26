#!/bin/bash
#export SERVER_SOFTWARE="Dev"

cd /alserver

if [ ! -d "adventureland" ]; then
 echo "Cloning adventureland"
 git clone https://github.com/kaansoral/adventureland adventureland
 cp adventureland/useful/template.secrets.py adventureland/secrets.py
 cp adventureland/useful/template.variables.js adventureland/node/variables.js
 cp adventureland/useful/template.live_variables.js adventureland/node/live_variables.js
 pip install flask -t adventureland/lib
 npm install adventureland/scripts/
 npm install adventureland/node/
fi

# If not yet cloned, clone the repository. Means first time ran.
if [ ! -d "appserver" ]; then
 echo "Cloning appserver"
 git clone https://github.com/kaansoral/adventureland-appserver appserver
 #echo "Patching appserver"
 #sed -i 's/allowed_ips=\[[^]].*\]/allowed_ips=["^(?:::f{4}:)?(?:[0-9]{1,3}\.){3}[0-9]{1,3}$|^(?:::)?(?:[0-9a-f]{1,4}:){1,7}[0-9a-f]{1,4}$"]/g' appserver/sdk/lib/cherrypy/cherrypy/wsgiserver/wsgiserver2.py
 sed -i 's/allowed_ips=\[[^]].*\]/allowed_ips=["^127\.0\.0\.1$","^78\.167\..?.?.?\..?.?.?$","^::1$","^5\.46\..?.?.?\..?.?.?$","^192.168.1\..?.?.?$","^(?:::f{4}:)?(?:[0-9]{1,3}\.){3}[0-9]{1,3}$|^(?:::)?(?:[0-9a-f]{1,4}:){1,7}[0-9a-f]{1,4}$"]/g' appserver/sdk/lib/cherrypy/cherrypy/wsgiserver/wsgiserver2.py
 #sed -i 's/: logging\.info("External Allowed IP Tried to Ha/ and gg == 0: logging\.info("External Allowed IP Tried to Ha/g' appserver/sdk/lib/cherrypy/cherrypy/wsgiserver/wsgiserver2.py
  # set this to the ip of your docker host so websockets will work in the browser and the map will draw
  sed -i 's/0\.0\.0\.0/192.168.1.54/g' adventureland/js/game.js
fi

exec python appserver/sdk/dev_appserver.py --storage_path=appserver/storage/ --blobstore_path=appserver/storage/blobstore/ --datastore_path=appserver/storage/db.rdbms --host=0.0.0.0 --port=80 --admin_port=8081 --admin_host=0.0.0.0 adventureland/ --require_indexes --skip_sdk_update_check
