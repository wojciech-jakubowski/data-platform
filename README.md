# Commands

Init modules

    terraform init --backend-config="container_name=projecttwo" --backend-config="key=dev.tfstate"

Validate
    
    terraform validate

Plan

    terraform plan --var="clientName=wj" --var="projectName=two" --var="env=dev"

Apply

    terraform apply --var="clientName=wj" --var="projectName=two" --var="env=dev"

Format

    terraform fmt --recursive