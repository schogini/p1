#!/bin/sh

docker network create tmp-net > log.txt 2>&1
docker run --rm -d --name tmp-web --net tmp-net -e WEB=$1 $2 >> log.txt 2>&1
qq=$(docker run --rm --net tmp-net curlimages/curl:7.71.1 -s http://tmp-web:8123|grep -c "App Version: $1")
docker container rm -f tmp-web >> log.txt 2>&1
if [ $qq -gt 0 ]; then
	echo "SUCCESS" > result.txt
else
	echo "FAILED" > result.txt
fi
cat result.txt
