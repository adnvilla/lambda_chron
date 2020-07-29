# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

data "aws_iam_role" "iam_for_lambda" {
  name = "lambda_basic_execution" # The role to use
}


# Define a Lambda function.
#
# The handler is the name of the executable for go1.x runtime.
resource "aws_lambda_function" "hello" {
  function_name    = "hello"
  filename         = "hello.zip"
  handler          = "hello"
  
  role             = data.aws_iam_role.iam_for_lambda.arn
  source_code_hash = filebase64sha256("hello.zip")
  runtime          = "go1.x"
  memory_size      = 128
  timeout          = 1
}


resource "aws_cloudwatch_event_rule" "every_five_minutes" {
    name = "every-five-minutes"
    description = "Fires every five minutes"
    schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "hello_every_five_minutes" {
    rule = aws_cloudwatch_event_rule.every_five_minutes.name
    target_id = "hello"
    arn = aws_lambda_function.hello.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_hello" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.hello.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.every_five_minutes.arn
}
