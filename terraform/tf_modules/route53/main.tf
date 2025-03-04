resource "aws_route53_zone" "primary" {
  name = var.zone
  tags = merge(tomap({ "Name" = join("-", [var.tags["Environment"], var.tags["Project"], "route53 Zone"]) }), var.tags, tomap({ "ResourceType" = "route53 Zone" }))
}