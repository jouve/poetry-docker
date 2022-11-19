FROM alpine:3.16.3

RUN --mount=target=/requirements \
    set -e; \
    apk add --no-cache --virtual .build-deps \
        build-base \
        libffi-dev \
        python3-dev \
    ; \
    ln -s /usr/bin/python3 /usr/bin/python; \
    python3 -m venv /usr/share/poetry; \
    /usr/share/poetry/bin/pip install --no-cache-dir --requirement /requirements/pip.txt; \
    /usr/share/poetry/bin/pip install --no-cache-dir --requirement /requirements/poetry.txt; \
    ln -s /usr/share/poetry/bin/poetry /usr/local/bin/poetry; \
    apk add --no-cache --virtual .run-deps python3 $( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/share/poetry \
        | tr ',' '\n' \
        | sed 's/^/so:/' \
        | sort -u \
        | grep -v libgcc_s \
    ); \
    apk del --no-cache .build-deps
