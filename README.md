# AZURE DRUPAL AKS SAMPLE

This project was created for DrupalGovCon 2024 and has the intent of providing a demo of Azure Pipelines, Docker, AKS, and Helm in order to demo the ability to quickly build up a containerized Drupal environment within Azure Kubernetes Service and a basic CI/CD pipeline using Azure DevOps Pipelines product. 

# PREREQUISITES

The following items are required in order to do most of the tasks within this repository:

Docker - https://docs.docker.com/engine/install/
Azure CLI - https://learn.microsoft.com/en-us/cli/azure/install-azure-cli
Azure Subscription - https://portal.azure.com/#home
Azure DevOps Organization - https://dev.azure.com

# RESOURCE DEPLOYMENT

There are lots of ways to create resources within Azure -- Terraform, Ansible, Azure ARM Templates, and manually via the portal to name a few. I personally prefer Terraform, but any of these options will work for creating your AKS Cluster and most include a way to create infrastructure with code and maintain a state if built correctly. 

Quickstart guides for these: 
Terraform - https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-terraform?pivots=development-environment-azure-cli
Azure RM - https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-rm-template?tabs=azure-cli

# LOCAL DEVELOPMENT

This demo gives you the ability to build up and tear down a local development environment quickly and easily utilizing public Drupal, Nginx and MySQL container definitions. Once cloned, simply navigate to the repo root and use docker compose to start the environment:

`docker-compose up -d`

and similar the environment can be taken down by

`docker-compose down`

# AZURE PIPELINES

To create an Azure DevOps Pipeline simply log in to the Azure DevOps Organization, go to Pipelines, Press "New Pipeline", Connect to your code repository, select "Existing Azure Pipelines YAML File", and select your pipeline.yml from the dropdown. 

The sample_pipeline.yml shows an example pipeline that utilizes Service Connections to connect to the Docker ACR and Azure AKS cluster. Then builds your container images based off of your Dockerfile, and pushes them to the ACR. Then the worker installs and utilizes helm to run a `helm upgrade` in order to deploy to your cluster. 

# TO CONTINUE

This project was intended to function as a reference and a jumping off point to help people get started utilizing some of these features and gain some familiarity, but continuing development of the Dockerfile to add composer, static file storage, and a volume mount into the helm chart in order to host static files.

A DB Service is also recommended to connect to 