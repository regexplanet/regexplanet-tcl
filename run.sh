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
	--env PORT=5000 \
	--hostname tcl.regexplanet.com \
	--interactive \
	--name "${APP_NAME}" \
	--publish 5000:5000 \
	--rm \
	--tty \
	"${APP_NAME}"
