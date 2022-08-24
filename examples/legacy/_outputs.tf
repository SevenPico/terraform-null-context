output "context_id" {
  value = module.context.id
}
output "context_dns_name" {
  value = module.context.dns_name
}
output "context_domain_name" {
  value = module.context.domain_name
}
output "context_dns_name_format" {
  value = module.context.dns_name_format
}

output "legacy_label_id" {
  value = module.legacy_label.id
}
output "legacy_label_dns_name" {
  value = try(module.legacy_label.dns_name, "EXPECTED FAILURE")
}
output "legacy_label_domain_name" {
  value = try(module.legacy_label.domain_name, "EXPECTED FAILURE")
}
output "legacy_label_dns_name_format" {
  value = try(module.legacy_label.dns_name_format, "EXPECTED FAILURE")
}
output "legacy_label" {
  value = module.legacy_label.context
}
