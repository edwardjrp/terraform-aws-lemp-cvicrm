# Defines a user that should be able to write to you test bucket
resource "aws_iam_user" "test_user" {
    name = "${var.bucket_user}"
}

resource "aws_iam_access_key" "test_user_key" {
    user = "${aws_iam_user.test_user.name}"
}

resource "aws_iam_user_policy" "test_user_ro" {
    name = "test"
    user = "${aws_iam_user.test_user.name}"
    policy= <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "${aws_s3_bucket.test_bucket.arn}",
                "${aws_s3_bucket.test_bucket.arn}/*"
            ]
        }
   ]
}
EOF
}

resource "aws_s3_bucket" "test_bucket" {
    bucket = "${var.bucket_name}"
    acl = "private"
    cors_rule {
        allowed_headers = ["*"]
        allowed_methods = ["PUT","POST"]
        allowed_origins = ["*"]
        expose_headers = ["ETag"]
        max_age_seconds = 3000
    }
 policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowTest",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_user.test_user.arn}"
      },
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::${var.bucket_name}/*"
    }
  ]
}
POLICY
}
