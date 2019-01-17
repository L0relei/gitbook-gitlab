#!/bin/bash

# Gitlab runner installation
PROJECT_REGISTRATION_TOKEN="SpcLK-kDo_XCUos6fU3Y"
apt-get update && apt-get -y upgrade
apt-get -y install curl
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
apt-get -y install gitlab-runner
gitlab-runner register \
  --non-interactive \
  --url "https://gitlab.com/" \
  --registration-token "$PROJECT_REGISTRATION_TOKEN" \
  --executor "docker" \
  --docker-image alpine:3 \
  --description "AWS docker-runner" \
  --tag-list "docker,aws" \
  --run-untagged \
  --locked="false"
gitlab-runner start

# Docker installation
apt-get -y install \
	apt-transport-https \
  ca-certificates \
  curl \
  gnupg2 \
  software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install docker-ce
