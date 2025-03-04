resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  tags = merge(tomap({ "Name" = join("-", [var.tags["Environment"], var.tags["Project"], "acm"]) }), var.tags, tomap({ "ResourceType" = "ACM" }))

  lifecycle {
    create_before_destroy = true
  }
}