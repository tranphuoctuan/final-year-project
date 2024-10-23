MAKEFLAGS+=--silent

Env=$(shell cat .env)

.PHONY: all init validate plan apply

all:
	make init
	make validate
	make apply

init:
	make _purge
	make _config
	terraform init -backend-config=backend.tfvars

validate:
	tflint
	terraform validate
	terraform fmt --recursive

plan:
	terraform plan 

apply:
	terraform apply

destroy:
	terraform destroy

# Private
.PHONY: _purge _config

_purge:
	echo "purge step"

_config:
	cp config/terraform-$(Env).tfvars terraform.tfvars
	cp config/backend-$(Env).tfvars backend.tfvars
