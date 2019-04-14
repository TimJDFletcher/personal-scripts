#!/bin/bash -e
OS=$(uname -s)
ARCH=$(uname -m)
TEMP=$(mktemp /tmp/docker-compose.XXXXXX)
DEST=/usr/local/bin/docker-compose

COMPOSE_VERSION=$(git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oP "[0-9]+\.[0-9][0-9]+\.[0-9]+$" | tail -n 1)
COMPOSE_SHA256=$(curl -s -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-${OS}-${ARCH}.sha256 | awk '{print $1}')

checklocal()
{
    if [ -h ${DEST}  ] ; then
        CURRENT_VERSION=$(readlink ${DEST} | awk 'BEGIN {FS="-"} {print $NF}')
    elif [ -f ${DEST} ] ; then
        echo $DEST is a file and should be a symlink, exiting for safety
        exit 1
    fi

    if [ x$COMPOSE_VERSION == x$CURRENT_VERSION ] ; then
        echo $COMPOSE_VERSION already installed in $DEST, checking SHA256 sum
        if ! echo "$COMPOSE_SHA256  $DEST" | shasum -a 256 -s -c - ; then
            echo Checksum of $DEST does not match, redownloading
        else
            echo $COMPOSE_VERSION already installed and matches the upstream checksum, exiting
            exit 0
        fi
    fi
}

install()
{
echo Installing $COMPOSE_VERSION to $DEST
curl --silent \
    --location https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-${OS}-${ARCH} \
    --output $TEMP

echo "$COMPOSE_SHA256  $TEMP" | shasum -a 256 -s -c - 

sudo cp $TEMP ${DEST}-${COMPOSE_VERSION}
sudo chmod 755 ${DEST}-${COMPOSE_VERSION}
sudo ln -fs ${DEST}-${COMPOSE_VERSION} ${DEST}

sudo curl --silent \
    --location https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose \
    --output /etc/bash_completion.d/docker-compose
rm $TEMP
}

checklocal
install


