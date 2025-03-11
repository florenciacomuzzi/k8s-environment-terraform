# k8s-environment-terraform
This repository contains Terraform code to create a VPC and various types of Kubernetes clusters in 
GKE. GitHub Actions workflows are used to deploy the infrastructure to GCP. Terraform state is stored
in Cloud Storage. This repository supports two environments: `dev` and `prod`. Each environment points to
a different branch, `develop` and `main`, respectively. It assumes that both environments contain the
same resources with some variation in the configuration.


## Setting up your own project
Maintainers need to set up configuration in both GCP and GitHub.

### GCP
* Login to GCP account.
* Create a service account like `k8s-environment-terraform-cicd` to use for CICD. For this example,
the CICD service account is `k8s-environment-terraform-cicd@florenciacomuzzi.iam.gserviceaccount.com`. 
Go to Cloud Console > IAM & Admin > Service Accounts > CREATE SERVICE ACCOUNT.
* Click on the new service account on the dashboard > Keys > Add key. This will download a service 
 account JSON file which will be used by GitHub Actions.
* Add roles to the CICD service account. Go to Cloud Console > IAM & Admin > IAM > search for the
service account > Edit principal (the pencil icon on the right of the service account) > Add role:
  * Compute Network Admin
  * Kubernetes Engine Cluster Admin
  * Compute Security Admin
  * Create Service Accounts
  * Delete Service Accounts
  * Service Account User
  * Project IAM Admin
* Create two buckets for Terraform state like `prod-tf-state-bucket`. The bucket names are specified 
in the `backend/{env}.tfvars` file. Go to Cloud Storage > Create bucket. You can use the default 
bucket settings. Prevent public access.
* Allow the CICD service account access to the buckets. For each bucket, go to the bucket > 
Permissions > Add Member > Service Account > search for the service account > Role > 
  * Storage Object Admin
* Enable the following APIs if not enabled. You will need 
[Owner](https://cloud.google.com/service-usage/docs/access-control#basic_roles) access to the project.
  * Compute Engine API
  * Kubernetes Engine API
  * Cloud Resource Manager API
* Allow the CICD service account access to the default Compute Engine service account 
like `454824995744-compute@developer.gserviceaccount.com`. Go to IAM & Admin > Service Accounts > 
`{project-number}-compute@developer.gserviceaccount.com` > Permissions > Grant Access > {cicd service account email} > Role > ServiceAccountUser
  * You can find your project number by going to Cloud Console > Cloud overview > Dashboard.
* Increase the quota for 
  * Depending on the size of your clluster, you may need to increase the quota for  various 
resources. For example, you may need to increase the quota for Persistent Disk SSD (GB) in the 
cluster region `us-east1`. Go to Cloud Console > IAM & Admin > Quotas. Find the quota for Persistent 
Disk SSD (GB) in `us-east1` and Edit quota. Increase to some number of GB as appropriate.

### GitHub
* Go to this repository in GitHub > Use this template > Create a new repository. Give the repository
a name like `gke-private-cluster-terraform` depending on what you are going to create in the environments.
* Add as a repository secret by going to Settings > Secrets and variables > Actions. Name it GCP_CREDENTIALS and paste in the credentials JSON.
* Change the values of TF_CLOUD_ORGANIZATION and TF_WORKSPACE in .github/workflows/terraform-apply.yml and .github/workflows/terraform-plan.yml.


You should now be able to run the terraform-apply and terraform-plan workflows via CICD. terraform-plan runs on pull request events, and terraform-apply runs on push events to the main branch.

## Making changes to your infrastructure
1. To make changes to the Linode instance, check out a feature branch based on main like "feature/my-changes", make the changes and push them to the feature branch, then create a pull request. 
Terraform Cloud will run terraform-plan on the pull request.
2. Once you are satisfied with the terraform plan to make changes to the Linode instance, merge the pull request, and Terraform Cloud will run terraform-apply.