#---------------------------------------------------
# Creating EKS Cluster
# ---------------------------------------------------
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  # load_config_file       = false
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-eks"
  cluster_version = "1.21"
  subnet_ids         = [data.terraform_remote_state.vpc.outputs.subnet-public1, data.terraform_remote_state.vpc.outputs.subnet-public2, data.terraform_remote_state.vpc.outputs.subnet-public3, data.terraform_remote_state.vpc.outputs.subnet-private1, data.terraform_remote_state.vpc.outputs.subnet-private2, data.terraform_remote_state.vpc.outputs.subnet-private3]
  vpc_id          = data.terraform_remote_state.vpc.outputs.aws-vpc

  self_managed_node_groups = {
    public = {
      subnets          = [data.terraform_remote_state.vpc.outputs.subnet-public1, data.terraform_remote_state.vpc.outputs.subnet-public2, data.terraform_remote_state.vpc.outputs.subnet-public3]
      desired_capacity = 1
      max_capacity     = 10
      min_capacity     = 1

      instance_type = var.instance_type
      k8s_labels = {
        Environment = "public"
      }
    }
    private = {
      subnets          = [data.terraform_remote_state.vpc.outputs.subnet-private1, data.terraform_remote_state.vpc.outputs.subnet-private2, data.terraform_remote_state.vpc.outputs.subnet-private3]
      desired_capacity = 2
      max_capacity     = 10
      min_capacity     = 1

      instance_type = var.instance_type
      k8s_labels = {
        Environment = "private"
      }
    }
  }

}