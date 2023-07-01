provider "aws" {
  region = var.region
  profile = var.aws_profile
}


##-------------IAM-ROLE------------##
module "iam_lambda" {
    source = "./modules/iam/role"
    role = "SalesClientsLambdaDynamoDB"
    statements = {
      "AssumeLambda" = {
        principals = {
          "Service" = ["lambda.amazonaws.com"]
        }
        actions = ["sts:AssumeRole"]
        effect = "Allow"
      },
    }
}
##-------------IAM-ROLE------------##


##-------------S3------------##
module "s3_sales_clients" {
    source = "./modules/s3"
    
    bucket_name = "sales-clients"

    public_access_block = {
        block_public_acls       = true
        block_public_policy     = true
        ignore_public_acls      = true
        restrict_public_buckets = true
    }

    statements = {
      "AllowReadOnly" = {
        principals = {
          "AWS" = [module.iam_lambda.arn]
        }
        actions = ["s3:ListBucket","s3:GetObject"]
        effect = "Allow"
      },
    }
}
##-------------S3------------##


##-------------LAMBDA------------##
data "archive_file" "lambda_sales_clients" {
  type        = "zip"
  source_dir = "${path.module}/files/src"
  output_path = "${path.module}/files/lambda/lambda.zip"
}

resource "aws_lambda_function" "sales_clients" {
  filename          = data.archive_file.lambda_sales_clients.output_path
  function_name     = "SalesClientsLambdaDynamoDB"
  role              = module.iam_lambda.arn
  handler           = "lambda_function.lambda_handler"
  runtime           = "python3.10"
  environment {
    variables = {
      tableSalesClients = resource.aws_dynamodb_table.sales_clients_table.name
    }
  }
}

resource "aws_lambda_permission" "s3_sales_clients_allow_lambda" {
 statement_id  = "AllowExecutionFromSalesClientsS3"
 action        = "lambda:InvokeFunction"
 function_name = aws_lambda_function.sales_clients.arn
 principal     = "s3.amazonaws.com"
 source_arn    = module.s3_sales_clients.arn
}

resource "aws_s3_bucket_notification" "s3_sales_clients_notification" {
 bucket = module.s3_sales_clients.id
 lambda_function {
   lambda_function_arn = aws_lambda_function.sales_clients.arn
   events              = ["s3:ObjectCreated:*"]
   filter_suffix       = ".json"
 }
 depends_on = [aws_lambda_permission.s3_sales_clients_allow_lambda]
}

resource "aws_iam_role_policy_attachment" "lambda_default" {
  role       = module.iam_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
##-------------LAMBDA------------##


##-------------DYNAMODB------------##
resource "aws_dynamodb_table" "sales_clients_table" {
  name           = "SalesClients"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

module "iam_policy_sales_clients" {
    source = "./modules/iam/policy"
    name = "NuweLambdaPutDynamoDBSalesClient"
    description = "IAM Policy put items on lambda table"
    roles = toset([module.iam_lambda.name])
    statements = [
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:BatchWriteItem"
        ]
        Effect   = "Allow"
        Resource = [
          "${resource.aws_dynamodb_table.sales_clients_table.arn}"
        ]
      },
    ]
}
##-------------DYNAMODB------------##
