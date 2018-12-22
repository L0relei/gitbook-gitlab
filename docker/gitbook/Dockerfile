# Base image, default node image
FROM node:10-slim

# Environment configuration
ENV GITBOOK_VERSION="3.2.3"

# Install gitbook
RUN npm install --global gitbook-cli \
	&& gitbook fetch ${GITBOOK_VERSION} \
	&& npm cache clear --force \
        && apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
             wget \
             openssh-client \
             cabextract \
             calibre \
             fonts-liberation \
  && mkdir -p /root/.ssh \
  && wget https://www.freedesktop.org/software/fontconfig/webfonts/webfonts.tar.gz \
	&& tar -xzf webfonts.tar.gz \
	&& cd msfonts/ \
	&& cabextract *.exe \
	&& cp *.ttf *.TTF ~/.local/share/fonts/ \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/*
