#!/bin/sh

# Remove old releases
rm -rf _build/*

# Build the image
docker build --rm -t lofter-build -f Dockerfile.build . --no-cache

# Run the container
docker run -it --rm --name lofter-build -v $(pwd)/_build/prod:/opt/app/_build/prod lofter-build
