

resource "aws_cognito_user_pool_client" "userpool_clients" {
for_each = {for app-client in var.app_client_list:  app-client.env_name => app-client}
  name                                 = "${var.namespace}-appclient-${each.value.env_name}"
  user_pool_id                         = var.user_pool_id
  callback_urls                        = each.value.callback_urls
  logout_urls                          = each.value.signout_urls
  allowed_oauth_flows_user_pool_client = true
  explicit_auth_flows                  = ["ALLOW_CUSTOM_AUTH","ALLOW_REFRESH_TOKEN_AUTH","ALLOW_USER_SRP_AUTH"]
  allowed_oauth_scopes                 = ["email", "openid","profile","aws.cognito.signin.user.admin","phone"]
  supported_identity_providers         = ["COGNITO"]
  allowed_oauth_flows = ["code","implicit"]
  prevent_user_existence_errors = "LEGACY"
  read_attributes = ["email", "name", "given_name","family_name","preferred_username","profile","zoneinfo"]
  write_attributes = ["email", "name", "given_name","family_name","preferred_username","profile","zoneinfo"]
  generate_secret     = true
}


resource "aws_cognito_user_group" "user_group" {
for_each = {for cognito-group in var.cognito_group_list:  cognito-group.name => cognito-group}
  name         = each.value.name
  user_pool_id = var.user_pool_id
  description  = each.value.desc
  precedence   = 0
  #role_arn     = aws_iam_role.group_role.arn
}

