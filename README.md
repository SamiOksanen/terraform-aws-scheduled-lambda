# Terraform AWS Scheduled Lambda Example 🛠

This is an example on how to make a Terraform setup to create a scheduled AWS Lambda which is called once an hour by AWS CloudWatch Event.
The lambda function itself is made with TypeScript.
The setup includes use of environment variables which are passed to the lambda function.

## Setup 🪄

### Install:
- Node.js
- AWS CLI
- The Terraform CLI (1.2.0+)

### Authenticate the Terraform AWS provider
- Create Access Keys for your AWS IAM user (https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
- Set IAM credential environment variables:
  - `export AWS_ACCESS_KEY_ID=<Your IAM user access key id>`
  - `export AWS_SECRET_ACCESS_KEY=<Your IAM user secret access key>`

### Install dependencies
```bash
npm i
```

### Required environment variables
Add a `.env` file at the root of the repo, by copying the `.env.example` file.
Set values to the environment variables in the `.env` file

## Deployment 🚚
```bash
npm run build
cd terraform
terraform init
env $(sed -e 's/^/TF_VAR_/' ../.env) terraform plan -out=terraform.plan
terraform apply terraform.plan
```

## Cleanup 🧹
```bash
terraform destroy
```

## Helpful Resources 🫡
https://registry.terraform.io/providers/hashicorp/aws/latest/docs \
https://docs.aws.amazon.com/lambda/latest/dg/lambda-typescript.html \
https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html \
https://esbuild.github.io/getting-started/#bundling-for-node
