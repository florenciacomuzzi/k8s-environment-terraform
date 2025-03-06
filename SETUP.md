# florenciacomuzzi-site-terraform
This repository contains Terraform code to create a Linode instance and deploy a website to it.
The infrastructure is managed using Hashicorp Terraform Cloud. 
Deployments are triggered from GitHub Actions workflows.

## Setting up your own project

### GCP
* Login to GCP account.
* Create a service account like `k8s-environment-terraform-cicd` to use for CICD.
* Create a service account JSON file.
* Add as a repository secret by going to Settings > Secrets and variables > Actions. Name it GCP_CREDENTIALS and paste in the credentials JSON.
* Create the buckets for Terraform state like `prod-tf-state-bucket`. The bucket names are specified in the `backend/{env}.tfvars` file.

### Linode
* Login to Linode account. 
* Create a personal access token. This secret is the value of "token" input variable of the Terraform module.

### Terraform Cloud
* Login to Terraform Cloud.
* Create an organization like "mysite-org".
* Create a Team Token scoped to owners. This secret is the value of TF_API_TOKEN used by GitHub Actions to authenticate to Hashicorp Terraform Cloud.
* Create a variable set called "MYSITE__PRODUCTION".
* Add the following variables to the set:
  * khj
* Create a project like "mysite-site".
* Create a workspace like "production".
* In the workspace, create a workspace variable called "token" with the value of the Linode Personal Access Token.
* Go back to the organization-level variable set you created previously and apply to the workspace specifically.

### GitHub
* Clone this repository. Name it like "mysite-site-terraform".
* Create a TF_API_TOKEN repository secret by going to Settings > Secrets and variables > Actions. This secret is used by GitHub Actions to authenticate to Hashicorp Terraform Cloud during runs.
* Change the values of TF_CLOUD_ORGANIZATION and TF_WORKSPACE in .github/workflows/terraform-apply.yml and .github/workflows/terraform-plan.yml.


You should now be able to run the terraform-apply and terraform-plan workflows via CICD. terraform-plan runs on pull request events, and terraform-apply runs on push events to the main branch.

## Making changes to your infrastructure
1. To make changes to the Linode instance, check out a feature branch based on main like "feature/my-changes", make the changes and push them to the feature branch, then create a pull request. 
Terraform Cloud will run terraform-plan on the pull request.
2. Once you are satisfied with the terraform plan to make changes to the Linode instance, merge the pull request, and Terraform Cloud will run terraform-apply.