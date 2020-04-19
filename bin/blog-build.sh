#!/bin/bash -e
JEKYLL_VERSION=stable
docker pull jekyll/builder:$JEKYLL_VERSION
docker run --rm -it \
    --volume="$PWD/.gemcache:/usr/local/bundle" \
    --volume="$PWD:/srv/jekyll" \
    jekyll/builder:$JEKYLL_VERSION \
    jekyll build 
rsync -avPHS --delete \
    _site/ \
    co-lo.night-shade.org.uk:/data/blog/
