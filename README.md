# terraform-null-context

Terraform module designed to generate consistent names and tags for resources. Use `terraform-null-context` to implement a strict naming convention.

## Why Use This Module

This module helps you create consistent and predictable names and tags for your resources, ensuring that they follow a strict naming convention. This is particularly useful for managing resources across multiple environments and stages.

## Functional Diagram

No Functional Diagram

## Deployed Resources

This module does not deploy any resources directly. Instead, it generates names and tags that can be used by other modules to deploy resources.

## Examples

### Module Usage Examples

#### Simple Example

```hcl
module "example_label" {
  source    = "SevenPico/context/null"
  namespace = "7pi"
  stage     = "prod"
  name      = "app"
  attributes = ["public"]
  delimiter = "-"

  tags = {
    "BusinessUnit" = "XYZ",
    "Snapshot"     = "true"
  }
}
```

_Creates an id: 7pi-prod-app-public. Outputs like `id` and `tags` are available._

#### Advanced Example

```hcl
module "example_label" {
  source    = "SevenPico/context/null"
  namespace = "7pi"
  stage     = "prod"
  name      = "app"
  attributes = ["public"]
  delimiter = "-"

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

_Outputs such as `id`, `id_full`, and `tags` can be referenced as module outputs._

#### Nested Module Example

```hcl
module "slack_sns_topic_context" {
  source     = "SevenPico/context/null"
  version    = "2.0.0"
  context    = module.context.self
  attributes = ["slack", "sns"]
}

resource "aws_sns_topic" "slack_sns_topic" {
  count         = module.slack_sns_topic_context.enabled ? 1 : 0
  name          = module.slack_sns_topic_context.id
  tags          = module.slack_sns_topic_context.tags
  # ...other attributes...
}
```

### Terragrunt Example

```hcl
terraform {
  source = "SevenPico/context/null?ref=2.0.1"
}

