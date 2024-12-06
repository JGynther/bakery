terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45.0"
    }
  }
}

variable "hcloud_token" {
  sensitive = true
}

provider "hcloud" {
  token = var.hcloud_token
}

data "hcloud_ssh_key" "default" {
  name = "default"
}

resource "hcloud_server" "k3s_server" {
  name        = "k3s-server"
  image       = "rocky-9"
  server_type = "cax21" # Arm64, 4 vCPU, 8 GiB RAM
  location    = "hel1"  # Helsinki
  ssh_keys    = [data.hcloud_ssh_key.default.id]

  # Automatically install K3s
  user_data = file("cloud-init.yaml")
}

output "ip" {
  value = hcloud_server.k3s_server.ipv4_address
}
