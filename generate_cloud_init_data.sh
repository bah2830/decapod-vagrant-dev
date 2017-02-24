#!/bin/sh

# Edit theset varaibles for your setup
DECAPOD_API_ENDPOINT=http://10.10.10.10:9999
DECAPOD_API_TOKEN=26758c32-3421-4f3d-9603-e4b5337e7ecc

docker run --rm \
  -e DECAPOD_API_ENDPOINT=$DECAPOD_API_ENDPOINT \
  -e DECAPOD_API_TOKEN=$DECAPOD_API_TOKEN \
  -v $(PWD):/data \
  bah2830/decapod_cli