## ----------------------------------------------------------------------------
##  Copyright 2023 SevenPico, Inc.
##  Copyright 2020-2022 Cloud Posse, LLC
##
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.
## ----------------------------------------------------------------------------

## ----------------------------------------------------------------------------
##  ./examples/complete/_fixtures.context.auto.tfvars
##  This file contains code modified by SevenPico, Inc.
## ----------------------------------------------------------------------------

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


