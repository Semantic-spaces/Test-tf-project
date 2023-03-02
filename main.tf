resource "aws_s3_bucket" "s3_bucket_A" {
  bucket = "bucket_A"
  }
}

resource "aws_s3_bucket" "s3_bucket_B" {
  bucket = "bucket_B"
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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

resource "aws_lambda_function" "image_metadata_removal_lambda" {
  filename      = "remove-metadata.py"
  function_name = "remove-metadata-copy-to-bucket-B"
  role          = aws_iam_role.iam_for_lambda.arn

  runtime = "python3.9"
}

resource "aws_iam_user" "user_A" {
  name = "A"
}

resource "aws_iam_user" "user_B" {
  name = "A"
}

resource "aws_iam_policy_attachment" "user_A_policy_attachment" {
  name       = "user_A_policy_attachment"
  users      = [aws_iam_user.user_A.name]
  roles      = [aws_iam_role.role_A.name]
  policy_arn = aws_iam_policy.policy_A.arn
}

resource "aws_iam_policy_attachment" "user_B_policy_attachment" {
  name       = "user_B_policy_attachment"
  users      = [aws_iam_user.user_B.name]
  roles      = [aws_iam_role.role_B.name]
  policy_arn = aws_iam_policy.policy_B.arn
}

resource "aws_iam_policy" "policy_A" {
  name        = "policy_A"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::bucket_A/*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy_B" {
  name        = "policy_B"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::bucket_B/*"
    }
  ]
}
EOF
}

