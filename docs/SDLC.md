# Software Development Lifecycle
Audience: **Developers**

Terraform is a HashiCorp tool that enables you to predictably create, change, and improve your cloud
infrastructure by using code. This solution predictably makes changes to infrastructure. 

GitHub branches—develop and main—represent actual environments. These Environments are defined by 
Virtual Private Cloud (VPC) networks and a GKE cluster into a Google Cloud project. In our project, 
VPCs and GKE clusters are created by Terraform.

Ideally, either developers or operators must make infrastructure proposals to non-protected branches
and then submit them through pull requests. A push to a branch automatically 
triggers the build jobs and logs the terraform plan reports. This way, you can discuss and review 
the potential changes with collaborators and add follow-up commits before changes are merged into the base branch.

If no concerns are raised, you must first merge the changes to the `develop` branch. This merge triggers 
an infrastructure deployment to the `dev` environment, allowing you to test this environment. After 
you have tested and are confident about what was deployed, you must merge the `develop` branch into the 
prod branch to trigger the infrastructure installation to the production environment.

The process starts when you push Terraform code to either the `develop` or `main` branch. In this scenario, 
GitHub Actions are triggered and then Terraform manifests applied to achieve the state you want in the 
respective environment. On the other hand, when you push Terraform code to any other branch—for 
example, to a feature branch—GitHub Actions runs to execute terraform plan, but nothing is applied to 
any environment.

A single Git repository is used to define your cloud infrastructure. You orchestrate this 
infrastructure by having different branches corresponding to different environments:

* The `develop` branch contains the latest changes that are applied to the development environment.
* The `main` branch contains the latest changes that are applied to the production environment.

With this infrastructure, you can always reference the repository to know what configuration is 
expected in each environment and to propose new changes by first merging them into the `dev` 
environment. You then promote the changes by merging the `develop` branch into the subsequent `main`
branch.

**To get started, create a repository from this template repository.**

The code in this repository is structured as follows:

* The `modules/` folder contains inline Terraform modules. These modules represent logical groupings 
of related resources and are used to share code across different environments.
* The `variables/` folder contains the values used for each environment.


The `.github/workflows/terraform.yml` file is a CICD configuration file that contains instructions 
for GitHub Actions, such as how to perform tasks based on a set of steps. This file specifies a 
conditional execution depending on the branch GitHub Actions is fetching the code from, for example:

For `develop`, `uat`, and `main` branches, the following steps are executed:

1. `terraform init`
2. `terraform plan`
3. `terraform apply`

For any other branch, the following steps are executed:

* `terraform init` for all environments subfolders
* `terraform plan` for all environments subfolders

To ensure that the changes being proposed are appropriate for every environment, `terraform init` and 
`terraform plan` are run for all environments subfolders. Before merging the pull request, you can 
review the plans.

### Storing state in a Cloud Storage bucket
By default, Terraform stores state locally in a file named `terraform.tfstate`. This default 
configuration can make Terraform usage difficult for teams, especially when many users run 
Terraform at the same time and each machine has its own understanding of the current infrastructure.

To help avoid such issues, this repo configures a remote state that points to a Cloud Storage bucket.
Remote state is a feature of backends and is configured in the `backend.tf` files.

### Granting permissions to your CICD service account
To allow the CICD service account to run Terraform scripts with the goal of managing Google Cloud 
resources, you need to grant it appropriate access to your project. You will also need to grant 
permissions to the service account.

For information on CICD, refer to the
[CICD](https://github.com/florenciacomuzzi/k8s-environment-terraform/blob/main/docs/SETUP.md) 
documentation.

### Changing your environment configuration in a new feature branch
By now, you have most of your environment configured. So it's time to make some code changes in your 
development environment.

* Checkout a branch based on main.
* Make a change to a file.
* Commit the change with a message like "GitHub Actions pipeline prints debug info"
* Push the change.
* Open a merge request in GitHub.

Don't merge your pull request yet.

Note that GitHub Actions ran the pipeline. As discussed previously, this pipeline has different 
behaviors depending on the branch being fetched. The build steps into the appropriate environment 
folder and executes `terraform plan` for that environment. GitHub Actions only executes 
`terraform plan` for the environment to make sure that the proposed change is appropriate for it when there is a push to a 
feature branch. If this plan fails to execute, the build fails.

Similarly, the `terraform apply` command runs for environment branches, but it is completely ignored 
in any other case. In this section, you have submitted a code change to a new branch, so no 
infrastructure deployments were applied to your Google Cloud project.


### Promoting changes to the development environment
You have a pull request waiting to be merged. It's time to apply the state you want to your `dev` 
environment. 

* Merge your code.
* Open the build and check the logs.
* When the build finishes, you should see if changes were successfully applied or not.

### Promoting changes to the production environment
Now that you have your development environment fully tested, you can promote your infrastructure 
code to production. 

* Open a merge request from `develop` to `main`.
* Review the proposed changes, including the `terraform plan` details from GitHub Actions, and then 
merge the code.
* In your repository in the GitHub console, open the **Actions** page to see your changes being applied to the 
production environment.
* Wait until the build completes. Wait for the build to finish, and then check the logs. At the end 
of the logs, you will see whether the build passed or failed.

You have successfully configured a serverless infrastructure-as-code pipeline on GitHub Actions.
