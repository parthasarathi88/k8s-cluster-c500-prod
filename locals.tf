locals {
  ssh_user     = data.vault_generic_secret.ssh_creds.data["user"]
  ssh_password = data.vault_generic_secret.ssh_creds.data["password"]
}

# Base configuration for all nodes
# Define node configurations
locals {
  nodes = {
    c500k8sn1 = {
      ip_priv    = "192.168.10.141/24",
      ip_pub     = "192.168.1.141/24",
      datastore  = data.vsphere_datastore.az1-ssd-datastore.id,
      pool       = data.vsphere_resource_pool.pool1.id
    },
    c500k8sn2 = {
      ip_priv    = "192.168.10.142/24",
      ip_pub     = "192.168.1.142/24",
      datastore  = data.vsphere_datastore.az2-ssd-datastore.id,
      pool       = data.vsphere_resource_pool.pool2.id
    },
    c500k8sn3 = {
      ip_priv    = "192.168.10.145/24",
      ip_pub     = "192.168.1.145/24",
      datastore  = data.vsphere_datastore.az3-ssd-datastore.id,
      pool       = data.vsphere_resource_pool.pool3.id
    }
  }
}