#!/bin/bash -e
JEKYLL_VERSION=3.8
docker run --rm -it \
    --volume="$PWD/.gemcache:/usr/local/bundle" \
    --volume="$PWD:/srv/jekyll" \
    jekyll/builder:$JEKYLL_VERSION \
    jekyll build 
rsync -avPHS --delete \
    _site/ \
    co-lo.night-shade.org.uk:/var/www/vhosts/blog/jekyll/
