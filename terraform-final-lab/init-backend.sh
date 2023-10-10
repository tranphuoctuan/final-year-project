#!/bin/bash

# init dev
terraform init -reconfigure -backend=true -backend-config="bucket=final-lab-st-tuantran2-bucket-tfstate" -backend-config="key=terraform.tfstate" -backend-config="region=ap-southeast-1" -backend-config="profile=dev-tuantran2"

# init stg
# terraform init -reconfigure -backend=true -backend-config="bucket=stpp-stg-terraform-tfstate" -backend-config="key=terraform.tfstate" -backend-config="region=ap-southeast-1" -backend-config="stg-tuantran2"

# # init prod 
# terraform init -reconfigure -backend=true -backend-config="bucket=stpp-prod-terraform-tfstate" -backend-config="key=terraform.tfstate" -backend-config="region=ap-southeast-1" -backend-config="profile=prod-tuantran2"