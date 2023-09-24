# Terraform Beginner Bootcamp 2023 - Week 1

## Root Module Structure

Our root module structureis as follows:

```
PROJECT_ROOT
|
├── main.tf           # everything else
├── variables.tf      # stores the structure of input variables
├── terraform.tfvars  # the data of variables we want to load into our terraform project
├── providers.tf      # defines required providers and their configuration
├── outputs.tf        # stores the outputs
└── README.md         # required for root modules
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input variables

### Terraform Cloud Variables

In Terraform we can set two kind of variables:
- Environment Variables -those you would set in your bash terminal eg. AWS credentials
- Terraform Variables - those that you would normally set in your tfvars file

We can set Terraform Cloud variables to be sensitive so they are not shown visibly in the UI.

### Loading Terraform Input Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

### var flag
- Use `-var` flag to set an input variable or override a variable in the tfvars file eg. `terraform -var user_ud="my-user_id"`

### var-file flag

- Specify one or more variable files that contain variable values for a Terraform configuration.  eg

```
terraform apply -var-file=FILENAME.tfvars
```

### terraform.tffars

This is the default file to load in terraform variables in bulk

### auto.tfvars

- File that allows you to automatically load variable values without specifying the -var-file flag when running Terraform commands. eg

```
# Contents of auto.tfvars
user_uuid = "123e4567-e89b-12d3-a456-426655440000"

```

Be cautious when using auto.tfvars for sensitive or environment-specific information, as this file might be version-controlled along with your Terraform configuration


### order of terraform variables

- The precedence order, from highest to lowest, is as follows:
1. Command Line Flags (-var and -var-file)
2. Environment Variables (TF_VAR_*)
3. Variable Files (-var-file)
4. Default Values in Configuration (default in variable declaration)
5. Auto-Loaded auto.tfvars
6. Variable Overrides in Configuration

## Dealing With Configuration Drift

## What happens if we lose our state file?

If you lose your statefile, you most likely have to tear down all your cloud infrastructure manually.

You can use terraform import but it won't work for all cloud resources. You need check the terraform providers documentation for which resources support import.

### Fix Missing Resources with Terraform Import

`terraform import aws_s3_bucket.bucket bucket-name`

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)
[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

### Fix Manual Configuration

If someone goes and delete or modifies cloud resource manually through ClickOps. 

If we run Terraform plan is with attempt to put our infrstraucture back into the expected state fixing Configuration Drift