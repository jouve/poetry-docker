#!/bin/bash -x

sudo nerdctl run \
  --volume $PWD:/srv \
  --workdir /srv \
  jouve/poetry:1.4.1-alpine3.17.3 sh -x -c '
poetry run pip install --upgrade pip setuptools wheel
poetry run pip freeze --all > pip.txt
poetry lock
poetry export --without-hashes > poetry.txt
'
