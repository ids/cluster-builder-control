#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo '>>> Updating'
sudo yum makecache fast

echo '>>> Installing yum-utils'
yum install -y yum-utils unzip 

echo '>>> Installing open vmware tools'
yum install -y open-vm-tools

echo '>>> Installing Python3'
yum install -y python3 python3-pip python3-devel python-devel libxml2-dev libxslt-dev libz-dev gcc gcc-c++ make 

echo '>>> Install Ansible'
pip3 install ansible

echo
echo '>>> Installing Taurus Load Testing Tool'
pip3 install bzt

echo
echo '>>> Installing Gnome'
yum -y groups install "GNOME Desktop"
yum install -y openssh-clients rsync git vim mc tmux firefox xrdp screen

systemctl set-default graphical.target

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

# Fix because Python is pure crap - kill it.
#pip uninstall urllib3

if [ -f /tmp/bg.jpg ]; then
  echo "***"
  echo "*** Overwriting Default Desktop Background"
  cp /tmp/bg.jpg /usr/share/backgrounds/night.jpg
  cp /tmp/bg.jpg /usr/share/backgrounds/day.jpg
  cp /tmp/bg.jpg /usr/share/backgrounds/morning.jpg
  cp /tmp/bg.jpg /usr/share/backgrounds/default.jpg
else 
  echo "***"
  echo "*** No CDB Background Image!"
fi 

echo '>>> Installing Latest Docker Version'
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum makecache fast
yum install -y docker-ce
docker --version

echo ">>> Installing Google Chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
yum install -y ./google-chrome-stable_current_*.rpm

echo ">>> Installing Kubectl"
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubectl

echo '>>> Cleaning yum cache'
yum clean all

