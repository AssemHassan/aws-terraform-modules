output "kms_arn" {
  value = length(aws_kms_key.kms) > 0 ?  aws_kms_key.kms[0].arn : null
}
 