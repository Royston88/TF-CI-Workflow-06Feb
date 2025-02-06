provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = "~> 1.0"

  backend "s3" {
    bucket = "sctp-ce8-tfstate"
    key    = "royston-s3-tf-ci.tfstate"
    region = "ap-southeast-1"
  }
}

data "aws_caller_identity" "current" {}

locals {
  name_prefix = split("/", data.aws_caller_identity.current.arn)[1]
  account_id  = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket" "s3_tf" {
  #checkov:skip=CKV_AWS_18:This bucket does not require access logging
  #checkov:skip=CKV2_AWS_62:Event notifications not required for this bucket
  #checkov:skip=CKV_AWS_21:Versioning not required for this bucket
  #checkov:skip=CKV2_AWS_6:Public access block not required as bucket is private by default
  #checkov:skip=CKV_AWS_144:Cross-region replication not needed for this use case
  #checkov:skip=CKV_AWS_145:Default SSE-S3 encryption is sufficient for this bucket
  #checkov:skip=CKV2_AWS_61:Lifecycle configuration not needed for this bucket

  bucket = "${local.name_prefix}-s3-tf-bkt-${local.account_id}"
}