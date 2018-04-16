# Terraform-ansible

provision with ansible inside terraform to deploy a spring project

---
## Structure

**ansible** - folder with ansible playbooks and configuration

**aws** - folder with terraform infrastructure files

**imgs** - documentation images

**secrets** - generated folder with keypair files

**spring** - java project source

---
## Install prerequisites

Simply install aws, terraform and ansible following official documentation for your operating system

[Install aws](https://docs.aws.amazon.com/cli/latest/userguide/installing.html)

[Install terraform](https://www.terraform.io/downloads.html)

[Install ansible](http://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)


## Prepare 

clone the repository on your local machine and access the directory
```bash
$ git clone https://github.com/nroitero/terraform_aws_ansible
$ cd terraform_aws_ansible
```
install required plugins
```bash
$ terraform init aws
```




---
## Usage

To apply the configuration run:

```bash
$ terraform apply aws  
```
or
```bash
$ terraform apply aws -auto-approve  # if you want to skip confirmation
```
and wait for the magic

### first time run:

After first deployment you will have to wait a few for the instances to register on the load balancer 


## Configuration changes

### Change instance type
 For any change in configuration which might cause a downtime
 you should taint instances  before applying (create_before_destroy triggering)

 ex:
 ```bash
terraform taint aws_instance.server.0 
 ```
or use 
```bash
./taint_aws_instances.sh 
```
to taint all existing instances


### Add/remove a new instance

raise the count number in terraform.tfvars

please ***do not decrease*** the count or you will run into know bug 
 
https://github.com/hashicorp/terraform/issues/16626

instead you can create and destroy instances in seperated .tf file 

*ex: aws/3rd_instance.tf.bak*

### Info
![aws diagram](imgs/diagram.png )
![infrastructure graph](imgs/infrastructure_graph.png )
