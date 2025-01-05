#!/bin/bash -x

set -e -x -o pipefail

docker build -t "jouve/poetry:$(sed -n -e "s/poetry==\([^ ;]\+\).*/\1/p" poetry.txt)" .
