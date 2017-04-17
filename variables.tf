variable "aws_access_key" {
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
}

variable "aws_region" {
  default     = "eu-west-2"
  description = "AWS Region"
}

variable "aws_ssh_admin_key_file" { }

variable "ami" {
  default = "ami-df5d48bb"
}

variable "aws_instance_type" {
  default = "t2.micro"
}

variable "bucket_name" {
  description = "S3 Bucket Name"
}
variable "bucket_user" {
  description = "S3 Bucket User"
}
