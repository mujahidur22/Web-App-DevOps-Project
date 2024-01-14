variable "aks_cluster_name" {
    description = "The name of the AKS cluster to be created."
    type        = string
}

variable "cluster_location" {
    description = "The Azure region where the AKS cluster will be deployed to"
    type        = string
}

variable "dns_prefix" {
    description = "Defines the DNS prefix of cluster"
    type        = string
}

variable "kubernetes_version" {
    description = "Specifies which Kubernetes version the cluster will use"
    type        = string
}

variable "service_principal_client_id" {
    description = "Provides the Client ID for the service principal associated with the cluster"
    type        = string
}

variable "service_principal_client_secret" {
    description = "Supplies the Client Secret for the service principal"
    type        = string
}

variable "resource_group_name" {
    description = "Name of the Azure Resource Group for networking resources."
    type        = string
}

variable "vnet_id" {
    description = "ID of the Virtual Network (VNet)."
    type        = string
}

variable "control_plane_subnet_id" {
    description = "ID of the control plane subnet."
    type        = string
}

variable "worker_node_subnet_id" {
    description = "ID of the worker node subnet."
    type        = string
}

variable "aks_nsg_id" {
  description = "ID of the Network Security Group (NSG) for AKS."
  type        = string
}