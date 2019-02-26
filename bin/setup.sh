#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo '>>> Updating'
sudo yum makecache fast

echo '>>> Installing yum-utils'
yum install -y yum-utils unzip 

# Add the EPEL repository, and install Ansible.
echo '>>> Adding EPEL yum repo'
yum-config-manager --add-repo=https://dl.fedoraproject.org/pub/epel/7/x86_64/
curl --fail --location --silent --show-error --verbose -o /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

echo '>>> Cleaning yum cache'
yum clean all

echo
echo '>>> Installing Gnome'
yum -y groups install "GNOME Desktop"
yum install -y openssh-clients rsync git vim mc tmux firefox xrdp screen

systemctl set-default graphical.target

echo '>>> Installing pip (and dependencies)'
yum install -y python-devel libffi-devel openssl-devel gcc python-pip redhat-rpm-config

echo
echo '>>> Installing Ansible'
pip install ansible

echo
echo '>>> Installing Taurus Load Testing Tool'
pip install psutil
pip install bzt

echo '>>> Upgrading pip'
pip install --upgrade pip

# Avoid bug in default python cryptography library
# [WARNING]: Optional dependency 'cryptography' raised an exception, falling back to 'Crypto'
echo '>>> Upgrading python cryptography library'
pip install --upgrade cryptography

echo
echo '>>> Installing Packer'
mkdir -p /home/admin/Setups
cd /home/admin/Setups
curl -o /home/admin/Setups/packer.zip https://releases.hashicorp.com/packer/1.3.4/packer_1.3.4_linux_amd64.zip
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