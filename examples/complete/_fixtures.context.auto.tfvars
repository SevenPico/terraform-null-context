enabled     = true
namespace   = "7pi"
tenant      = "Foo"
project     = "Project 1"
region      = "us-east-1"
environment = "dev"
stage       = "sandbox-01"
name        = "baz"
delimiter   = "-"
attributes  = ["1", "2"]
tags        = { Compliance : "none" }
#additional_tag_map  = var.additional_tag_map
#label_order         = var.label_order
#regex_replace_chars = var.regex_replace_chars
#id_length_limit     = var.id_length_limit
#label_key_case      = var.label_key_case
#label_value_case    = var.label_value_case
#descriptor_formats  = var.descriptor_formats
#labels_as_tags      = var.labels_as_tags
dns_name_format = "$${name}.$${domain_name}"
domain_name     = "sevenpico.com"


