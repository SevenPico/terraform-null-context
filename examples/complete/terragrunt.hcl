dependency "tfstate" {
  config_path = "${get_repo_root()}/management/terraform-bootstrap"
}

locals {
  tenant      = "Brim"

  namespace   = "brim"
  project     = replace(basename(get_repo_root()), "teraform-", "")
  environment = ""
  stage       = basename(get_terragrunt_dir()) //
  domain_name = "${local.stage}.${local.project}.thebrim.io"

  tags = { Source = "Managed by Terraform" }
  regex_replace_chars = "/[^-a-zA-Z0-9]/"
  delimiter           = "-"
  replacement         = ""
  id_length_limit     = 0
  id_hash_length      = 5
  label_key_case      = "title"
  label_value_case    = "lower"
  label_order         =  ["namespace", "project", "environment", "stage", "name", "attributes"]
  dns_name_format     = "$${name}.$${domain_name}"
}

inputs = {
  enabled = true
  region  = "us-east-1"
  tenant              = local.tenant
  project             = local.project
  region              = local.region
  domain_name         = local.domain_name
  project             = local.project
  namespace           = local.namespace
  environment         = local.environment
  stage               = local.stage
  tags                = local.tags
  regex_replace_chars = local.regex_replace_chars
  delimiter           = local.delimiter
  replacement         = local.replacement
  id_length_limit     = local.id_length_limit
  id_hash_length      = local.id_hash_length
  label_key_case      = local.label_key_case
  label_value_case    = local.label_value_case
  label_order         = local.label_order
  dns_name_format     = local.dns_name_format
}

remote_state {
  backend = "s3"
  disable_init = false
  config  = {
    bucket                = dependency.tfstate.outputs.bucket_map["Sandbox"].bucket_id
    disable_bucket_update = true
    dynamodb_table        = dependency.tfstate.outputs.dynamodb_table_map["Sandbox"].table_name
    encrypt               = true
    key                   = "${local.project}/${local.stage}/terraform.tfstate"
    region                = local.region
  }
  generate = {
    path      = "generated-backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "providers" {
  path      = "generated-providers.tf"
  if_exists = "overwrite"
  contents  = <<EOF
  terraform {
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 4"
      }
      local = {
        source  = "hashicorp/local"
      }
    }
  }

  provider "aws" {
    region  = "${local.region}"
  }
  EOF
}
