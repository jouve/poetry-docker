FROM alpine:3.14.2

RUN \
    set -e; \
    apk add --no-cache python3; \
    ln -s /usr/bin/python3 /usr/bin/python; \
    python3 -m venv /usr/share/poetry; \
    /usr/share/poetry/bin/pip install pip==21.2.4 wheel==0.37.0

COPY poetry.txt /usr/share/poetry/requirements.txt

RUN \
    set -e; \
    apk add --no-cache --virtual .build-deps \
        gcc \
        libffi-dev \
        musl-dev \
        python3-dev \
    ; \
    /usr/share/poetry/bin/pip install -r /usr/share/poetry/requirements.txt; \
    ln -s /usr/share/poetry/bin/poetry /usr/local/bin/poetry; \
    apk add --no-cache --virtual .run-deps python3 $( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/share/poetry \
        | tr ',' '\n' \
        | sed 's/^/so:/' \
        | sort -u \
        | grep -v libgcc_s \
    ); \
    apk del --no-cache --no-network .build-deps; \
    rm -rf /root/.cache
