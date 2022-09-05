# Updated Terraform code to provision EKS with bootstrap steps

## Features
* Use generic variables and tfvars for each sub folder
* Use Remote state as data source

## 0-bootstrap
* Create state s3 bucket

## 1-vpc
* Provision vpc with 3 pub subnets and 3 private subnets

## 2-eks
* Provision eks

## remote-state
* remote state for vpc as data source to be used by EKS


## Incorperate generic config on each subfolder
```
ln -s ../variables.tf variables.tf
ln -s ../terraform.auto.tfvars terraform.auto.tfvars
```
## Use Remote state as data source on each subfolder
```
ln -s ../remote-state/remote-state-vpc.tf remote-state-vpc.tf
```

## References

* [EKS cluster deployment using Terraform](
https://sebinxavi.medium.com/eks-cluster-deployment-using-terraform-685c89b14f72)

