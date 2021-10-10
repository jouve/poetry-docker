#!/bin/bash -x

if [ "$(basename "$(readlink -f "$(which docker)")")" != podman ]; then
  if ! test -w /var/run/docker.sock; then
    SUDO=sudo
  else
    SUDO=
  fi
fi

if docker container inspect cache_cache_1 &>/dev/null; then
  cache=--volumes-from=cache_cache_1
else
  cache=
fi

$SUDO docker run \
  $cache \
  --volume $PWD:/srv \
  --workdir /srv \
  jouve/poetry:1.1.10-alpine3.14.2 sh -x -c '
poetry lock
poetry export --without-hashes > poetry.txt
'
