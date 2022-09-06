# Commands

Init modules

    terraform init --backend-config="container_name=projecttwo" --backend-config="key=dev.tfstate"

Validate
    
    terraform validate

Plan

    terraform apply --var="client_name=wj" --var="project_name=two" --var="env=dev" --var="deploy_networking=true"  --var="deploy_databricks=true" --var="deployer_ip_address=83.22.134.246"

Apply

    terraform apply --var="client_name=wj" --var="project_name=two" --var="env=dev" --var="deploy_networking=true"  --var="deploy_databricks=true" --var="deployer_ip_address=83.22.134.246"

Apply (all options)    
    terraform apply 
        --var="client_name=wj" 
        --var="project_name=two"
        --var="env=dev"
        --var="deploy_networking=true"
        --var="deploy_synapse=true"
        --var="deploy_data_factory=true"
        --var="deploy_databricks=true"
        --var="deploy_purview=true"
        --var="deployer_ip_address=83.22.134.246"

Format

    terraform fmt --recursive

Destroy

    terraform destroyy --var="client_name=wj" --var="project_name=two" --var="env=dev" --var="deploy_networking=true"  --var="deploy_databricks=true" --var="deployer_ip_address=83.22.134.246"