#!/bin/bash
VERSION="stable-2.2"

sudo apt-get install python-pip git build-essential python-dev python-virtualenv python-setuptools libssl-dev libffi-dev

# Create a python virtual env
if [ ! -d ${HOME}/ansible-${VERSION} ] ; then
    virtualenv ansible-${VERSION}
fi

# Activate virtualenv
source ${HOME}/ansible-${VERSION}/bin/activate

# Upgrade pip first
pip install --upgrade pip
pip install --upgrade setuptools

# Install additional python packages with pip
pip install --upgrade boto3 boto markupsafe aws awscli

# Upgrade all python packages with shell tricks
pip list | awk '{print $1}' | xargs pip install -U

# Upgrade / install ansible
pip install -U git+git://github.com/ansible/ansible.git@$VERSION

echo To enter the new python venv call the following from the bash shell
echo source ${HOME}/ansible-${VERSION}/bin/activate
