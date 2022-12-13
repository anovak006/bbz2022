#!/bin/bash
docker run --rm -it \
  -v $(pwd)/src:/src \
  -w="/src" \
  --user 1000:1000 \
  klakegg/hugo:0.107.0-ext-alpine \
  new site . -force
