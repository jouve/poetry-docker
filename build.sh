#!/bin/bash -x

sudo nerdctl build -t jouve/poetry:$(sed -n -e 's/poetry==\([^ ;]\+\).*/\1/p' poetry.txt)-alpine$(sed -n -e '1s/FROM alpine://p' Dockerfile) .
