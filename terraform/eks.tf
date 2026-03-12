module "eks" {

  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name                    = local.name
  cluster_version                 = "1.31"
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  //access entry for any specific user or role (jenkins controller instance)
  access_entries = {
    # One access entry with a policy associated
    example = {
      principal_arn = "arn:aws:iam::153435306748:user/ithomelabadmin"

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)

  eks_managed_node_group_defaults = {

    instance_types = ["t3.large"]

    attach_cluster_primary_security_group = true

  }

  eks_managed_node_groups = {

    tws-demo-ng = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.large"]
      capacity_type = "SPOT"

      disk_size                  = 35
      use_custom_launch_template = false # Important to apply disk size!

      tags = {
        Name        = "tws-demo-ng"
        Environment = "dev"
        ExtraTag    = "e-commerce-app"
      }
    }
  }

  tags = local.tags


}

data "aws_instances" "eks_nodes" {
  instance_tags = {
    "eks:cluster-name" = module.eks.cluster_name
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  depends_on = [module.eks]
}
