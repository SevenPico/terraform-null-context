module "dns_context" {
  source = "../../"
  context = module.context.context
  name = "hello"
}
