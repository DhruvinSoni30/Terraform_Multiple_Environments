# How to manage multiple environments with terraform with the use of modules?

### What is Terraform?

Terraform is a free and open-source infrastructure as code (IAC) that can help to automate the deployment, configuration, and management of the remote servers. Terraform can manage both existing service providers and custom in-house solutions.

![1](https://github.com/DhruvinSoni30/Terraform_Multiple_Environments/blob/main/images/terraform.jpeg)

### Prerequisites:

* A server that has Terraform installed in it & AWS CLI also!
* Basic understanding of Terraform 
* Basic understanding of AWS
* AWS Access Key & Secret Key

### What are terraform modules?

A Terraform module allows you to create logical abstraction on the top of some resource set. In other words, a module allows you to group resources together and reuse this group later, possibly many times. Terraform module allow us to use the concept of DRY (Don't Repete Yourself). With the use of terraform modules you can write the code for various resources once and reuse them in different environment as per your need!

![2](https://github.com/DhruvinSoni30/Terraform_Multiple_Environments/blob/main/images/module.png)

You can read more details of terraform modules from [here](https://itoutposts.com/blog/terraform-modules-overview/)

In this tutorial we will take a look at how to use modules and maintain different infrastructure for different environment!

### Step 1: 

* We need to create the moduel for EC2 instance and so that we can use it for different environment later!
* Create a folder called `modules` and `ec2` inside `modules` folder 

  ```
  VW3N7VQKQX:Terraform_Multiple_Environments dhruvins$ cd modules/
  VW3N7VQKQX:modules dhruvins$ ls -la
  total 0
  drwxr-xr-x@  3 dhruvins  staff   96 Dec 11 21:55 .
  drwxr-xr-x  10 dhruvins  staff  320 Dec 11 23:23 ..
  drwxr-xr-x   5 dhruvins  staff  160 Dec 11 01:56 ec2
  VW3N7VQKQX:modules dhruvins$ 
  ```
  
* Create `main.tf` file and add below code in it 
  
  ```
  resource "aws_instance" "demo_instance" {

  ami               = var.ami_id
  instance_type     = var.instance_type
  availability_zone = var.availability_zone

  tags = {
    "Name" = var.name
    "Env"  = var.env
  }
  }
  ```

* Create `variables.tf` file and add below code in it
  ```
  # Region
  variable "region" {}

  # AMI ID
  variable "ami_id" {
    type = string
  }

  # Instance Type
  variable "instance_type" {
    type = string
  }

  # AZ
  variable "availability_zone" {}

  # Tags
  variable "name" {
    type = string
  }
 
  # Tags
  variable "env" {
    type = string
  }
  ```

* Create `output.tf` file and add below code in it
  ```
  output "public_IP" {
    value = aws_instance.demo_instance.public_ip
  }
  ```
  
  ```
  VW3N7VQKQX:ec2 dhruvins$ ls -la
  total 24
  drwxr-xr-x  5 dhruvins  staff  160 Dec 11 01:56 .
  drwxr-xr-x@ 3 dhruvins  staff   96 Dec 11 21:55 ..
  -rw-r--r--  1 dhruvins  staff  223 Dec 11 01:39 main.tf
  -rw-r--r--  1 dhruvins  staff   70 Dec 11 01:37 output.tf
  -rw-r--r--  1 dhruvins  staff  266 Dec 11 01:38 variables.tf
  VW3N7VQKQX:ec2 dhruvins$ 
  ```

* Now out structure for module is ready, we are not using any value for the variables and so that we can different value for different environments later 

### Step 2:

* Create folders like `stg`, `lve` & `dev` for different environments like below
  ```
  VW3N7VQKQX:Terraform_Multiple_Environments dhruvins$ ls -la
  total 16
  drwxr-xr-x   10 dhruvins  staff   320 Dec 11 23:23 .
  drwx------@ 157 dhruvins  staff  5024 Dec 19 13:45 ..
  drwxr-xr-x@   6 dhruvins  staff   192 Dec 11 22:53 dev
  drwxr-xr-x@   3 dhruvins  staff    96 Dec 11 21:55 modules
  drwxr-xr-x@   6 dhruvins  staff   192 Dec 11 22:53 prod
  drwxr-xr-x    6 dhruvins  staff   192 Dec 11 22:53 stg
  VW3N7VQKQX:Terraform_Multiple_Environments dhruvins$ 
  ```

* First, we will define the code for the `stg` environment 
* Create `main.tf` file in `stg` folder & add below code in it 

  ```
  module "ec2" {
  source = "../modules/ec2"

  ami_id            = var.ami_id
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  name              = var.name
  env               = var.env
  region            = var.region

  }
  ```

* In the above code we are calling the ec2 module and using the mandatory variables 

* Create `provider.tf` file and add below code in it 

  ```
  provider "aws" {
    region = var.region
    profile = "default"
  }

  terraform {
    backend "s3" {
      bucket = "tf-state-dhsoni"
      region = "us-west-2"
      key    = "stg/terraform.tfstate"
      profile = "default"
    }
  ```
 
* We are using S3 bucket for storing the state file in it so, that we do not need to maintain it locally and for that I have already created the bucket called `tf-state-dhsoni` on AWS
* The above code will create `stg` folder inside the `tf-state-dhsoni` bucket and store the state file for `stg` environment 

* Create `variables.tf` file and add below code in it 
  ```
  # Region
  variable "region" {}

  # AMI ID
  variable "ami_id" {
    type = string
  }

  # Instance Type
  variable "instance_type" {
    type = string
  }

  # AZ
  variable "availability_zone" {}

  # Tags
  variable "name" {
    type = string
  }

  # Tags
  variable "env" {
    type = string
  }
  ```

* Create `terraform.tfvars` file and add below code in it 

  ```
  VW3N7VQKQX:stg dhruvins$ cat terraform.tfvars 
  ami_id            = "ami-0beaa649c482330f7"
  instance_type     = "t2.micro"
  availability_zone = "us-east-2a"
  name              = "Stg_Instance"
  env               = "Stg"
  region            = "us-east-2"
  ```

* The above values for all the variables for `stg` environment 

### Step 3:

* Now, we will create the code for `prod` environment 

* `main.tf` file

  ```
  module "ec2" {
  source = "../modules/ec2"

  ami_id            = var.ami_id
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  name              = var.name
  env               = var.env
  region            = var.region

  }
  ```

* `variables.tf` file:
  ```
  # Region
  variable "region" {}

  # AMI ID
  variable "ami_id" {
    type = string
  }

  # Instance Type
  variable "instance_type" {
    type = string
  }

  # AZ
  variable "availability_zone" {}

  # Tags
  variable "name" {
    type = string
  }

  # Tags
  variable "env" {
    type = string
  }
  ```

* `provider.tf` file

  ```
  provider "aws" {
    region = var.region
    profile = "default"
  }

  terraform {
    backend "s3" {
      bucket = "tf-state-dhsoni"
      region = "us-west-2"
      key    = "prod/terraform.tfstate"
      profile = "default"
    }
  }
  ```
  
* The above code will create `prod` folder inside the `tf-state-dhsoni` bucket and store the state file for `prod` environment 

* `terraform.tfvars` file:

  ```
  VW3N7VQKQX:prod dhruvins$ cat terraform.tfvars 
  ami_id            = "ami-0beaa649c482330f7"
  instance_type     = "t2.micro"
  availability_zone = "us-east-2a"
  name              = "Prod_Instance"
  env               = "Prod"
  region            = "us-east-2"
  ```
  
* The above values for all the variables for `prod` environment 

### Step 4: 

* Now, we will create the code for `dev` environment 

* `main.tf` file

  ```
  module "ec2" {
  source = "../modules/ec2"

  ami_id            = var.ami_id
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  name              = var.name
  env               = var.env
  region            = var.region

  }
  ```

* `variables.tf` file:
  ```
  # Region
  variable "region" {}

  # AMI ID
  variable "ami_id" {
    type = string
  }

  # Instance Type
  variable "instance_type" {
    type = string
  }

  # AZ
  variable "availability_zone" {}

  # Tags
  variable "name" {
    type = string
  }

  # Tags
  variable "env" {
    type = string
  }
  ```

* `provider.tf` file

  ```
  provider "aws" {
    region = var.region
    profile = "default"
  }

  terraform {
    backend "s3" {
      bucket = "tf-state-dhsoni"
      region = "us-west-2"
      key    = "dev/terraform.tfstate"
      profile = "default"
    }
  }
  ```

* The above code will create `dev` folder inside the `tf-state-dhsoni` bucket and store the state file for `dev` environment 

* `terraform.tfvars` file

  ```
  VW3N7VQKQX:dev dhruvins$ cat terraform.tfvars 
  ami_id            = "ami-0beaa649c482330f7"
  instance_type     = "t2.micro"
  availability_zone = "us-east-2a"
  name              = "Dev_Instance"
  env               = "Dev"
  region            = "us-east-2"
  ```
  
* The above values for all the variables for `dev` environment 

* Now, our entire setup is ready for all the different environments!

Run below command one by one from each folder i.e. `stg`, `dev` & `prod` and you will see 3 different instances and state file for each environment!

![1](https://github.com/DhruvinSoni30/Terraform_Multiple_Environments/blob/main/images/1.png)

![2](https://github.com/DhruvinSoni30/Terraform_Multiple_Environments/blob/main/images/2.png)

![3](https://github.com/DhruvinSoni30/Terraform_Multiple_Environments/blob/main/images/3.png)





