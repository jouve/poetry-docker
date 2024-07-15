#!/bin/bash

set -e -o pipefail

git tag "$(sed -n -e 's/poetry==\([^ ]\+\).*/\1/p' poetry.txt)-alpine$(sed -n -e 's/FROM alpine:\(.*\)/\1/p' Dockerfile)"
