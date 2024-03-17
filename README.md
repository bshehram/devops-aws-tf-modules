# DevOps AWS Terraform Modules
### A Terraform module collection that creates VPCs and related network resources in an AWS account for the us-west-2 region.

## Usage
```
module "network" {
  source = "github.com/bshehram/devops-aws-tf-modules"

  optional_prefix       = var.optional_prefix
  endpoint_region       = var.endpoint_region # default is us-west-2
  availability_zones    = var.availability_zones # ensure they are in endpoint_region
  vpc_cidr              = var.networks["vpc"]
  public_subnet_cidrs   = split(",", var.networks["public"])
  private_subnet_cidrs  = split(",", var.networks["private"])
  internal_subnet_cidrs = split(",", var.networks["internal"])
}
```

## Requirements
```
endpoint_region    = "us-west-2"
availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"]

networks = {
  vpc      = "10.42.0.0/16"
  public   = "10.42.0.0/21,10.42.8.0/21,10.42.16.0/21,10.42.24.0/21"
  private  = "10.42.32.0/19,10.42.64.0/19,10.42.96.0/19,10.42.128.0/19"
  internal = "10.42.160.0/21,10.42.168.0/21,10.42.176.0/21,10.42.184.0/21"
  spare1   = "10.42.192.0/19" # This does not get provisioned.
  spare2   = "10.42.224.0/19" # This does not get provisioned.
}

optional_prefix = "prd-"
```

## Compatibility

| Name | Version |
|------|---------|
| terraform | >= 1.7.5 |
| aws | >= 5.41.0 |
