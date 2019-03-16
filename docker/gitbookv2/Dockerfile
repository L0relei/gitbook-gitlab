# Base image, default node image
FROM node:slim

# Environment configuration
ENV GITBOOK_VERSION="3.2.3"

# Install gitbook
RUN npm install --global gitbook-cli \
  && gitbook fetch ${GITBOOK_VERSION} \
  && npm install --global markdownlint-cli \
  && npm cache clear --force \
  && apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
    calibre \
    fonts-roboto \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/*
