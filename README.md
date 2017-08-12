# Cluster Builder Desktop
This packer configuration builds a CentOS7 desktop for creating and managing CaaS cluster VMware VMs using [cluster-builder](https://github.com:ids/cluster-builder).

## Requirements

- Packer 1.04+
- VMware Fusion/Workstation

## Instructions

    $ packer build cluster-builder-desktop.json

The initial login account credentials are:

  uid: admin
  pwd: admin

When the VM is first created and booted from the OVA template the user will need to:

* install [VMware Workstation for Linux](https://my.vmware.com/web/vmware/details?downloadGroup=WKST-1257-LX&productId=524&rPId=17068) 
* setup a workspace folder and fetch [cluster-builder](https://github.com:ids/cluster-builder)

> See **cluster-builder-setup.html** in the root of the home directory for the default admin user.

Everything else required should already be installed.

> VS Code has been installed, to view the cluster builder source files type:

  $ code .

_(When in the cluster-builder folder)_
