#!/bin/bash

set -e -o pipefail

git tag "$(sed -n -e 's/poetry==\([^ ]\+\).*/\1/p' poetry.txt)"
