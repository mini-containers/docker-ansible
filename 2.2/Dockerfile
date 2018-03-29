# Latest Python 2.x using latest Alpine 3.7
FROM python:2-alpine3.7

# default playbook directory
WORKDIR /data

ENV ANSIBLE_VERSION 2.2.1

# install general runtime dependencies
RUN set -ex \
        && apk add --no-cache \
                openssh-client \
                openssl

# 1. install build dependencies, then pip ansible.
# 2. detect any compiled extension that requires runtime dependencies.
# (copied from official Docker's Python image)
RUN set -ex \
        && apk add --no-cache --virtual .build-deps \
                gcc \
                libffi-dev \
                libressl-dev \
                linux-headers \
                make \
                musl-dev \
        && pip install --upgrade --no-cache-dir \
                ansible==$ANSIBLE_VERSION \
                passlib \
        && runDeps="$( \
                scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
                        | tr ',' '\n' \
                        | sort -u \
                        | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
        )" \
        && apk add --virtual .ansible-rundeps $runDeps \
        && apk del .build-deps

CMD ["ansible-playbook", "--version"]
