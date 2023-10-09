# Terraform Beginner Bootcamp 2023 - Week 1

## Fixing tags on git

[How to delete local and remote tags on git](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

Locally delete a tag 
```
git tag -g <tag-name>
```

Remotely delete tag
```
git push --delete origin <tag-name>
```

Checkout the commit that you want to retag. Grab the sha from your Github history

```
git checkout <SHA>
git tag M.M.P
git push --tags
git checkout main
```


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

## Terraform Modules

### Terraform Module Structure

It is recommend to place modules in a `modules` directory when locally developing modules but you can name it whatever you like.

### Passing Input Variables

We can pass input variables to our module.

The module has to declare the terraform variables in its own variables.tf

```tf
module "terrahome_aws" {
  source = "./modules/terrahome_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Modules Sources

Using the source we can import the module from various places eg:
- locally
- Github
- Terraform Registry

```tf
module "terrahome_aws" {
  source = "./modules/terrahmse_aws"
}
```

[Modules Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

## Considerations when using ChatGPT to write Terraform

LLMs such as ChatGPT may not be trained on the latest documentation or information about Terraform.

It may produce older examples that could be deprecated. This is most often affecting providers.

## Working with Files in Terraform

### Fileexists function

This is a built in terraform function to check the existance of a file.

```tf
condition = fileexists(var.error_html_filepath)
```

https://developer.hashicorp.com/terraform/language/functions/fileexists

### Filemd5

https://developer.hashicorp.com/terraform/language/functions/filemd5

### Path Variable

In terraform there is a special variable called `path` that allows us to reference local paths:
- path.module = get the path for the current module
- path.root = get the path for the root module
[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)


resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"
}

## Terraform Locals

Locals allows us to define local variables.

It can be very useful when we need to transform data into another format and have referenced a variable.

```
locals {
  service_name = "forum"
  owner        = "Community Team"
}
```

[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

## Terraform Data sources

This allows us to source data from cloud resources.

This is useful when we want to reference cloud resources without importing them.

```
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

## Working with Json

We use jsonencode to create json policy inline in the hcl

```tf
jsonencode({"hello"="world"})
{"hello":"world"}
```



[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

## Changing the Lifecycle of Resources


[Meta-Arguments Lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

## Terraform Data

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

[](https://developer.hashicorp.com/terraform/language/resources/terraform-data)

## Provisioners

Provisioners allow you to execute commands on compute instances eg. AWS CLI command.

They are not recommended for use by Hashicorp, because Configuration Management tools such as Ansible are a better fit, but the functionality still exists.

[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

### Local-exec

This will execute a command on the machine running terraform commands eg. plan apply

```tf
resource "aws_instance" "web" {
  # ...
  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}
```

[local-exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)

### Remote-exec

This will execute command on machine which you target. You need to provide credentials such as ssh to get into the machine.

```tf
resource "aws_instance" "web" {
  # ...
  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```
[remote-exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec)

## For Each Expressions

For each allows us to enumerate over complex data types

```sh
[for s in var.list : upper(s)]
```

This is mostly useful when you are creating multiples of a cloud resource and you want to reduce the amount of repetitive terraform code.

[For Each Expressions](https://developer.hashicorp.com/terraform/language/expressions/for)