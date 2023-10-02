FROM alpine:3.18.4

RUN --mount=target=/requirements \
    set -e; \
    apk add --no-cache --virtual .build-deps \
        build-base \
        libffi-dev \
        python3-dev \
    ; \
    python3 -m venv /usr/share/poetry; \
    /usr/share/poetry/bin/pip install --no-cache-dir --requirement /requirements/pip.txt; \
    /usr/share/poetry/bin/pip install --no-cache-dir --requirement /requirements/poetry.txt; \
    ln -s /usr/share/poetry/bin/poetry /usr/local/bin/poetry; \
    apk add --no-cache --virtual .run-deps python3 $( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
        | tr ',' '\n' \
        | sort -u \
        | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    ); \
    apk del --no-cache .build-deps
