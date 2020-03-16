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

data "vsphere_datastore" "datastore-02" {
  name          = "VNX-LUN02-PROD"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore-01" {
  name          = "VNX-LUN01-PROD"
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

resource "vsphere_virtual_machine" "ANSIBLE-AWX" {
  name                  = "ANSIBLE-AWX.DHSNEXT.nl"
  resource_pool_id      = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id          = data.vsphere_datastore.datastore-02.id
  folder                = "ConfigManagement"

  num_cpus              = 8
  num_cores_per_socket  = 4
  memory                = 12288
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
}

resource "vsphere_virtual_machine" "DOCKER-01" {
  name                  = "DOCKER-01.DHSNEXT.nl"
  resource_pool_id      = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id          = data.vsphere_datastore.datastore-01.id
  folder                = "ConfigManagement"

  num_cpus              = 8
  num_cores_per_socket  = 4
  memory                = 12288
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
        host_name       = "DOCKER-01"
        domain          = "DHSNEXT.nl"
      }

      network_interface {
        ipv4_address    = "172.27.72.61"
        ipv4_netmask    = 24
      }

      ipv4_gateway      = "172.27.72.1"
      dns_server_list   = ["172.27.72.4"]
      dns_suffix_list   = ["DHSNEXT.nl"]
    }
  }
}

resource "vsphere_virtual_machine" "DOCKER-02" {
  name                  = "DOCKER-02.DHSNEXT.nl"
  resource_pool_id      = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id          = data.vsphere_datastore.datastore-02.id
  folder                = "ConfigManagement"

  num_cpus              = 8
  num_cores_per_socket  = 4
  memory                = 12288
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
        host_name       = "DOCKER-02"
        domain          = "DHSNEXT.nl"
      }

      network_interface {
        ipv4_address    = "172.27.72.62"
        ipv4_netmask    = 24
      }

      ipv4_gateway      = "172.27.72.1"
      dns_server_list   = ["172.27.72.4"]
      dns_suffix_list   = ["DHSNEXT.nl"]
    }
  }
}

resource "vsphere_virtual_machine" "DOCKER-03" {
  name                  = "DOCKER-03.DHSNEXT.nl"
  resource_pool_id      = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id          = data.vsphere_datastore.datastore-02.id
  folder                = "ConfigManagement"

  num_cpus              = 8
  num_cores_per_socket  = 4
  memory                = 12288
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
        host_name       = "DOCKER-03"
        domain          = "DHSNEXT.nl"
      }

      network_interface {
        ipv4_address    = "172.27.72.63"
        ipv4_netmask    = 24
      }

      ipv4_gateway      = "172.27.72.1"
      dns_server_list   = ["172.27.72.4"]
      dns_suffix_list   = ["DHSNEXT.nl"]
    }
  }
}

resource "vsphere_virtual_machine" "LB-01" {
  name                  = "LB-01.DHSNEXT.nl"
  resource_pool_id      = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id          = data.vsphere_datastore.datastore-01.id
  folder                = "ConfigManagement"

  num_cpus              = 2
  num_cores_per_socket  = 2
  memory                = 2048
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
        host_name       = "LB-01"
        domain          = "DHSNEXT.nl"
      }

      network_interface {
        ipv4_address    = "172.27.72.65"
        ipv4_netmask    = 24
      }

      ipv4_gateway      = "172.27.72.1"
      dns_server_list   = ["172.27.72.4"]
      dns_suffix_list   = ["DHSNEXT.nl"]
    }
  }
}

resource "vsphere_virtual_machine" "LB-02" {
  name                  = "LB-02.DHSNEXT.nl"
  resource_pool_id      = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id          = data.vsphere_datastore.datastore-02.id
  folder                = "ConfigManagement"

  num_cpus              = 2
  num_cores_per_socket  = 2
  memory                = 2048
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
        host_name       = "LB-02"
        domain          = "DHSNEXT.nl"
      }

      network_interface {
        ipv4_address    = "172.27.72.66"
        ipv4_netmask    = 24
      }

      ipv4_gateway      = "172.27.72.1"
      dns_server_list   = ["172.27.72.4"]
      dns_suffix_list   = ["DHSNEXT.nl"]
    }
  }
}

resource "vsphere_virtual_machine" "HOPHOP" {
  name                  = "HOPHOP.DHSNEXT.nl"
  depends_on            = [
                            vsphere_virtual_machine.ANSIBLE-AWX,
                            vsphere_virtual_machine.DOCKER-01,
                            vsphere_virtual_machine.DOCKER-02,
                            vsphere_virtual_machine.DOCKER-03,
                            vsphere_virtual_machine.LB-01,
                            vsphere_virtual_machine.LB-02
                          ]
  resource_pool_id      = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id          = data.vsphere_datastore.datastore-02.id
  folder                = "ConfigManagement"

  num_cpus              = 2
  num_cores_per_socket  = 2
  memory                = 2048
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
        host_name       = "HOPHOP"
        domain          = "DHSNEXT.nl"
      }

      network_interface {
        ipv4_address    = "172.27.72.69"
        ipv4_netmask    = 24
      }

      ipv4_gateway      = "172.27.72.1"
      dns_server_list   = ["172.27.72.4"]
      dns_suffix_list   = ["DHSNEXT.nl"]
    }
  }
  provisioner "remote-exec" {
    inline = [
      "mkdir ~/.ssh && curl https://gist.githubusercontent.com/MaartenMol/326668e09d73e4bd43c8e0b0dd22083b/raw/c07f870e79502efa9bd1e4f568d669cfccd32324/PublicKey > ~/.ssh/authorized_keys",
      "chmod 600 ~/.ssh/authorized_keys",
      "dnf install -y git ansible",
      "git clone https://github.com/MaartenMol/dhs-config.git /root/dhs-config",
      "export ANSIBLE_HOST_KEY_CHECKING=False",
      "cd /root/dhs-config/infrastructure/2.\\ Ansible/ && ansible-playbook -i inventory runbook.yml",
      "cd /root/dhs-config/infrastructure/2.\\ Ansible/ && ansible-playbook -i inventory runbook.yml"
    ]
    connection {
      type        = "ssh"
      host        = "172.27.72.69"
      user        = "root"
      password    = "P@ssword"
    }
  } 
}