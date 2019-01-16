# Base image, default python image
FROM python:slim

# Install awscli and ansible
RUN apt-get update \
  && apt-get install -y \
    python3 \
    python3-pip \
    python3-setuptools \
    groff \
    less \
    curl \
    vim \
  && pip3 install --upgrade pip \
  && pip3 --no-cache-dir install --upgrade \
    boto \
    botocore \
    boto3 \
    awscli \
    ansible \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/*
