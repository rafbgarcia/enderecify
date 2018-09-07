#!/bin/sh
set -ex
export HOME=/app
mkdir -p ${HOME}
cd ${HOME}
RELEASE_URL=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/attributes/release-url" -H "Metadata-Flavor: Google")
gsutil cp ${RELEASE_URL} enderecify-release
chmod 755 enderecify-release
PORT=8080 ./enderecify-release start

