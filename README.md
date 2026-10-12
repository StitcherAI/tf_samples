# tf_samples

Examples of using the StitcherAI TF modules to setup access for reading and writing data from StitcherAI.

These samples reference the public module repository `StitcherAI/tf-modules` via `source = "git::https://github.com/StitcherAI/tf-modules.git//<cloud>/<module>"`. The source uses HTTPS against the public repo, so `terraform init` only needs `git` installed — no GitHub SSH key or authentication is required.

## Getting Started

1. **Prerequisites**
   - Terraform >= 1.3 and `git` installed. The module `source` uses public HTTPS (`git::https://github.com/StitcherAI/tf-modules.git//...`), so no GitHub SSH key or auth is needed.
   - The cloud CLI for your provider, authenticated against the account/subscription/project you are granting access in:
     - AWS: `aws` CLI with credentials (the `aws` provider reads them from the environment).
     - Azure: `az login` (the `azurerm` and `azuread` providers read credentials from the Azure CLI).
     - GCP: `gcloud auth application-default login` (or `GOOGLE_APPLICATION_CREDENTIALS`).
     - Databricks: the Databricks CLI, logged in as an identity that is an account admin, a metastore admin, and a workspace admin of the target workspace. The `system.billing`, `system.compute`, `system.lakeflow`, and `system.access` schemas must be enabled on the metastore. The sample grants the StitcherAI service principal read access to the billing, compute, and Lakeflow schemas and to the `system.access.workspaces_latest` table, and only a metastore admin can grant that access.

       If Databricks created your metastore automatically, which is the default for workspaces created after November 8, 2023, the metastore has no metastore admin and the apply fails with `User does not have MANAGE on Catalog 'system'`. An account admin can [assign a metastore admin](https://docs.databricks.com/aws/en/data-governance/unity-catalog/manage-privileges/admin-privileges#assign-a-metastore-admin) in the account console under **Catalog**, then the metastore name, then **Metastore Admin**. Databricks recommends assigning the role to a group.

       Account admin does not include workspace admin. Without it, the apply fails with `ServicePrincipals is only accessible by admins` and `is not authorized to create SQL Endpoint`. An account admin can assign workspace admin in the account console under **Workspaces**, then the workspace name, then **Permissions**.

       Create one CLI profile for the workspace and one for the account console:
       ```sh
       databricks auth login --host <WORKSPACE-URL> --profile stitcherai-workspace
       databricks auth login --host <ACCOUNT-CONSOLE-URL> --account-id <ACCOUNT-ID> --profile stitcherai-account
       ```

       `<ACCOUNT-CONSOLE-URL>` depends on the cloud that hosts your Databricks account:
       - AWS: `https://accounts.cloud.databricks.com`
       - Azure: `https://accounts.azuredatabricks.net`
       - GCP: `https://accounts.gcp.databricks.com`

2. **Values StitcherAI provides you.** Get these from StitcherAI before you start; they are the inputs marked "(Provided by StitcherAI)" in the variables:

   | Cloud | Value(s) StitcherAI provides | Shape / example |
   |-------|------------------------------|-----------------|
   | AWS   | `stitcher_aws_iam_principal_arn`, `stitcher_ai_environment_id` | an IAM role ARN; an env id |
   | Azure | `stitcherai_environment_id`, `stitcher_ai_service_account_id` | env id; the numeric unique id ("sub") of StitcherAI's Google service account |
   | GCP   | `stitcher_ai_sa_email` | a service-account email |
   | Databricks | none | the sample creates the service principal StitcherAI uses |

   For AWS you also **choose your own** `read_external_id` / `write_external_id` (any unique secret string) and must share the exact same value(s) back with StitcherAI.

3. **Run it.**
   ```sh
   cd tf_samples/<aws|azure|gcp|databricks>
   cp terraform.tfvars.example terraform.tfvars   # terraform.tfvars is gitignored so your real values aren't committed
   # fill in your values
   terraform init
   terraform plan
   terraform apply
   ```

4. **After apply — hand values back to StitcherAI.** Run `terraform output` and configure the values in the StitcherAI web app when creating data sources/destinations:
   - **AWS:** `read_role_arn`, `write_role_arn` (give StitcherAI the role ARNs).
   - **Azure:** `stitcher_ai_app_client_id`, `azure_tenant_id`, `azure_principal_id`.
   - **GCP:** access is granted directly to the StitcherAI service account; no new credentials are produced.
   - **Databricks:** `stitcherai_client_id`, `stitcherai_client_secret` (read it with `terraform output -raw stitcherai_client_secret`), and `stitcherai_warehouse_id`, plus the account ID and workspace URL you used with `databricks auth login`.

     The client secret expires 730 days after it is created, and StitcherAI cannot read Databricks data after that. `terraform state show module.databricks_read_access.databricks_service_principal_secret.stitcherai_sp_secret` shows the date in `expire_time`. To replace the secret before it expires, run the following, then enter the new secret in the StitcherAI web app:
     ```sh
     terraform apply -replace=module.databricks_read_access.databricks_service_principal_secret.stitcherai_sp_secret
     terraform output -raw stitcherai_client_secret
     ```
     The apply deletes the old secret, so StitcherAI cannot connect until you enter the new one.

## Examples

The following providers have example TF modules that users can copy and customize based on their needs:

### AWS

The AWS examples in this repository simulate the following _hypothetical_ needs:

* Need 1: Extracting AWS Cost and Usage Report (CUR) data from an S3 bucket
* Need 2: Extracting business datasets stored in an AWS S3 bucket
* Need 3: Exporting StitcherAI data to an S3 bucket (example illustrates using a separate role - it is not necessary)

**Notes:**

* All AWS access to StitcherAI is granted via an AWS Role the customer creates in their environment to which they grant StitcherAI the ability assume-role. This access is limited to the customer environment only. This is the AWS recommended way to grant a 3rd party password-less, controlled access to limited resources on an AWS account.
* StitcherAI will require an external-id to be specified in the role (per AWS recommendation) to secure against the [confused deputy problem](https://docs.aws.amazon.com/IAM/latest/UserGuide/confused-deputy.html)
* For each of the needs above, role created above will get a policy attachment where the policy is limited to the need (and controlled based on the parameters specified by the customers e.g. buckets and paths etc.)

### Azure

The Azure examples in this repository simulate the following _hypothetical_ needs:

* Need 1: Extracting Azure cost extract from an Azure storage account
* Need 2: Extracting business datasets stored in an Azure storage account
* Need 3: Exporting StitcherAI data to Azure storage account (example illustrates using the same AD principal)

**Notes:**

* All Azure access to StitcherAI is granted via an AD (now renamed to Microsoft Entra ID) application the customer creates in their subscription to which they grant StitcherAI access via the workload-identity mechanism. This access is limited to the customer environment only. This is the Azure recommended way to grant a 3rd party password-less, controlled access to limited resources of a subscription.
* For each of the needs above, role created above will grant a policy which is limited to the need (and controlled based on the parameters specified by the customers e.g. buckets and paths etc.)

### GCP

The GCP examples in this repository simulate the following _hypothetical_ needs:

* Need 1: Extracting GCP cost extract from a BigQuery dataset
* Need 2: Extracting business datasets stored in a Google Cloud Storage (GCS) bucket
* Need 3: Exporting StitcherAI data to a GCS bucket and a BigQuery dataset

**Notes:**

* All GCP access to StitcherAI is granted by the customer to a customer environment-specific GCP service account. This is the GCP recommended way to grant a 3rd party password-less, controlled access to limited resources of a customer GCP project.
* For each of the needs above, a role with limiting conditions will be granted to the resources a customer will specify e.g. BigQuery datasets, buckets and paths etc.
* Needs 2 and 3 share a custom role (`StitcherBucketListRole`) that lets the StitcherAI service account list objects in the configured buckets. The sample creates it in the project.

### Databricks

The Databricks examples in this repository simulate the following _hypothetical_ needs:

* Need 1: Extracting Databricks billing and usage data

**Notes:**

* All Databricks access to StitcherAI is granted via a dedicated service principal the customer creates in their workspace, with an OAuth secret that StitcherAI uses to authenticate.
* The service principal can read the Databricks billing, compute, and Lakeflow system schemas and the `system.access.workspaces_latest` table, and use a dedicated SQL warehouse to query them. It cannot read the rest of `system.access`, which holds the audit log and lineage tables.
