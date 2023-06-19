# AWS Certificate Manager certificate 
resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "cert" { 
  private_key_pem = tls_private_key.key.private_key_pem

  subject {
    common_name  = var.domain_name
    organization = "ACME Examples, Inc"
  }

  validity_period_hours = 48

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "cert" {
  private_key      = tls_private_key.key.private_key_pem
  certificate_body = tls_self_signed_cert.cert.cert_pem
}