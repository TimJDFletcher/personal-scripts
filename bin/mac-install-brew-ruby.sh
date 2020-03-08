#!/bin/bash
version=2.6.2
brew remove ruby rbenv
brew install rbenv
eval "$(rbenv init -)"
rbenv install $version
rbenv rehash
rbenv global $version
