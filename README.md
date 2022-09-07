# Commands

## Init

Azure AD auth

    terraform init --backend-config="container_name=projecttwo" --backend-config="key=dev.tfstate" 

With access key

    terraform init --backend-config="access_key=xxxyyy" --backend-config="container_name=one" --backend-config="key=dev.tfstate"

## Validate
    
    terraform validate

## Plan

    terraform plan --var="client_name=wj" --var="project_name=one" --var="env=dev" --var="deployer_ip_address=83.22.134.246" --var="deployer_email=xxx.yyy@outlook.com" --var="deploy_data_factory=true" --var="deploy_databricks=true"

## Apply

    terraform apply --var="client_name=wj" --var="project_name=one" --var="env=dev" --var="deployer_ip_address=83.22.134.246" --var="deployer_email=xxx.yyy@outlook.com" --var="deploy_data_factory=true" --var="deploy_databricks=true"

## Apply (all options)    
    terraform apply 
        --var="client_name=wj" (required)
        --var="project_name=two" (required)
        --var="env=dev" (required)
        --var="deployer_ip_address=83.22.134.246" (required)
        --var="deployer_email=xxx.yyy@outlook.com" (required)
        --var="deploy_networking=true" (optional)
        --var="deploy_synapse=true" (optional)
        --var="deploy_data_factory=true" (optional)
        --var="deploy_databricks=true" (optional)
        --var="deploy_purview=true" (optional)
        --var="existing_rg_name=some_exisiting_rg" (optional)

## Format

    terraform fmt --recursive

## Destroy

    terraform destroy --var="client_name=wj" --var="project_name=one" --var="env=dev" --var="deployer_ip_address=83.22.134.246" --var="deployer_email=xxx.yyy@outlook.com" --var="deploy_data_factory=true" --var="deploy_databricks=true"