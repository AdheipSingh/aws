provider "aws" {
        access_key = ""
        secret_key = ""
        region = "ap-south-1"
}

resource "aws_iam_role" "lamdarole" {
  name = "lamdarole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_lambda_function" "lambda" {
  filename         = "lambda.zip"
  function_name    = "mylambda"
  role             = "arn:aws:iam::642956775490:role/lamdarole"
  handler          = "lambda.lambda_handler"
  runtime          = "nodejs4.3"
  source_code_hash = "${base64sha256(file("lambda.zip"))}"
}

resource "aws_api_gateway_rest_api" "api" {
  name = "myapi"
}

resource "aws_api_gateway_resource" "resource" {
  path_part = "resource"
  parent_id = "${aws_api_gateway_rest_api.api.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
}
 
resource "aws_api_gateway_method" "method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_resource.resource.id}"
  http_method             = "${aws_api_gateway_method.method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:ap-south-1:lambda:path/lambda/functions/${aws_lambda_function.lambda.arn}/invocations"
}

