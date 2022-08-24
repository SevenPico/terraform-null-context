module "dns_context" {
  source = "../../"
  context = module.context.self
  name = "hello"
}
