#!/bin/bash
#export SERVER_SOFTWARE="Dev"
echo "Starting adventureland node client"

while [ ! -d "/alserver/appserver" ]; do
 echo "appserver directory does not exist waiting for docker to set up"
 sleep 10
done

echo "giving adventureland python server time to start"
sleep 10

cd /alserver/adventureland/node

if [ -z $1 ]; then
    echo "server name required"
    exit 1
fi

if [ -z $2 ]; then
    echo "server identifier required"
    exit 1
fi

if [ -z $3 ]; then
    echo "server port required"
    exit 1
fi


echo "Starting $1 $2 on port $3"
exec node server.js $1 $2 $3
