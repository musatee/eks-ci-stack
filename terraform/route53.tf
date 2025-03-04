module "ecom_zone" {
  source = "./tf_modules/route53"
  zone   = local.domain_name
  tags   = local.common_tags
}

resource "aws_route53_record" "ecom_records" {
  name       = module.acm.resource_record_name
  type       = module.acm.resource_record_type
  zone_id    = module.ecom_zone.zone_id
  records    = [module.acm.resource_record_value]
  ttl        = 60
  depends_on = [module.ecom_zone, module.acm]
}

# this resource typically helps terraform to know whether aws validates the requested acm or not
# also it helps terraform to proceed for the next operation in its ecosystem
resource "aws_acm_certificate_validation" "ecom_acm_validate" {
  certificate_arn         = module.acm.acm_arn
  validation_record_fqdns = [aws_route53_record.ecom_records.fqdn]
}