# Base image, default node image
FROM node:10-slim

# Environment configuration
ENV GITBOOK_VERSION="3.2.3"

# Install gitbook
RUN npm install --global gitbook-cli \
	&& gitbook fetch ${GITBOOK_VERSION} \
  && npm install --global markdownlint-cli \
	&& npm cache clear --force \
        && apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
             #wget \
						 #curl \
						 #vim \
             #openssh-client \
             calibre \
             ttf-freefont \
  && mkdir -p /root/.ssh \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/*
