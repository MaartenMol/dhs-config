variable "vsphere-password" {
  type = string
}

provider "vsphere" {
  user                  = "administrator@vsphere.local"
  password              = var.vsphere-password
  vsphere_server        = "dhsnext-vc-01.dhsnext.nl"
  allow_unverified_ssl  = true
}

data "vsphere_datacenter" "dc" {
  name = "Flightcase"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "DHSNEXT"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = "VNX-LUN02-PROD"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "FlightCase Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "CentOS8-Template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

variable "master_ips" {
  default = {
    "0" = "192.168.0.202"
    "1" = "192.168.0.203"
    "2" = "192.168.0.204"
    "3" = "192.168.0.205"
  }
}

variable "master_names" {
  default = {
    "0" = "MASTER-02"
    "1" = "MASTER-03"
    "2" = "MASTER-04"
    "3" = "MASTER-05"
  }
}

variable "worker_ips" {
  default = {
    "0" = "192.168.0.211"
    "1" = "192.168.0.212"
    "2" = "192.168.0.213"
    "3" = "192.168.0.214"
    "4" = "192.168.0.215"
  }
}

variable "worker_names" {
  default = {
    "0" = "WORKER-01"
    "1" = "WORKER-02"
    "2" = "WORKER-03"
    "3" = "WORKER-04"
    "4" = "WORKER-05"
  }
}

resource "vsphere_virtual_machine" "ANSIBLE-AWX" {
  name                  = "ANSIBLE-AWX.DHSNEXT.nl"
  resource_pool_id      = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id          = data.vsphere_datastore.datastore.id
  folder                = "ConfigManagement"

  num_cpus              = 4
  num_cores_per_socket  = 4
  memory                = 8192
  guest_id              = data.vsphere_virtual_machine.template.guest_id
  firmware              = data.vsphere_virtual_machine.template.firmware

  scsi_type             = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id          = data.vsphere_network.network.id
    adapter_type        = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label               = "disk0"
    size                = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub       = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned    = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid       = data.vsphere_virtual_machine.template.id
    linked_clone        = "false"

    customize {
      linux_options {
        host_name       = "ANSIBLE-AWX"
        domain          = "DHSNEXT.nl"
      }

      network_interface {
        ipv4_address    = "172.27.72.60"
        ipv4_netmask    = 24
      }

      ipv4_gateway      = "172.27.72.1"
      dns_server_list   = ["172.27.72.4"]
      dns_suffix_list   = ["DHSNEXT.nl"]
    }
  }
   provisioner "remote-exec" {
    inline = [
      "dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo && dnf list docker-ce",
      "dnf install docker-ce --nobest -y && systemctl disable firewalld && systemctl stop firewalld && systemctl enable docker && systemctl start docker",
      "dnf install curl nano -y && curl -L 'https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)' -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose",
      "dnf install python3 -y && dnf install python3-pip -y && dnf install epel-release -y && dnf install ansible -y",
      "dnf install git gcc gcc-c++ nodejs gettext device-mapper-persistent-data lvm2 bzip2 python3-pip -y",
      "alternatives --set python /usr/bin/python3 && pip3 install docker docker-compose ansible-tower-cli> /dev/null",
      "git clone https://github.com/ansible/awx.git ~/awx",
      "wget --timeout=1 --tries=3 https://raw.githubusercontent.com/MaartenMol/dhs-config/master/ansible-awx/inventory?token=AC4QWR7K7TI6QEB5J5QLRLC6MD64Q -O ~/inventory",
      "wget https://raw.githubusercontent.com/MaartenMol/dhs-awx/master/awx/ui/client/assets/favicon.ico -O ~/awx/awx/ui/client/assets/favicon.ico",
      "wget https://raw.githubusercontent.com/MaartenMol/dhs-awx/master/awx/ui/client/assets/logo-login.svg -O ~/awx/awx/ui/client/assets/logo-login.svg",
      "wget https://raw.githubusercontent.com/MaartenMol/dhs-awx/master/awx/ui/client/assets/logo-header.svg -O ~/awx/awx/ui/client/assets/logo-header.svg",
      "cd ~ && ansible-playbook -i inventory awx/installer/install.yml"
    ]
    connection {
      type        = "ssh"
      host        = "172.27.72.60"
      user        = "root"
      password    = "P@ssword"
    }
  }

}