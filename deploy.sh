#!/bin/bash
#docker login -u oauth2accesstoken -p "$(gcloud auth print-access-token)" https://gcr.io

set -o errexit
set -o pipefail
set -o nounset

docker build -t regexplanet-tcl .
docker tag regexplanet-tcl:latest gcr.io/regexplanet-hrds/tcl:latest
docker push gcr.io/regexplanet-hrds/tcl:latest

gcloud beta run deploy regexplanet-tcl \
	--image gcr.io/regexplanet-hrds/tcl \
	--platform managed \
	--project regexplanet-hrds \
	--region us-central1 \
	--update-env-vars "COMMIT=$(git rev-parse --short HEAD),LASTMOD=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
