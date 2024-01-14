# Web-App-DevOps-Project

Welcome to the Web App DevOps Project repo! This application allows you to efficiently manage and track orders for a potential business. It provides an intuitive user interface for viewing existing orders and adding new ones.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Technology Stack](#technology-stack)
- [Contributors](#contributors)
- [License](#license)

## Features

- **Order List:** View a comprehensive list of orders including details like date UUID, user ID, card number, store code, product code, product quantity, order date, and shipping date.
  
![Screenshot 2023-08-31 at 15 48 48](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/3a3bae88-9224-4755-bf62-567beb7bf692)

- **Pagination:** Easily navigate through multiple pages of orders using the built-in pagination feature.
  
![Screenshot 2023-08-31 at 15 49 08](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/d92a045d-b568-4695-b2b9-986874b4ed5a)

- **Add New Order:** Fill out a user-friendly form to add new orders to the system with necessary information.
  
![Screenshot 2023-08-31 at 15 49 26](https://github.com/maya-a-iuga/Web-App-DevOps-Project/assets/104773240/83236d79-6212-4fc3-afa3-3cee88354b1a)

- **Data Validation:** Ensure data accuracy and completeness with required fields, date restrictions, and card number validation.

- **Delivery Date Column:** There is the option to add an additional field to record the Delivery Date of an order. The feature is not currently enabled, however can be implemented by commiting the feature branch "feature/add-delivery-date" to the main branch.

## Getting Started

### Prerequisites

For the application to succesfully run, you need to install the following packages:

- flask (version 2.2.2)
- pyodbc (version 4.0.39)
- SQLAlchemy (version 2.0.21)
- werkzeug (version 2.2.3)

### Usage

To run the application, you simply need to run the `app.py` script in this repository. Once the application starts you should be able to access it locally at `http://127.0.0.1:5000`. Here you will be meet with the following two pages:

1. **Order List Page:** Navigate to the "Order List" page to view all existing orders. Use the pagination controls to navigate between pages.

2. **Add New Order Page:** Click on the "Add New Order" tab to access the order form. Complete all required fields and ensure that your entries meet the specified criteria.

## Technology Stack

- **Backend:** Flask is used to build the backend of the application, handling routing, data processing, and interactions with the database.

- **Frontend:** The user interface is designed using HTML, CSS, and JavaScript to ensure a smooth and intuitive user experience.

- **Database:** The application employs an Azure SQL Database as its database system to store order-related data.


## Terraform Configuration

The Terraform project will serve as the foundation for provisioning an Azure Kubernetes Service (AKS) cluster using infrastructure as code (IaC)

The project is organized into two Terraform modules: one for provisioning the necessary Azure Networking Services for an AKS cluster `networking-module`, and one for provisioning the Kubernetes cluster itself `aks-cluster-module`.

### Defining Networking Services with IaC

There are 3 required files for the configuration of the Terraform Networking Module: `main.tf`, `variables.tf` and `outputs.tf`.

**`main.tf`**

The networking module's main.tf configuration file defines the essential networking resources for an AKS cluster. This includes creating an Azure Resource Group, a VNet, two subnets (for the control plane and worker nodes) and a Network Security Group (NSG). The resources are named as follows:

- Azure Resource Group: referencing the resource_group_name variable in the `variables.tf` file
- Virtual Network (VNet): `aks-vnet`
- Control Plane Subnet: `control-plane-subnet`
- Worker Node Subnet: `worker-node-subnet`
- Network Security Group (NSG): `aks-nsg`

Within the NSG, there are two inbound rules defined: one to allow traffic to the kube-apiserver (named `kube-apiserver-rule`) and one to allow inbound SSH traffic (named `ssh-rule`). Both rules only allow inbound traffic from the public IP address.

**`variables.tf`**

This file defines the input variables for the module. These variables are a critical component of the Terraform project, allowing to configure and customize networking services based on specific requirements.

The following input variables are defined:

- A `resource_group_name` variable that will represent the name of the Azure Resource Group where the networking resources will be deployed in. The variable is of type `string` and has a default value.
- A `location` variable that specifies the Azure region where the networking resources will be deployed to. The variable is of type string and has a default value `UK South`.
- A `vnet_address_space` variable that specifies the address space for the Virtual Network (VNet) that is created in the main configuration file of this module. The variable is of type `list(string)` and has a default value `["10.0.0.0/16"]`.

**`outputs.tf`**

This file will define the output variables of the module. Output variables enable access to and utilize information from the networking module. Specifically these variables will be used to provision the networking services used when the AKS cluster is provisioned.


The following output variables are defined:

- A `vnet_id` variable that will store the ID of the previously created VNet. This will be used within the cluster module to connect the cluster to the defined VNet.
- A `control_plane_subnet_id` variable that will hold the ID of the control plane subnet within the VNet. This will be used to specify the subnet where the control plane components of the AKS cluster will be deployed to.
- A `worker_node_subnet_id` variable that will store the ID of the worker node subnet within the VNet. This will be used to specify the subnet where the worker nodes of the AKS cluster will be deployed to.
- A `networking_resource_group_name` variable that will provide the name of the Azure Resource Group where the networking resources were provisioned in. This will be used to ensure the cluster module resources are provisioned within the same resource group.
- A `aks_nsg_id` variable that will store the ID of the Network Security Group (NSG). This will be used to associate the NSG with the AKS cluster for security rule enforcement and traffic filtering.


### Defining an AKS Cluster with IaC

There are 3 required files for the configuration of the Terraform AKS Cluster: `main.tf`, `variables.tf` and `outputs.tf`.

**`main.tf`**

The AKS Cluster's main.tf configuration file defines the necessary Azure resources for provisioning an AKS cluster. This includes creating the AKS cluster, specifying the node pool and the service principal.

**`variables.tf`**

This file defines the input variables for the module. These variables  allow you to customize various aspects of the AKS cluster.

The following input variables are defined:

- A `aks_cluster_name` variable that represents the name of the AKS cluster you wish to create
- A `cluster_location` variable that specifies the Azure region where the AKS cluster will be deployed to
- A `dns_prefix` variable that defines the DNS prefix of cluster
- A `kubernetes_version` variable that specifies which Kubernetes version the cluster will use
- A `service_principal_client_id` variable that provides the Client ID for the service principal associated with the cluster
- A `service_principal_secret variable` that supplies the Client Secret for the service principal

Additionally, the output variables from the networking module are taken as input variables for this module:

- The `resource_group_name` variable
- The `vnet_id` variable
- The `control_plane_subnet_id` variable
- The `worker_node_subnet_id` variable

**`outputs.tf`**

This file will define the output variables of this module. These will capture essential information about the provisioned AKS cluster.

The following output variables are defined:

- A `aks_cluster_name` variable that will store the name of the provisioned cluster
- A `aks_cluster_id` variable that will store the ID of the cluster
- A `aks_kubeconfig` variable that will capture the Kubernetes configuration file of the cluster. This file is essential for interacting with and managing the AKS cluster using `kubectl`.

## Creating the AKS Cluster with IaC

Having configured the networking module and the aks cluster module, it now needs to be brought together to create the AKS Cluster with IaC.

**`main.tf` and `variables.tf`**

In the `main.tf` configuration file in the base directory of the project we define the Azure provider block to enable authentication to Azure using service principal credentials. The input variables for the client_id and client_secret arguments are defined in a `variables.tf` file, and then equivalent environment variables are created to store the values without exposing credentials.

## Integration

### Networking Module

After provisioning the provider block it's time to integrate the networking module in the project's main configuration file. This integration will ensure that the networking resources previously defined in their respective module are included, and therefore accessible in the main project.

The networking module is called with the following variables:

- `resource_group_name`
- `location` set to UK South
- `vnet_address_space` set to ["10.0.0.0/16"]

### Cluster Module

Integrating the cluster module in the main project configuration file connects the AKS cluster specifications to the main project, as well as allowing to provision the cluster within the previously defined networking infrastructure.

The cluster module is called with variables: 

- Set `cluster_name` to "terraform-aks-cluster"
- Set `location` to an Azure region that is geographically close to you to improve latency (e.g."UK South")
- Set `dns_prefix` to "myaks-project"
- Set `kubernetes_version` to a Kubernetes version supported by AKS, such as "1.26.6"
- Set `service_principal_client_id` and `service_principal_secret` to service principal credentials
- We use variables referencing the output variables from the networking module for the other input variables required by the cluster module such as: `resource_group_name`, `vnet_id`, `control_plane_subnet_id`, `worker_node_subnet_id` and `aks_nsg_id`

Following these steps, we use `terraform init` and `terraform apply` to initialise the terraform project.

## Kubernetes Deployment to AKS

### Deployment and Service Manifests

**Deployment**

We created a Kubernetes manifest file, named application-manifest.yaml. Inside this file the necessary Deployment resource is defined, which will help deploy the containerized web application onto the Terraform-provisioned AKS cluster. The manifest includes the following:

- A Deployment named `flask-app-deployment` that acts as a central reference for managing the containerized application.
- The application should concurrently run on two `replicas` within the AKS cluster, allowing for scalability and high availability
- The label `app: flask-app`. This uniquely identifies the application and will allow Kubernetes to identify which pods the Deployment should manage.
- This label in the metadata section is used to mark the pods created by the Deployment, establishing a clear connection between the pods and the application being managed.
- The manifest is directed to the specific container and image which is hosted on Docker Hub
- Port 5000 is exposed for communication within the AKS cluster. This port servers as the gateway for accessing the application's user interface, as defined in the application code
- The Rolling Updates deployment strategy, facilitating seamless application updates.
- Ensuring that, during updates, a maximum of one pod deploys while one pod becomes temporarily unavailable, maintaining application availability.

**Service**

The Kubernetes Service manifest is extended to facilitate internal communication within the AKS cluster. This manifest achieves the following key objectives:

- A service named `flask-app-service` acts as a reference for routing internal communication
- The selector matches the labels (`app: flask-app`) of the previously defined pods in the Deployment manifest. This alignment guarantees that the traffic is efficiently directed to the appropriate pods, maintaining seamless internal communication within the AKS cluster.
- Configure the service to use TCP protocol on `port 80` for internal communication within the cluster. The targetPort should be set to `5000`, which corresponds to the port exposed by your container.
- Set the service type to `ClusterIP`, designating it as an internal service within the AKS cluster

### Deployment Strategy

We have chose the **Rolling Updates* strategy. The reason is that the strategy allows for continuous updates with minimal downtime. This is essential as the application is constantly in use and not ideal if downtime is excessive. It allows for gradual replacement which again is ideal for improvements. The application is always available to users during updates. Kubernetes will automatically perform health checks on the deployment.

### Testing and Validation

The application was tested using the port-forwarding process by making the application available on the port 5000. The application was then run and all features were tested to ensure that the application has full functionality in the deployment environment.

### Internal Distribution

To proceed with distributing the application internally, we would go forward with the Autoscaling with Horizontal Pod Autoscaler (HPA) method. This method automatically adjusts the number of active pods based on CPU or memory usage whcih is ideal in reducing costs whilst still enabling full functionality. For external access, the ingress controller can be used to route external traffic to the cluster to enable access to the application.

## Contributors 

- [Maya Iuga]([https://github.com/yourusername](https://github.com/maya-a-iuga))

## License

This project is licensed under the MIT License. For more details, refer to the [LICENSE](LICENSE) file.
