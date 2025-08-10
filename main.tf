provider "vsphere" {
  user = var.vsphere_user                     #user vsphere
  password = var.vsphere_password             #mdp vsphere
  vsphere_server = var.vsphere_server         #@ du serveur vCenter

  allow_unverified_ssl = true                 #autorise connexion mm si le certif ssl n'est pas validé
} 

# Déclaration du datacenter
data "vsphere_datacenter" "dc" {
  name = var.datacenter
}


#Objet datastore ou sera stocké la vm
data "vsphere_datastore" "datastore" {
  name = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

#Cluster de calcul (CPU,RAM...)
data "vsphere_compute_cluster" "cluster" {
  name = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

#Réseau sur lequel la VM sera connecté
data "vsphere_network" "network" {
  name = var.network
  datacenter_id = data.vsphere_datacenter.dc.id
}

#Récupèrer un template existant pour cloner la vm
data "vsphere_virtual_machine" "template" {
  name = var.template
  datacenter_id = data.vsphere_datacenter.dc.id
}

#Créer la vm en clonant un template
resource "vsphere_virtual_machine" "vm" {
  name = var.vm_name
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id = data.vsphere_datastore.datastore.id

  num_cpus = 4 #unité
  memory = 2048
  
  tags = {
    owner = "hiba"
    # environment est volontairement manquant pour tester la règle
  }

  guest_id = data.vsphere_virtual_machine.template.guest_id


#Config de l'interface Réseau
network_interface {
  network_id = data.vsphere_network.network.id
  adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
}

#Config du disque
disk {
  label = "disk0" 
  size = data.vsphere_virtual_machine.template.disks[0].size
  eagerly_scrub = false
  thin_provisioned = true
}

#clonage de la vm à partir du template 
clone {
  template_uuid = data.vsphere_virtual_machine.template.id

  #Personnalisation du sys (nom,ip...)
  customize {
    linux_options{
      host_name = var.vm_name
      domain = "local"
    }
    network_interface{
      ipv4_address = var.ipv4_adress
      ipv4_netmask = 24
    }
    ipv4_gateway = var.ipv4_gateway
  }
}
}


