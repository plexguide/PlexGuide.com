FROM python:3.6-alpine3.7

# Arguments for build tracking
ARG BRANCH=
ARG COMMIT=

ENV \
  APP_DIR=plex_patrol \
  BRANCH=${BRANCH} \
  COMMIT=${COMMIT} \
  PLEX_PATROL_CONFIG=/config/settings.ini \
  PLEX_PATROL_LOGFILE=/config/status.log

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
ENTRYPOINT ["python", "patrol.py"]
