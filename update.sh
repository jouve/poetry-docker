#!/bin/bash -x

docker run \
  --volume $PWD:/srv \
  --workdir /srv \
  jouve/poetry:$(sed -n -e 's/poetry==\([^ ;]\+\).*/\1/p' poetry.txt)-alpine$(sed -n -e '1s/FROM alpine://p' Dockerfile) sh -x -c '
poetry run pip install --upgrade pip setuptools wheel
poetry run pip freeze --all > pip.txt
poetry lock
poetry export --without-hashes > poetry.txt
'
