#!/bin/bash

docker build -t regexplanet-tcl .
docker run \
	-p 4000:80 --expose 4000 -e PORT='80' \
	-e COMMIT=$(git rev-parse --short HEAD) \
	-e LASTMOD=$(date -u +%Y-%m-%dT%H:%M:%SZ) \
	regexplanet-tcl

#docker run -it -p 4000:80 -v "$PWD/www":/usr/local/apache2/htdocs/ httpd:2.4
