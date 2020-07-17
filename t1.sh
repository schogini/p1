#!/bin/sh

docker network create tmp-net > /dev/null 2>&1
docker run --rm -d --name tmp-web --net tmp-net -e WEB=$1 $2
qq=$(docker run --rm --net tmp-net curlimages/curl:7.71.1 -s http://tmp-web:8123|grep -c "App Version: $1")
docker container rm -f tmp-web > /dev/null 2>&1
if [ $qq -gt 0 ]; then
	echo 0
else
	echo 1
fi
