#!/bin/sh

# node/npm
#   TODO: personal install only- need to figure out system install
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
nvm install 14
