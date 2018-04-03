#!/bin/bash -e
TOOL=${1:-packer}

OS=$(uname -s | tr [A-Z] [a-z])
ARCH=$(uname -m | sed -e s/x86_64/amd64/g )
TEMP=$(mktemp -d /tmp/${TOOL}.XXXXXX)
DEST=/usr/local/bin/${TOOL}
KEY=51852D87348FFC4C
VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/${TOOL} | jq -r -M '.current_version')
BASE_URL=https://releases.hashicorp.com/${TOOL}/${VERSION}

checklocal()
{
    if [ -h ${DEST}  ] ; then
        CURRENT_VERSION=$(readlink ${DEST} | awk 'BEGIN {FS="-"} {print $NF}')
    elif [ -f ${DEST} ] ; then
        echo $DEST is a file and should be a symlink, exiting for safety
        exit 1
    fi
    if [ x$CURRENT_VERSION == x$VERSION ] ; then
        echo $VERSION already installed in $DEST
        exit 0
    fi
}

install()
{
    echo Installing $VERSION of $TOOL to $DEST

    for file in ${TOOL}_${VERSION}_${OS}_${ARCH}.zip ${TOOL}_${VERSION}_SHA256SUMS ${TOOL}_${VERSION}_SHA256SUMS.sig ; do
        curl --silent --location ${BASE_URL}/${file} --output ${TEMP}/${file}
    done

    gpg --recv-keys ${KEY}
    gpg --verify ${TEMP}/${TOOL}_${VERSION}_SHA256SUMS.sig ${TEMP}/${TOOL}_${VERSION}_SHA256SUMS

    cd $TEMP
    sha256sum --status --ignore-missing --check ${TEMP}/${TOOL}_${VERSION}_SHA256SUMS
    unzip ${TOOL}_${VERSION}_${OS}_${ARCH}.zip
    cd -

    sudo cp ${TEMP}/${TOOL} ${DEST}-${VERSION}
    sudo chmod 755 ${DEST}-${VERSION}
    sudo ln -fs ${DEST}-${VERSION} ${DEST}

    rm -rf ${TEMP}
}

checklocal
install


