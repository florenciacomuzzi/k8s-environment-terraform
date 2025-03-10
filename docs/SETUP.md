# k8s-environment-terraform
This repository contains Terraform code to create a Linode instance and deploy a website to it.
The infrastructure is managed using Hashicorp Terraform Cloud. 
Deployments are triggered from GitHub Actions workflows.

## Setting up your own project

### [Owners] GCP
* Login to GCP account.
* Create a service account like `k8s-environment-terraform-cicd` to use for CICD.
* Create a service account JSON file.
* Create the buckets for Terraform state like `prod-tf-state-bucket`. The bucket names are specified in the `backend/{env}.tfvars` file.
* Go to the bucket > Permissions > Add Member > Service Account > k8s-environment-terraform-cicd@florenciacomuzzi.iam.gserviceaccount.com > Role > 
  * Storage Object Admin
  * Compute Network Admin
  * Kubernetes Engine Cluster Admin
  * Compute Security Admin
  * Create Service Accounts
  * Delete Service Accounts
  * Service Account User
  * Project IAM Admin
* Enable the following APIs if not enabled. You will need [Owner](https://cloud.google.com/service-usage/docs/access-control#basic_roles) access to the project.
  * Compute Engine API
  * Kubernetes Engine API
  * Cloud Resource Manager API
* Allow the CICD service account access to the default Compute Engine service account 
like `454824995744-compute@developer.gserviceaccount.com`. Go to IAM & Admin > Service Accounts > 
`{project-number}-compute@developer.gserviceaccount.com` > Permissions > Grant Access > {cicd service account email} > Role > ServiceAccountUser
  * You can find your project number by going to Cloud Console > Cloud overview > Dashboard.
* Increase the quota for 
  * Persistent Disk SSD (GB) in us-east1 by going to Cloud Console > 
IAM & Admin > Quotas. Find the quota for Persistent Disk SSD (GB) in us-east1 and Edit quota. Increase to 1000 GB.
  * In-use regional external IPv4 addresses in us-east1 to 15

### GitHub
* Clone this repository. Name it like "mysite-site-terraform".
* Add as a repository secret by going to Settings > Secrets and variables > Actions. Name it GCP_CREDENTIALS and paste in the credentials JSON.
* Change the values of TF_CLOUD_ORGANIZATION and TF_WORKSPACE in .github/workflows/terraform-apply.yml and .github/workflows/terraform-plan.yml.


You should now be able to run the terraform-apply and terraform-plan workflows via CICD. terraform-plan runs on pull request events, and terraform-apply runs on push events to the main branch.

## Making changes to your infrastructure
1. To make changes to the Linode instance, check out a feature branch based on main like "feature/my-changes", make the changes and push them to the feature branch, then create a pull request. 
Terraform Cloud will run terraform-plan on the pull request.
2. Once you are satisfied with the terraform plan to make changes to the Linode instance, merge the pull request, and Terraform Cloud will run terraform-apply.