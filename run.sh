#!/bin/bash
#
# run via docker
#

set -o errexit
set -o pipefail
set -o nounset

APP_NAME=regexplanet-tcl

docker build \
	--build-arg COMMIT=$(git rev-parse --short HEAD) \
	--build-arg LASTMOD=$(date -u +%Y-%m-%dT%H:%M:%SZ) \
	--progress=plain \
	--tag "${APP_NAME}" \
	.

docker run \
	--env PORT=4000 \
	--expose 4000 \
	--interactive \
	--name "${APP_NAME}" \
	--publish 4000:4000 \
	--rm \
	--tty \
	"${APP_NAME}"
