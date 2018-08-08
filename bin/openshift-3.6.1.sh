#!/bin/bash -e
PACKAGE=openshift-cli
VERSION=3.6.1
SHA=537d08de696bba4b5124e8818aba1e512fad49d6

brew install ${PACKAGE}
brew unlink ${PACKAGE}
cd "$(brew --repo homebrew/core)"
git checkout -b ${PACKAGE}-${VERSION} ${SHA}
HOMEBREW_NO_AUTO_UPDATE=1 brew install --ignore-dependencies ${PACKAGE}
brew pin ${PACKAGE}
git checkout master
git branch -d ${PACKAGE}-${VERSION}
brew list ${PACKAGE} --versions
brew switch ${PACKAGE} ${VERSION}
