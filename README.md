# Terraform code to deploy three-tier architecture on azure

## What is three-tier architecture?
Three-tier architecture is a well-established software application architecture that organizes applications into three logical and physical computing tiers: the presentation tier, or user interface; the application tier, where data is processed; and the data tier, where the data associated with the application is stored and managed.

## What is terraform?
Terraform is an open-source infrastructure as code software tool created by HashiCorp. Users define and provision data center infrastructure using a declarative configuration language known as HashiCorp Configuration Language, or optionally JSON.

## Installation
- [Terraform](https://www.terraform.io/downloads.html)

## Problem Statement

1. One virtual network tied in three subnets.
2. Each subnet will have two virtual machines(one windows , one linux).
3. Web Tier machines -> allow inbound traffic from internet only.
4. App can connect to database and database can connect to app but database cannot connect to web.
5. App can connect to Web but Web cannot connect to App.

_Note: Keep main and variable files different for each component_

## Solution

### The Terraform resources will consists of following structure

```
├── main.tf                   // The primary entrypoint for terraform resources.
├── vars.tf                   // It contain the declarations for variables.
├── output.tf                 // It contain the declarations for outputs.
├── terraform.tfvars          // The file to pass the terraform variables values.
```

### Module

A module is a container for multiple resources that are used together. Modules can be used to create lightweight abstractions, so that you can describe your infrastructure in terms of its architecture, rather than directly in terms of physical objects.

For the solution, we have created and used five modules:
1. resourcegroup - creating resourcegroup
2. networking - creating azure virtual network and required subnets
3. securitygroup - creating network security group, setting desired security rules and associating them to subnets
4. compute - creating availability sets, network interfaces and virtual machines
5. database - creating database server and database

All the stacks are placed in the modules folder and the variable are stored under **terraform.tfvars**

To run the code you need to append the variables in the terraform.tfvars

Each module consists minimum two files: main.tf, vars.tf

resourcegroup and networking modules consists of one extra file named output.tf

## Deployment

### Steps

**Step 0** `terraform init`

used to initialize a working directory containing Terraform configuration files

**Step 1** `terraform plan -out main.tfplan `

used to create an execution plan and create a plan file so that the implementation will be what you see in the output of the command.

**Step 2** `terraform validate`

validates the configuration files in a directory, referring only to the configuration and not accessing any remote services such as remote state, provider APIs, etc

**Step 3** `terraform apply "main.tfplan"`

used to apply the changes required to reach the desired state of the configuration
***Note:*** Keep in mind that the public IPs and NSGs sometimes give errors, if that happens, just create and associate those directly from the UI and import those into the terraform plan by command: `terraform import {resource_type [example: azurerm_resource_group]}.{resource_name[example: azure-stack-rs]} /subscriptions/{subscription-id}/resourceGroups/{resource_groupname}`
