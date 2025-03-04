locals {
  env     = terraform.workspace
  project = "ecom" 
  region = "ap-southeast-1"

  tf_vpc_cidr = {
    uat  = "10.0.0.0/16",
    prod = "20.0.0.0/16"
  }
  vpc_cidr = local.tf_vpc_cidr[local.env]

  tf_subnet_cidr_block = {
    prod = {
      public = {
        "${local.region}a" = "20.0.10.0/24",
        "${local.region}b" = "20.0.11.0/24",
        "${local.region}c" = "20.0.12.0/24"
      },
      private = {
        "${local.region}a" = "20.0.13.0/24",
        "${local.region}b" = "20.0.14.0/24",
        "${local.region}c" = "20.0.15.0/24"
      }
    }
    uat = {
      public = {
        "${local.region}a" = "10.0.10.0/24",
        "${local.region}b" = "10.0.11.0/24",
        "${local.region}c" = "10.0.12.0/24"
      }
      private = {
        "${local.region}a" = "10.0.13.0/24",
        "${local.region}b" = "10.0.14.0/24",
        "${local.region}c" = "10.0.15.0/24"
      }
    }
  }
  subnet_cidr_block = local.tf_subnet_cidr_block[local.env]
  common_tags = {
    "Environment" = "${local.env}"
    "Project"     = "ecom"
    "ManagedBY"   = "Terraform"
  }
  tf_route = {
    uat = {
      public = {
        "${local.vpc_cidr}" = "local",
        "0.0.0.0/0"         = "igw"
      }
      private = {
        "${local.vpc_cidr}" = "local",
        "0.0.0.0/0"         = "nat"
      }
    }
    prod = {
      public  = {}
      private = {}
    }
  }
  route = local.tf_route[local.env]
  tf_domain_name = {
    uat  = "kubebyte.xyz"
    prod = "kubebyte.xyz"
  }
  domain_name = local.tf_domain_name[local.env]
  tf_eks_version = {
    uat  = "1.30"
    prod = "1.30"
  }
  eks_version = local.tf_eks_version[local.env]
  tf_eks_ondemand_desired_size = {
    uat  = "0"
    prod = "2"
    sb   = "0"
    lt   = "0"
  }
  eks_ondemand_desired_size = local.tf_eks_ondemand_desired_size[local.env]
  tf_eks_ondemand_min_size = {
    uat  = "0"
    prod = "2"
    sb   = "0"
    lt   = "0"
  }
  eks_ondemand_min_size = local.tf_eks_ondemand_min_size[local.env]
  tf_eks_ondemand_max_size = {
    uat  = "0"
    prod = "2"
    sb   = "0"
    lt   = "0"
  }
  eks_ondemand_max_size = local.tf_eks_ondemand_max_size[local.env]
  tf_eks_spot_desired_size = {
    uat  = "2"
    prod = "0"
    sb   = "0"
    lt   = "0"
  }
  eks_spot_desired_size = local.tf_eks_spot_desired_size[local.env]
  tf_eks_spot_min_size = {
    uat  = "2"
    prod = "0"
    sb   = "0"
    lt   = "0"
  }
  eks_spot_min_size = local.tf_eks_spot_min_size[local.env]
  tf_eks_spot_max_size = {
    uat  = "2"
    prod = "0"
    sb   = "0"
    lt   = "0"
  }
  eks_spot_max_size = local.tf_eks_spot_max_size[local.env]
  tf_node_group_instance_types = {
    uat  = ["t3.medium", "t3a.medium", "t3.xlarge", "m5.xlarge"]
    prod = ["m5.xlarge", "m5d.xlarge", "m5a.xlarge", "m5ad.xlarge", "m5n.xlarge", "m5dn.xlarge", "m4.xlarge"]
    sb   = ["t3.medium", "t3a.medium"]
    lt   = ["m5.xlarge", "m5d.xlarge", "m5a.xlarge", "m5ad.xlarge", "m5n.xlarge", "m5dn.xlarge", "m4.xlarge", "t3a.xlarge"]
  }
  node_group_instance_types = local.tf_node_group_instance_types[local.env]
}