
resource "aws_kms_key" "kms" {
  count = var.use_kms ? 1 : 0
  description = "main key" 
}