
 locals {
   function_name = "${var.namespace}-lagging"
   api_gw_name = "${var.namespace}-lagging"
 }

resource "aws_cloudwatch_log_group" "my-log-group" {
  name = "/aws/lambda/${local.function_name}"
  retention_in_days = 1
}

resource "aws_lambda_function" "lambda_zip_inline" {
  filename         = "${data.archive_file.lambda_zip_inline.output_path}"
  source_code_hash = "${data.archive_file.lambda_zip_inline.output_base64sha256}"
  function_name = "${local.function_name}"
  handler = "index.handler"
  runtime = "nodejs18.x"
  role = "${var.lambda_role_arn}"  
  memory_size  = 128
  timeout = 120
}
 
resource "aws_api_gateway_rest_api" "api_gw" {
  name = local.api_gw_name
}

resource "aws_api_gateway_resource" "api_gw_rc" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  parent_id   = aws_api_gateway_rest_api.api_gw.root_resource_id
  path_part   = "${local.function_name}"
}

resource "aws_api_gateway_method" "api_gw_rc_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id
  resource_id   = aws_api_gateway_resource.api_gw_rc.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_lambda_permission" "example_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_zip_inline.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api_gw.execution_arn}/*/*"
}

resource "aws_api_gateway_integration" "api_gw_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gw.id
  resource_id             = aws_api_gateway_resource.api_gw_rc.id
  http_method             = aws_api_gateway_method.api_gw_rc_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  
  uri = aws_lambda_function.lambda_zip_inline.invoke_arn
}

resource "aws_api_gateway_deployment" "example_deployment" {
  depends_on = [aws_api_gateway_integration.api_gw_integration]
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  stage_name = "dev"
}


output "api_gateway_url" {
  value = "${aws_lambda_function.lambda_zip_inline.arn}"
}