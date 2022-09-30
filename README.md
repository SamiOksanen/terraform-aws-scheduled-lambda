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
Add a `.env` file at the lambda directory of the repo, by copying the `.env.example` file.
Set values to the environment variables in the `.env` file

## Deployment 🚚
```bash
cd lambda
npm run build
cd ../terraform
terraform init
env $(sed -e 's/^/TF_VAR_/' ../lambda/.env) terraform plan -out=terraform.plan
terraform apply terraform.plan
```

## Cleanup 🧹
```bash
terraform destroy
```

## Optional but Recommended - Use AWS S3 Bucket to store Terraform state remotely
It is recommended that you store your terraform configuration state somewhere remotely especially when multiple people work together.
The `terraform_remote_state` directory uses AWS S3 Bucket to store the state remotely unlike the `terraform` directory which only stores the state locally.
To use remote state storing: 
- Create an S3 Bucket on your AWS account and change the bucket name in `terraform_remote_state/main.tf` file to match your bucket's name.
  - Enable versioning for the Bucket, to easier rollbacks if needed.
- Make sure all the people that need to be able to modify Terraform configuration have access to the remote state by adding the following IAM permissions for their IAM Users or Group:
  - `s3:ListBucket` on `arn:aws:s3:::YOUR_BUCKET`
  - `s3:GetObject` on `arn:aws:s3:::YOUR_BUCKET/path/to/your/key`
  - `s3:PutObject` on `arn:aws:s3:::YOUR_BUCKET/path/to/your/key`
  - `s3:DeleteObject` on `arn:aws:s3:::YOUR_BUCKET/path/to/your/key`
- And of course, deployment from `terraform_remote_state` directory (`cd ../terraform_remote_state` instead of `cd ../terraform`)

## Helpful Resources 🫡
https://registry.terraform.io/providers/hashicorp/aws/latest/docs \
https://docs.aws.amazon.com/lambda/latest/dg/lambda-typescript.html \
https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html \
https://esbuild.github.io/getting-started/#bundling-for-node
