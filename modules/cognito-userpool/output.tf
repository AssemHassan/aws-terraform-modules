output "user_pool" {
  value = aws_cognito_user_pool.main_up
}

output "user_pool_domain" {
  value = aws_cognito_user_pool_domain.main
}