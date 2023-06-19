
 locals {
   function_name = "${var.namespace}-pingo"
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
  memory_size = 128
}
 