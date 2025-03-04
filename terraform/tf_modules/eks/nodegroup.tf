# node group of ondemand workers
resource "aws_eks_node_group" "ondemand_node_group" {
  count           = var.env == "prod" ? 1 : 0
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.env}-${var.project}-eks-ondemand-nodegroup"
  node_role_arn   = var.worker_node_role_arn
  subnet_ids      = var.subnet_ids
  ami_type        = "BOTTLEROCKET_x86_64"
  capacity_type   = "ON_DEMAND"
  disk_size       = 100
  instance_types  = var.node_group_instance_types
  tags = {
    Name = "${var.env}-${var.project}-eks-ondemand-worker"
  }

  scaling_config {
    desired_size = var.ondemand_desired_size
    max_size     = var.ondemand_max_size
    min_size     = var.ondemand_min_size
  }

  update_config {
    max_unavailable = 1
  }
}

# node group of spot workers
resource "aws_eks_node_group" "spot_node_group" {
  count           = var.env == "uat" ? 1 : 0
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.env}-${var.project}-eks-spot-nodegroup"
  node_role_arn   = var.worker_node_role_arn
  subnet_ids      = var.subnet_ids
  ami_type        = "BOTTLEROCKET_x86_64"
  capacity_type   = "SPOT"
  disk_size       = 100
  instance_types  = var.node_group_instance_types
  tags = {
    Name = "${var.env}-${var.project}-eks-spot-worker"
  }

  scaling_config {
    desired_size = var.spot_desired_size
    max_size     = var.spot_max_size
    min_size     = var.spot_min_size
  }

  update_config {
    max_unavailable = 1
  }
}

# Tagging managed nodegroup EC2
resource "aws_autoscaling_group_tag" "spot-nodegroup-tag" {
  count                  = var.env == "uat" ? 1 : 0
  autoscaling_group_name = aws_eks_node_group.spot_node_group[0].resources[0].autoscaling_groups[0].name
  tag {
    key                 = "Name"
    value               = "${var.env}-${var.project}-managed-node"
    propagate_at_launch = true
  }
  depends_on = [aws_eks_node_group.spot_node_group]
}

resource "aws_autoscaling_group_tag" "ondemand-nodegroup-tag" {
  count                  = var.env == "prod" ? 1 : 0
  autoscaling_group_name = aws_eks_node_group.ondemand_node_group[0].resources[0].autoscaling_groups[0].name
  tag {
    key                 = "Name"
    value               = "${var.env}-${var.project}-managed-node"
    propagate_at_launch = true
  }
  depends_on = [aws_eks_node_group.ondemand_node_group]
}
