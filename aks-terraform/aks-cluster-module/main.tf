terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
    features {}
    client_id       = ""
    client_secret   = ""
    subscription_id = "bd8fb8ff-0e7a-4bea-88c2-1a1311814533"
    tenant_id       = "47d4542c-f112-47f4-92c7-a838d8a5e8ef"
    skip_provider_registration = "true"
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.aks_cluster_name
  location            = var.cluster_location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
    enable_auto_scaling = true
    min_count = 1
    max_count = 3
  }

  service_principal {
    client_id     = var.service_principal_client_id
    client_secret = var.service_principal_client_secret
  }
}