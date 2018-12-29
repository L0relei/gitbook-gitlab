#!/bin/bash

markdownlint -V
markdownlint -c markdownlint.json README.md
markdownlint -c markdownlint.json content/*.md
