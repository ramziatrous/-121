resource "aws_apigatewayv2_api" "secrets_api" {
  name          = var.api_name
  protocol_type = "HTTP"
}
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.secrets_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "lambda_add_integration" {
  api_id             = aws_apigatewayv2_api.secrets_api.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.lambda_add.invoke_arn
}

resource "aws_apigatewayv2_route" "lambda_add_route" {
  api_id    = aws_apigatewayv2_api.secrets_api.id
  route_key = "POST /add"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_add_integration.id}"
}

resource "aws_lambda_permission" "allow_api_gateway_to_invoke_lambda_add" {
  statement_id  = "AllowAPIGatewayInvokeAdd"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.users_api.execution_arn}/*/*/add"
}