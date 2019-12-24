#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo '>>> Updating Fedora'
dnf check-update -y

echo '>>> Install python3 and screen'
dnf install -y python3 python3-pip python3-devel screen 

echo '>>> Install build tools'
dnf install -y libxml2-dev libxslt-dev libz-dev gcc gcc-c++ make

echo
echo '>>> Installing Ansible'
pip3 install ansible

echo
echo '>>> Installing Taurus Load Testing Tool'
pip3 install bzt

