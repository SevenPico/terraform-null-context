# terraform-null-context

Terraform module designed to generate consistent names and tags for resources. Use `terraform-null-context` to implement a strict naming convention.

## Why Use This Module

This module helps you create consistent and predictable names and tags for your resources, ensuring that they follow a strict naming convention. This is particularly useful for managing resources across multiple environments and stages.

## Functional Diagram

No Functional Diagram

## Deployed Resources

This module does not deploy any resources directly. Instead, it generates names and tags that can be used by other modules to deploy resources.

## Usage

### Simple Example

```hcl
module "example_label" {
  source   = "path/to/terraform-null-context"
  namespace  = "example"
  stage      = "prod"
  name       = "app"
  attributes = ["public"]
  delimiter  = "-"

  tags = {
    "BusinessUnit" = "XYZ",
    "Snapshot"     = "true"
  }
}
```

This will create an `id` with the value of `example-prod-app-public`.

### Advanced Example

```hcl
module "example_label" {
  source   = "path/to/terraform-null-context"
  namespace  = "example"
  stage      = "prod"
  name       = "app"
  attributes = ["public"]
  delimiter  = "-"

  tags = {
    "BusinessUnit" = "XYZ",
    "Snapshot"     = "true"
  }
}

resource "aws_instance" "example" {
  instance_type = "t2.micro"
  tags          = module.example_label.tags
}
```

## Configuration Summary

- **Naming Conventions**: Use the `namespace`, `stage`, `name`, and `attributes` variables to create a consistent naming convention.
- **Tagging Conventions**: Use the `tags` variable to add additional tags to your resources.
- **Common Configuration Patterns**: Use the `context` variable to set the entire context at once. Individual variable settings override the context.

## Terragrunt Instructions

To test-deploy and test-destroy the module in the sandbox using Terragrunt:

1. Create a `terragrunt.hcl` file with the following content:

   ```hcl
   terraform {
     source = "path/to/terraform-null-context"
   }

   inputs = {
     namespace  = "example"
     stage      = "prod"
     name       = "app"
     attributes = ["public"]
     delimiter  = "-"
     tags = {
       "BusinessUnit" = "XYZ"
       "Snapshot"     = "true"
     }
   }
   ```

2. Run the following commands to deploy and destroy the module:

   ```sh
   terragrunt apply
   terragrunt destroy
   ```

## Roadmap

- [ ] Add support for additional cloud providers.
- [ ] Improve support for tagging.
- [ ] Enhance the module to support more complex naming conventions.

## Requirements

| Name      | Version   |
| --------- | --------- |
| terraform | >= 0.13.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name                | Description                                                                   | Type           | Default                                                       | Required |
| ------------------- | ----------------------------------------------------------------------------- | -------------- | ------------------------------------------------------------- | :------: |
| context             | Single object for setting entire context at once.                             | `any`          | `{}`                                                          |    no    |
| enabled             | Set to false to prevent the module from creating any resources                | `bool`         | `true`                                                        |    no    |
| namespace           | ID element. Usually an abbreviation of your organization name.                | `string`       | `null`                                                        |    no    |
| tenant              | ID element. A customer identifier.                                            | `string`       | `null`                                                        |    no    |
| region              | Region.                                                                       | `string`       | `null`                                                        |    no    |
| project             | The project.                                                                  | `string`       | `null`                                                        |    no    |
| environment         | ID element. Usually used for region or role.                                  | `string`       | `null`                                                        |    no    |
| stage               | ID element. Usually used to indicate role.                                    | `string`       | `null`                                                        |    no    |
| name                | ID element. Usually the component or solution name.                           | `string`       | `null`                                                        |    no    |
| delimiter           | Delimiter to be used between ID elements.                                     | `string`       | `"-"`                                                         |    no    |
| attributes          | ID element. Additional attributes to add to `id`.                             | `list(string)` | `[]`                                                          |    no    |
| labels_as_tags      | Set of labels to include as tags in the `tags` output.                        | `set(string)`  | `["unset"]`                                                   |    no    |
| tags                | Additional tags.                                                              | `map(string)`  | `{}`                                                          |    no    |
| additional_tag_map  | Additional key-value pairs to add to each map in `tags_as_list_of_maps`.      | `map(string)`  | `{}`                                                          |    no    |
| label_order         | The order in which the labels appear in the `id`.                             | `list(string)` | `["namespace", "environment", "stage", "name", "attributes"]` |    no    |
| regex_replace_chars | Terraform regular expression string.                                          | `string`       | `"/[^a-zA-Z0-9-]/"`                                           |    no    |
| id_length_limit     | Limit `id` to this many characters.                                           | `number`       | `0`                                                           |    no    |
| label_key_case      | Controls the letter case of the `tags` keys.                                  | `string`       | `"title"`                                                     |    no    |
| label_value_case    | Controls the letter case of ID elements.                                      | `string`       | `"lower"`                                                     |    no    |
| descriptor_formats  | Describe additional descriptors to be output in the `descriptors` output map. | `any`          | `{}`                                                          |    no    |
| domain_name         | Route53 Zone domain name.                                                     | `string`       | `null`                                                        |    no    |
| dns_name_format     | Format string for dns_name output.                                            | `string`       | `"$${name}.$${domain_name}"`                                  |    no    |

## Outputs

| Name                 | Description                                                                              |
| -------------------- | ---------------------------------------------------------------------------------------- |
| id                   | Disambiguated ID string restricted to `id_length_limit` characters in total              |
| id_full              | ID string not restricted in length                                                       |
| dns_name             | A DNS name                                                                               |
| enabled              | True if module is enabled, false otherwise                                               |
| namespace            | Normalized namespace                                                                     |
| tenant               | Normalized tenant                                                                        |
| environment          | Normalized environment                                                                   |
| name                 | Normalized name                                                                          |
| stage                | Normalized stage                                                                         |
| delimiter            | Delimiter between `namespace`, `tenant`, `environment`, `stage`, `name` and `attributes` |
| attributes           | List of attributes                                                                       |
| tags                 | Normalized Tag map                                                                       |
| additional_tag_map   | The merged additional_tag_map                                                            |
| label_order          | The naming order actually used to create the ID                                          |
| regex_replace_chars  | The regex_replace_chars actually used to create the ID                                   |
| id_length_limit      | The id_length_limit actually used to create the ID, with `0` meaning unlimited           |
| tags_as_list_of_maps | List with one map for each `tag`.                                                        |
| descriptors          | Map of descriptors as configured by `descriptor_formats`                                 |
| normalized_context   | Normalized context of this module                                                        |
| legacy               | Backwards compatible for CloudPosse Module inputs                                        |
| self                 | Merged but otherwise unmodified input to this module                                     |
| dns_name_format      | DNS name format                                                                          |
| domain_name          | Domain name                                                                              |

## Contributing Guidelines

We welcome contributions from the community. To ensure a smooth process, please follow these guidelines:

1. Fork the repository and create your branch from `main`.
2. If you've added code that should be tested, add tests.
3. Ensure the test suite passes.
4. Make sure your code lints.
5. If you haven't already, complete the Contributor License Agreement ("CLA").

Thank you for your contributions!

## License

This project is licensed under the Apache License, Version 2.0. See the [LICENSE](LICENSE) file for details.

## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## Copyright

© 2023-2025 [SevenPico, Inc.](https://7pi.co/). All rights reserved.
