# Cluster Builder Desktop
This packer configuration builds a CentOS7 desktop for creating and managing CaaS cluster VMware VMs using [cluster-builder](https://github.com:ids/cluster-builder).

The _Cluster Builder Desktop_ can be deployed directly to ESXi and uses nested VMware hypervisor to build and configure the _cluster-builder_ virtual machines from within the ESXi environment.

## Requirements

#### macOS / Linux / Windows

- [Packer 1.04+](https://www.packer.io/downloads.html)
- [VMware Fusion/Workstation](https://my.vmware.com/web/vmware/details?downloadGroup=WKST-1257-LX&productId=524&rPId=17068)

### Build Local VM and OVA Template

    $ packer build desktop.json

### Direct Remote ESXi Deployment
> First you must prep the ESXi servers using the ansible script **ansible/esxi-packer.yml**.  If you don't have ansible to do this, review the steps and execute them manually on the ESXi server(s).  The service.xml file is copied for the VNC service definition, which can alternately be included manually.

Make sure the **ansible/esxi-hosts** file is updated with the name(s) of the target ESXi server(s).

Eg.

    $ ansible-playbook -i ansible/esxi-hosts ansible/esxi-packer.yml


Then:

    $ packer build desktop-remote.json


## General Instructions
The initial login account credentials are:

    uid: root
    pwd: TempPass2017

    uid: admin
    pwd: admin

> **Change them immediately!** - you have been warned!

When the VM is first created and booted the user will need to:

* Install [VMware Workstation for Linux](https://my.vmware.com/web/vmware/details?downloadGroup=WKST-1257-LX&productId=524&rPId=17068) 
* Setup a workspace folder and fetch [cluster-builder](https://github.com:ids/cluster-builder)

> See **cluster-builder-setup.html** in the root of the home directory of the VM admin user for links and hints.

Everything else required should already be installed.

#### Note
VS Code has also been pre-installed for easy editing and viewing of the cluster builder source files:

    $ cd cluster-builder
    $ code .


