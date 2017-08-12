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
pip install --upgrade

# Avoid bug in default python cryptography library
# [WARNING]: Optional dependency 'cryptography' raised an exception, falling back to 'Crypto'
echo '>>> Upgrading python cryptography library'
pip install --upgrade cryptography

echo
echo '>>> Installing Ansible'
pip install ansible

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
curl -o /home/admin/Setups/vscode.rpm https://az764295.vo.msecnd.net/stable/8b95971d8cccd3afd86b35d4a0e098c189294ff2/code-1.15.0-1502309602.el7.x86_64.rpm
yum install -y /home/admin/Setups/vscode.rpm

#echo
#echo '>>> Generating the admin SSH key for addition to operator github account...'
#mkdir -p /home/admin/.ssh
#chmod 700 /home/admin/.ssh
#chown admin:admin /home/admin/.ssh
#ssh-keygen -f /home/admin/.ssh/id_rsa -t rsa -N ''

#echo
#echo '***'
#echo '*** SSH public key: add this to your github SSH keys'
#cat /home/admin/.ssh/id_rsa.pub
#echo '***'

echo
echo '>>> Installing Gnome'
yum -y groups install "GNOME Desktop"
yum install -y openssh-clients rsync git vim mc tmux firefox

systemctl set-default graphical.target

echo
echo '>>> Improving CentOS Fonts'
yum -y install epel-release
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm

yum --enablerepo=nux-dextop install -y fontconfig-infinality cairo libXft freetype-infinality

cat > /home/admin/.fonts.conf << EOF
  <?xml version="1.0"?>
  <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
  <fontconfig>
    <match target="font">
    <edit mode="assign" name="hinting" >
      <bool>true</bool>
    </edit>
    </match>
    <match target="font" >
    <edit mode="assign" name="autohint" >
      <bool>true</bool>
    </edit>
    </match>
    <match target="font">
    <edit mode="assign" name="hintstyle" >
    <const>hintslight</const>
    </edit>
    </match>
    <match target="font">
    <edit mode="assign" name="rgba" >
      <const>rgb</const>
    </edit>
    </match>
    <match target="font">
    <edit mode="assign" name="antialias" >
      <bool>true</bool>
    </edit>
    </match>
    <match target="font">
      <edit mode="assign" name="lcdfilter">
      <const>lcddefault</const>
      </edit>
    </match>
  </fontconfig>
EOF

