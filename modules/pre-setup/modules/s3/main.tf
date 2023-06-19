resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.name}.${var.env}"

  tags = {
    Name        = "${var.name}.${var.env}" 
  }
  
}


resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = "${var.kms_arn}"
      sse_algorithm     = "aws:kms"
    }
  }
}

