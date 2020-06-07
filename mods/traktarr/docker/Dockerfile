FROM python:3.7-alpine3.10

# Arguments for build tracking
ARG BRANCH=
ARG COMMIT=

ENV \
  APP_DIR=traktarr \
  BRANCH=${BRANCH} \
  COMMIT=${COMMIT} \
  TRAKTARR_CONFIG=/config/config.json \
  TRAKTARR_CACHEFILE=/config/cache.db \
  TRAKTARR_LOGFILE=/config/traktarr.log

COPY . /${APP_DIR}

RUN \
  echo "** BRANCH: ${BRANCH} COMMIT: ${COMMIT} **" && \
  echo "** Upgrade all packages **" && \
  apk --no-cache -U upgrade && \
  echo "** Install PIP dependencies **" && \
  pip install --no-cache-dir --upgrade pip setuptools && \
  pip install --no-cache-dir --upgrade -r /${APP_DIR}/requirements.txt

# Change directory
WORKDIR /${APP_DIR}

# Config volume
VOLUME /config

# Entrypoint
ENTRYPOINT ["python", "traktarr.py"]
