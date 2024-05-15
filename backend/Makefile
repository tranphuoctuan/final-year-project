Env=$(shell cat ../.env)

.PHONY: all init validate plan apply

all:
	make init
	make validate
	make apply

init:
	make _config
	terraform init
	terraform workspace new $(Env) || true
	terraform workspace select $(Env)

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
.PHONY: _config

_config:
	# Comment below line if you want to re-config the backend
	# ! [ -f ../config/backend-$(Env).tfvars ]
	rm -f terraform.tfvars
	for var in \
		profile \
		environment \
		region \
	; do \
		grep $$var ../config/terraform-$(Env).tfvars >> terraform.tfvars; \
	done
