module "apigateway" {
  source = "./module/apigateway"
  lambda_arn = module.lambda.lambda_arn
}
module "lambda" {
  source = "./module/lambda"
}
module "dynamoDB" {
  source = "./module/dynamodb"
}