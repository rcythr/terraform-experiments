#!/usr/bin/env bash

set -e

if [[ ! -d .gen ]]; then
  mkdir .gen
fi

if [[ ! -f .gen/id_rsa ]]; then
  ssh-keygen -f .gen/id_rsa -t rsa -N ''
fi
