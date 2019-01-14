#!/bin/bash -x
dig +short @$(dig +short NS aws-fr.com | head -n1) $1 | head -n1
dig +short $1 | head -n1
curl https://$1
