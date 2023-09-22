# Terraform Beginner Bootcamp 2023

## Semantic Versioning :mage:

This project is going to utilize semantic versioning for its tagging.
[semver.org](https://semver.org/)

The general format:

 **MAJOR.MINOR.PATCH**, eg. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Install Terraform CLI

###Consideration with the Terraform CLI changes
The Terraform CLI installation instructions have changed due to gpg keyring changes. So we needed refer to the latest install CLI instructions via Terraform Documentation and change the scripting for install.
[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Considerations for Linux distribution

This project is built against Ubuntu.
Please consider checking your Linux distribution and change accordingly to distribution needs.

[How to check Linux distribution in Linux](https://www.tecmint.com/check-linux-os-version/)

Example of checking OS version
```
$ cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### Refactoring into Bash scripts

While fixing the Terraform CLI gpg deprecation issues we notice that bash scripts steps were a considerable amount more code. So we decided to create a bash script to install the Terraform CLI.

This bash script is located here: [./bin/install_terraform_cli](./bin/install_terraform_cli)

- This will keep the Gitpod Task File ([.gitpod.yml](.gitpod.yml))tidy.
- This allow us an easier time to debug and execute Terraform CLI installation manually
- This will allow better portability for other projectsa that need to install Terraform CLI


### Shebang

A Shebang (pronounced Sha-bang) tells the bash script what program that will interpret the script. eg. `#!/bin/bash`

ChatGPT recommended this format for bash: `#!/usr/bin/env bash`

- For portability for different OS distributions
- Will search the user's PATH for the bash executable.

[Wikipedia on Shebang](https://en.wikipedia.org/wiki/Shebang_(Unix))

#### Execution considerations

When executing the bash script we can use the `./` shorthand notation to execure the bash script.

eg. `./bin/install_terraform_cli`

If we are using a script in gitpod.yml we need to point the script to a program to interpret it

eg. `source ./bin/install_terraform_cli`

#### Linux permission considerations

[chmod in wikipedia](https://en.wikipedia.org/wiki/Chmod)

In order to make our bash scripts executable, we need to change linux permission for the fix to be executable at the user mode.
```
chmod u+x ./bin/install_terraform_cli
```

Alternatively:

```
chmod 744 ./bin/install_terraform_cli
```

### Gitpod Lifecycle (Before, Init, Command)

We need to be careful when using the `Init` because it will not rerun if we restart an existing workspace.

https://www.gitpod.io/docs/configure/workspaces/workspace-lifecycle

### Working Env Vars

We can list out all Environment Variables (Env Vars) using the `env`

We can filter specific env vars using grep eg. `env | grep AWS_`

#### Setting and Unsetting Env Vars

In the terminal we can set using `export Hello='world'`

In the terminal we can usset using `unset Hello`

We can set an env var temporarily when just running a command

```sh
Hello='world' ./bin/print_message
```

Within a bash script we can set env without writing export eg.

```sh
#!/usr/bin/env bash

HELLO='world'

echo $HELLO
```

#### Printing Env Vars

We can print an env var using echo eg. `echo $HELLO`

#### Scoping of Env Vars

When you open up bash terminals in VSCode it will not be aware of env vars that you have set in another window.

If you want to env vars to persist across all future bash terminals that are open, you need to set env vars in your bash profile. eg `.bash_profile`

#### Persisting Env Vars in Gitpod

We can persist env vars in Gitpod by storing them in Gitpod Secrets Storage

```
gp env HELLO='world*
```

All future workspaces launched will set env vars for all bash terminals opened in those workspaces.

You can also set env vars in the `.gitpod.yml` but this can only contain non-sensitive env vars.


### AWS CLI Installation

AWS CLI is installed for the project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

[How to configure AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can chack if our AWS credentials are configured correctly by running the following AWS CLI command: 
```sh
aws sts get-caller-identity
```

If it is succesful, you should see a json payload return that looks like this:

```json
{
    "UserId": "AIDABERC5CT4SE615WLHH",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/terraform-beginner-bootcamp"
}
```

We'll need to generate AWS CLI credits from IAM User in order to the use AWS CLI.