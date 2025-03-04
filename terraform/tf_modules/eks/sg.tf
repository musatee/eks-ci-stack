resource "aws_security_group" "eks-master" {
  name   = "${var.env}-${var.project}-eks-master"
  vpc_id = var.vpc_id
  tags   = var.tags
}
resource "aws_security_group_rule" "ecom-vpc-ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.eks-master.id
}
resource "aws_security_group_rule" "eks-master-ecom-vpc-ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
  security_group_id = aws_security_group.eks-master.id
}
resource "aws_security_group_rule" "eks-master-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks-master.id
}
