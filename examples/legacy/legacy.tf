module "legacy_label" {
  source  = "registry.terraform.io/cloudposse/label/null"
  version = "0.25.0" # requires Terraform >= 0.13.0
  context = module.context.legacy
  name    = "hello"
}
