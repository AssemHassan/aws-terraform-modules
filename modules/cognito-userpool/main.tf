

resource "aws_cognito_user_pool" "main_up" {
  name = "${var.namespace}.${var.env}-user-pool"
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "${var.namespace}-${var.env}-domain"
  user_pool_id = aws_cognito_user_pool.main_up.id
}
