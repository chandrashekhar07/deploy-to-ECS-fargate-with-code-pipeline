output "bucket_arn" {
  value = module.s3.bucket_arn
}

output "bucket_url" {
  value = module.s3.bucket_url
}

output "alb_dns_name" {
  value = data.aws_alb.xxxx.dns_name
}

output "api_name" {
  value = "${local.api_prefix}.${data.cloudflare_zone.zone.name}"
}
