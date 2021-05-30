FROM alpine:3.13.5

RUN \
    set -e; \
    apk add --no-cache python3; \
    python3 -m venv /usr/share/poetry

COPY poetry.txt /usr/share/poetry/requirements.txt

RUN \
    set -e; \
    apk add --no-cache --virtual .build-deps \
        cargo \
        gcc \
        libffi-dev \
        musl-dev \
        openssl-dev \
        python3-dev \
    ; \
    /usr/share/poetry/bin/pip install -r /usr/share/poetry/requirements.txt; \
    ln -s /usr/share/poetry/bin/poetry /usr/local/bin/poetry; \
    apk add --no-network --virtual .run-deps python3 $( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/share/poetry \
        | tr ',' '\n' \
        | sed 's/^/so:/' \
        | sort -u \
    ); \
    apk del --no-cache --no-network .build-deps; \
    rm -rf /root/.cache /root/.cargo
