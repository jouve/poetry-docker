FROM alpine:3.15.0

COPY poetry.txt /usr/share/poetry/requirements.txt

RUN set -e; \
    apk add --no-cache --virtual .build-deps \
        build-base \
        libffi-dev \
        python3-dev \
    ; \
    ln -s /usr/bin/python3 /usr/bin/python; \
    python3 -m venv /usr/share/poetry; \
    /usr/share/poetry/bin/pip install --no-cache-dir pip==21.3.1 setuptools==59.4.0 wheel==0.37.0; \
    /usr/share/poetry/bin/pip install --no-cache-dir --requirement /usr/share/poetry/requirements.txt; \
    ln -s /usr/share/poetry/bin/poetry /usr/local/bin/poetry; \
    apk add --no-cache --virtual .run-deps python3 $( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/share/poetry \
        | tr ',' '\n' \
        | sed 's/^/so:/' \
        | sort -u \
        | grep -v libgcc_s \
    ); \
    apk del --no-cache .build-deps; \
    rm /tmp/*
