#!/bin/bash -x

if [ "$(basename "$(readlink -f "$(which docker)")")" != podman ]; then
  if ! test -w /var/run/docker.sock; then
    SUDO=sudo
  else
    SUDO=
  fi
fi

if docker container inspect cache-cache-1 &>/dev/null; then
  cache=--volumes-from=cache-cache-1
else
  cache=
fi

$SUDO docker run \
  $cache \
  --volume $PWD:/srv \
  --workdir /srv \
  jouve/poetry:1.1.12-alpine3.15.0 sh -x -c '
poetry lock
poetry export --without-hashes > poetry.txt
'
