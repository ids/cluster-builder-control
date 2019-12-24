# Cluster Builder Control

This packer configuration builds a CentOS 7.6 control station for creating and managing cluster VMware VMs using [cluster-builder](https://github.com/ids/cluster-builder) .

The _Cluster Builder Control_ virtual machine can be deployed directly to ESXi and uses nested VMware hypervisor to build and configure the _cluster-builder_ virtual machines from within the ESXi environment.

## Required Software

- [Packer 1.5+](https://www.packer.io/downloads.html)
- [VMware Fusion or Workstation](https://my.vmware.com/web/vmware/details?downloadGroup=WKST-1257-LX&productId=524&rPId=17068)

(All platforms)

### Windows Notes

- Packer must be in the PATH.  When you download packer there is just an executable which can be placed anywhere.

Eg. 

	C:\Packer\packer

Ensure that **C:\Packer\** is in the PATH.

- Also make sure that Windows Firewall is off, or allow the following:
	- VNC
	- SSH
	- HTTP

### Build Instructions for Local CentOS7 Control Station OVA Template

> Note that distribution __ISO__ files are kept in the __./iso__ folder.  If the specified iso does not exist, packer will attempt to download it from a supplied URL.  However, Packer will not re-use these downloads, and downloads every run, so it is best to download the __ISO__ manually and place it in the __./iso__ folder.

The current __cluster-builder-control__ station is built using the [CentOS-7-x86_64-Minimal-1908.iso](http://mirror.csclub.uwaterloo.ca/centos/7.7.1908/isos/x86_64/CentOS-7-x86_64-Minimal-1908.iso)

```
$ packer build cluster-builder-control.json
```

> Once the __OVA__ has been built it can be uploaded to ESXi/vSphere and provisioned accordingly.

## General Instructions
The initial login account credentials are:

    uid: root
    pwd: TempPass2017

    uid: admin
    pwd: admin

> **Change them immediately!** - you have been warned!

> You only need to login to GNOME once to setup VMware Workstation for Linux. See **cluster-builder-setup.html** in the root of the home directory of the VM admin user for links and hints.  It is also a handy way to setup the static IP address and hostname of the control station.  After that, and once _cluster-builder_ has been configured it can be used over SSH.

Upon first boot:

> Note that the admin account as been setup for passwordless access with the authorized_keys value set, but you must still change the passwords (and/or disable remote login).

* Change the root and admin passwords!
* Assign a static IP (optional).
* Install [VMware Workstation for Linux](https://my.vmware.com/web/vmware/details?downloadGroup=WKST-1257-LX&productId=524&rPId=17068) and ensure ovftool is in the path (if not you may need to download seperately)
* Setup a workspace folder and fetch [cluster-builder](https://github.com/ids/cluster-builder)

#### Note
VS Code has also been pre-installed for easy editing and viewing of the cluster builder source files:

```
$ cd cluster-builder
$ code .
```

### Direct Remote ESXi Deployment Instructions

> Note that this approach is not actively maintained and may require updating.

The __cluster builder control__ station can deploy directly to ESXi.  This can be handy if you are running a Windows workstation and/or want to centralize management of your clusters within the ESXi environment.

1. First you must ensure all your ESXi servers have their **/etc/ssh/keysroot** _authorized_keys_ set for passwordless access.
2. Prep the ESXi servers using the ansible script **ansible/esxi-packer.yml**.  If you don't have ansible to do this, review the steps and execute them manually on the ESXi server(s).  The service.xml file is copied for the VNC service definition, which can alternately be included manually.
3. Create or update the **cluster-builder-control-remote-options.json** file for packer that specifies the following:

Eg.

    {
      "remote_host": "esxi-5",
      "remote_datastore": "datastore5",
      "remote_cache_datastore": "datastore5",
      "remote_username": "root",
      "remote_password": "{{ user `remote_password`}}",
      "remote_private_key_file": "/Users/someone/.ssh/id_rsa",
      "vm_name": "cluster-builder-control"
    }


> Note: You must specify the remote password of the ESXi server as the ovftool does not use passwordless SSH.

If you do use ansible Make sure the **ansible/esxi-hosts** file is updated with the name(s) of the target ESXi server(s).

Eg.

    $ ansible-playbook -i ansible/esxi-hosts ansible/esxi-packer.yml


Then:

    $ packer build -var-file remote-options.json -var "remote_password=password" cluster-builder-control-remote.json

