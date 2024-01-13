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
    client_id       = var.client_id
    client_secret   = var.client_secret
    subscription_id = "bd8fb8ff-0e7a-4bea-88c2-1a1311814533"
    tenant_id       = "47d4542c-f112-47f4-92c7-a838d8a5e8ef"
    skip_provider_registration = "true"
}

module "networking" {
    source = "./networking-module"
    resource_group_name = "networking-resource-group"
    location           = "UK South"
    vnet_address_space = ["10.0.0.0/16"]
}

module "aks_cluster" {
    source = "./aks-cluster-module"
    aks_cluster_name           = "terraform-aks-cluster"
    cluster_location           = "UK South"
    dns_prefix                 = "myaks-project"
    kubernetes_version         = "1.26.6"
    service_principal_client_id       = "service-principal"
    service_principal_client_secret   = "dff3fcec-6b58-4035-9f2b-385e242e0caa"
    resource_group_name         = module.networking.networking_resource_group_name
    vnet_id                     = module.networking.vnet_id
    control_plane_subnet_id     = module.networking.control_plane_subnet_id
    worker_node_subnet_id       = module.networking.worker_node_subnet_id
    aks_nsg_id                  = module.networking.aks_nsg_id
}