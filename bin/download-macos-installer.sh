#!/usr/bin/env bash
VERSION=26.0
VOLUME="/Volumes/Install macOS Sequoia"

softwareupdate --list-full-installers
softwareupdate --fetch-full-installer --full-installer-version ${VERSION}
sudo /Applications/Install\ macOS\ Tahoe.app/Contents/Resources/createinstallmedia --volume "${VOLUME}"