inputs = {
  namespace = "7pi"
  stage     = "prod"
  name      = "app"
  attributes = ["public"]
  delimiter = "-"
  tags = {
    "BusinessUnit" = "XYZ"
    "Snapshot"     = "true"
  }
}
```

_In addition, in your Terraform configuration you can reference module outputs as follows:_

```hcl
resource "aws_instance" "example" {
  count         = module.context.enabled ? 1 : 0
  name          = module.context.id
  tags          = module.context.tags
  instance_type = "t2.micro"
  # ...other attributes...
}
```

_Deploy using `terragrunt apply` and reference module outputs (e.g. `context.id` and `context.dns_name`)._

## Configuration Summary

- **Naming Conventions**: Input variables such as `namespace`, `stage`, `name`, and `attributes` define the generated `id`.
- **Tagging Conventions**: Additional tags and labels (via `tags` and `labels_as_tags`) appear in both module outputs and resource configurations.
- **Outputs**: The module outputs include key properties like `id`, `id_full`, `dns_name`, and `tags` that can be directly used in dependent Terraform configurations.

## Example Explanation

The DNS name example demonstrates how to use Terragrunt with this module. In the example:

- A Terragrunt configuration (in examples/dns_name/terragrunt.hcl) sets up local variables such as account ID, tenant, region, and domain details.
- The inputs block passes these values to the module, including naming conventions, regex filters, and tag configurations.
- The module is used in multiple files:
  - \_context.tf initializes the standard context required by the module.
  - dns.tf shows a simple module call that generates a DNS name based on your provided configuration.
  - \_outputs.tf outputs key properties such as the generated ID, DNS name, and format.

This setup allows you to test-deploy resources in a sandbox environment and clearly see how the module processes input variables to generate a consistent naming and tagging policy.

## Roadmap

- [ ] safely support arbitrary naming
  - [ ] all child resource modules contain ID business logic to transform any context-provided ID to resource-valid ID
    - [ ] automatically transform case and separators for resource-specific rules (e.g. S3 all lower-case)
    - [ ] automatically detect length violations and abbreviate or truncate segments to fit

This will be accomplished in all the other SevenPico L2 modules, then documented as a feature here.
Resources for this feature would include:

| AWS Resource               | Naming Constraints                                                                                                                                                                                                                                                                                                           |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **S3**                     | - Must be globally unique across AWS. <br> - Must be between 3 and 63 characters. <br> - Can contain lowercase letters, numbers, dots (.), and hyphens (-), but cannot start or end with a dot. <br> - Cannot contain underscores or uppercase letters. <br> - Must not be formatted like an IP address (e.g., 192.168.1.1). |
| **VPC**                    | - Between 1 and 255 characters. <br> - Can contain letters, numbers, spaces, and special characters (.\_:/=+-%@).                                                                                                                                                                                                            |
| **Subnet**                 | - Same as VPC: Between 1 and 255 characters. <br> - Can contain letters, numbers, spaces, and special characters (.\_:/=+-%@).                                                                                                                                                                                               |
| **Security Group**         | - Name must be unique within the VPC. <br> - Can contain up to 255 characters. <br> - Can contain letters, numbers, spaces, and special characters (.\_:/=+-%@).                                                                                                                                                             |
| **Network ACL**            | - Between 1 and 255 characters. <br> - Can contain letters, numbers, spaces, and special characters (.\_:/=+-%@).                                                                                                                                                                                                            |
| **API Gateway**            | - API ID is auto-generated. <br> - API name: Up to 128 characters, can contain letters, numbers, hyphens (-), and underscores (\_).                                                                                                                                                                                          |
| **IAM Role**               | - Must be unique within an AWS account. <br> - Can contain up to 64 characters. <br> - Can contain alphanumeric characters and the following special characters: =,.@-\_                                                                                                                                                     |
| **DynamoDB**               | - Must be unique within an AWS account and region. <br> - Can be between 3 and 255 characters. <br> - Can contain only letters, numbers, underscores (\_), hyphens (-), and dots (.).                                                                                                                                        |
| **RDS Database Instance**  | - Must be unique within an AWS account and region. <br> - Can be between 1 and 63 characters. <br> - Can contain only lowercase letters, numbers, and hyphens (-). <br> - Cannot start or end with a hyphen (-).                                                                                                             |
| **Redshift Serverless**    | - Namespace and Workgroup names: Between 3 and 64 characters. <br> - Can contain lowercase letters, numbers, and hyphens (-). <br> - Must start with a letter and cannot end with a hyphen (-).                                                                                                                              |
| **Lambda Function**        | - Up to 140 characters. <br> - Can contain only letters, numbers, hyphens (-), and underscores (\_).                                                                                                                                                                                                                         |
| **Step Function**          | - Must be unique within an AWS account and region. <br> - Can be between 1 and 80 characters. <br> - Can contain letters, numbers, hyphens (-), and underscores (\_).                                                                                                                                                        |
| **SQS Queue**              | - Standard Queue: Up to 80 characters. <br> - FIFO Queue: Must end with `.fifo` and can be up to 80 characters (including `.fifo`). <br> - Can contain alphanumeric characters, underscores (\_), and hyphens (-).                                                                                                           |
| **SNS Topic**              | - Must be unique within an AWS account and region. <br> - Can be between 1 and 256 characters. <br> - Can contain only letters, numbers, hyphens (-), and underscores (\_).                                                                                                                                                  |
| **EventBridge Rule**       | - Must be unique within an AWS account and region. <br> - Can be between 1 and 64 characters. <br> - Can contain only letters, numbers, hyphens (-), and underscores (\_).                                                                                                                                                   |
| **Bedrock Knowledge Base** | - Name must be unique within an AWS account and region. <br> - Can contain alphanumeric characters, underscores (\_), and hyphens (-). <br> - Maximum length of 64 characters.                                                                                                                                               |
| **Bedrock Agent**          | - Agent name must be unique within an AWS account. <br> - Can contain letters, numbers, underscores (\_), and hyphens (-). <br> - Maximum length of 64 characters.                                                                                                                                                           |

## Generated ID Explanation

The module constructs an id by normalizing and concatenating values from labels defined in `label_order` (e.g. "namespace", "environment", "stage", "name", "attributes") using the specified delimiter. For instance, if

- namespace = "7pi"
- stage = "prod"
- name = "app"
- attributes = ["public"]

Then the generated id becomes:  
 7pi-prod-app-public

Null or empty values are omitted during concatenation.

## Implementation Details

- The module standardizes all naming elements (namespace, stage, name, etc.) by normalizing and concatenating them using a hyphen (`-`) as the delimiter.
- To ensure AWS resource names (which generally have a 64-character limit) are not exceeded, SevenPico uses abbreviated values for general context (e.g., "7pi" for namespace).
- Abbreviations and normalization (e.g., lowercasing) ensure consistency and compliance with AWS restrictions on resource naming.
- The module supports nested contexts, allowing for chaining of configurations while preserving consistent naming and tagging conventions.
- Labels are optionally retained as tags in the generated output while ensuring no excessive length.
- When generating IDs in Pascal Case, setting `label_value_case` to "title" and `delimiter` to an empty string (`""`) will produce concatenated names without hyphens. However, since many AWS resources require lowercase names and enforce character limits, SevenPico recommends using kebab-case (hyphenated) to improve readability, avoid case-sensitivity issues, and comply with AWS constraints.

## Resource Enablement and Inheritance

- The module leverages the `module.context.enabled` flag along with `count` or `for_each` so that resources are only provisioned when needed. For example:

```hcl
resource "aws_instance" "example" {
  count = module.context.enabled ? 1 : 0
  instance_type = "t2.micro"
  # ...other attributes...
}
```

- When `enabled` is set to `false`, the resource count becomes zero, effectively destroying or preventing creation of the resource.

- Additionally, attributes like `enabled` are inherited via the parent context available as `module.context.self`, so nested modules automatically receive the parent's configuration and resource enablement settings.

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
