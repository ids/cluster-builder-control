#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Instructions from https://flatpacklinux.com/2016/05/27/install-ansible-2-1-on-rhelcentos-7-with-pip/

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

echo '>>> Installing pip (and dependencies)'
yum install -y python-devel libffi-devel openssl-devel gcc python-pip redhat-rpm-config

echo '>>> Upgrading pip'
pip install --upgrade pip

# Avoid bug in default python cryptography library
# [WARNING]: Optional dependency 'cryptography' raised an exception, falling back to 'Crypto'
echo '>>> Upgrading python cryptography library'
pip install --upgrade cryptography

# Fix because Python is pure crap - kill it.
#pip uninstall urllib3

echo
echo '>>> Installing Ansible'
pip install ansible

echo
echo '>>> Installing Taurus Load Testing Tool'
pip install psutil
pip install bzt

echo
echo '>>> Installing Packer'
mkdir -p /home/admin/Setups
cd /home/admin/Setups
curl -o /home/admin/Setups/packer.zip https://releases.hashicorp.com/packer/1.0.4/packer_1.0.4_linux_amd64.zip?_ga=2.92008604.763705853.1502549016-1461564689.1499739058
unzip /home/admin/Setups/packer.zip -d /home/admin/Setups/
cp /home/admin/Setups/packer /usr/local/bin 
rm /home/admin/Setups/packer
rm /home/admin/Setups/packer.zip

echo
echo '>>> Installing VS Code'
cd /home/admin/Setups
curl -o /home/admin/Setups/vscode.rpm https://az764295.vo.msecnd.net/stable/929bacba01ef658b873545e26034d1a8067445e9/code-1.18.1-1510857496.el7.x86_64.rpm
yum install -y /home/admin/Setups/vscode.rpm

echo
echo '>>> Disable Firewalld'
systemctl stop firewalld
systemctl disable firewalld

echo
echo '>>> Installing Gnome'
#yum -y groups install "GNOME Desktop"
yum group list
yum groupinstall 'X Window System' 'GNOME'
yum install -y openssh-clients rsync git vim mc tmux firefox xrdp

systemctl set-default graphical.target

echo
echo '>>> Improving CentOS Fonts'
yum -y install epel-release
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm

yum --enablerepo=nux-dextop install -y fontconfig-infinality cairo libXft freetype-infinality google-droid-sans-mono-fonts

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