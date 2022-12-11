# How to manage multiple environments with terraform with the use of modules?

### What is Terraform?

Terraform is a free and open-source infrastructure as code (IAC) that can help to automate the deployment, configuration, and management of the remote servers. Terraform can manage both existing service providers and custom in-house solutions.

![1](https://github.com/DhruvinSoni30/Terraform_Multiple_Environments/blob/main/images/terraform.jpeg?raw=true)

### Prerequisites:

* A server that has Terraform installed in it & AWS CLI also!
* Basic understanding of Terraform 
* Basic understanding of AWS
* AWS Access Key & Secret Key

### What are terraform modules?

A Terraform module allows you to create logical abstraction on the top of some resource set. In other words, a module allows you to group resources together and reuse this group later, possibly many times. Terraform module allow us to use the concept of DRY (Don't Repete Yourself). With the use of terraform modules you can write the code for various resources once and reuse them in different environment as per your need!

![2](https://github.com/DhruvinSoni30/Terraform_Multiple_Environments/blob/main/images/module.png?raw=true)

You can read more details of terraform modules from [here](https://itoutposts.com/blog/terraform-modules-overview/)

In this tutorial we will take a look at how to use modules and maintain different infrastructure for different environment!
