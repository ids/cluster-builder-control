#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo '>>> Updating Fedora'
dnf check-update -y

echo '>>> Installing python3 and ansible'
dnf install -y python3 python3-pip python3-devel screen libxml2-dev libxslt-dev libz-dev gcc gcc-c++ make 

echo
echo '>>> Installing Ansible'
pip3 install ansible

echo
echo '>>> Installing Taurus Load Testing Tool'
pip3 install bzt

echo
echo '>>> Installing Packer'
mkdir -p /home/admin/Setups
cd /home/admin/Setups
curl -o /home/admin/Setups/packer.zip https://releases.hashicorp.com/packer/1.5.1/packer_1.5.1_linux_amd64.zip
unzip /home/admin/Setups/packer.zip -d /home/admin/Setups/
cp /home/admin/Setups/packer /usr/local/bin 
rm /home/admin/Setups/packer
rm /home/admin/Setups/packer.zip

echo
echo '>>> Disable Firewalld'
systemctl stop firewalld
systemctl disable firewalld


#if [ -f /tmp/bg.jpg ]; then
#  echo "***"
#  echo "*** Overwriting Default Desktop Background"
#  cp /tmp/bg.jpg /usr/share/backgrounds/night.jpg
#  cp /tmp/bg.jpg /usr/share/backgrounds/day.jpg
#  cp /tmp/bg.jpg /usr/share/backgrounds/morning.jpg
#  cp /tmp/bg.jpg /usr/share/backgrounds/default.jpg
#else 
#  echo "***"
#  echo "*** No CDB Background Image!"
#fi 

echo
echo '>>> Installing VS Code'
rpm --import https://packages.microsoft.com/keys/microsoft.asc
dnf install -y code

echo '>>> Installing Latest Docker Version'
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf check-update -y
dnf install -y docker-ce
docker --version

echo '>>> Installing Open VMware Tools'
dnf install -y open-vm-tools
