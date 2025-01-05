FROM python:3.13.1-bookworm AS build

SHELL [ "bash", "-e", "-o", "pipefail", "-c" ]

COPY pip.txt /requirements.txt
RUN python3 -m venv /opt/poetry; \
    /opt/poetry/bin/pip install --upgrade -r /requirements.txt

COPY poetry.txt /requirements.txt
RUN /opt/poetry/bin/pip install --upgrade -r /requirements.txt

FROM python:3.13.1-bookworm

SHELL [ "bash", "-e", "-o", "pipefail", "-c" ]

COPY --from=build /opt/poetry /opt/poetry
RUN ln -s /opt/poetry/bin/poetry /usr/local/bin
