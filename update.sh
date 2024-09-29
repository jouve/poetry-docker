#!/bin/bash

set -e -x -o pipefail

tmpf=$(mktemp)
latest=$(curl -fsSL https://raw.githubusercontent.com/docker-library/official-images/refs/heads/master/library/alpine | sed -n -e 's/Tags: \([^,]\+\), .*, latest/\1/p')
sed -i -e "s/FROM alpine:.*/FROM alpine:$latest/" Dockerfile
docker build --progress=plain --iidfile="$tmpf" .
docker run \
  --volume $PWD:/srv \
  --workdir /srv \
  "$(cat "$tmpf")" \
  sh -x -c '
poetry run pip install --upgrade pip setuptools wheel
poetry run pip freeze --all > pip.txt
poetry lock
poetry export --without-hashes > poetry.txt
'
latest=$(curl https://raw.githubusercontent.com/docker-library/official-images/master/library/alpine | sed -n -e 's/Tags: \([^,]\+\).*latest/\1/p')
sed -i -s "s/FROM alpine:.*/FROM alpine:$latest/" Dockerfile
docker build --progress=plain --iidfile="$tmpf" .
docker run \
  --volume $PWD:/srv \
  --workdir /srv \
  "$(cat "$tmpf")" \
  sh -x -c '
poetry run pip install --upgrade pip setuptools wheel
poetry run pip freeze --all > pip.txt
poetry lock
poetry export --without-hashes > poetry.txt
'
