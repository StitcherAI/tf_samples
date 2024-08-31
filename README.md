# tf_samples

Examples of using the StitcherAI TF modules to setup access for reading and writing data from StitcherAI

## Examples

The following providers have example TF modules that users can copy and customize based on their needs:

### AWS

The AWS examples in this repository simulate the following _hypothetical_ needs:

* Need 1: Extracting AWS Cost and Usage Report (CUR) data from an S3 bucket
* Need 2: Extracting business datasets stored in an AWS S3 bucket
* Need 3: Exporting StitcherAI data to an S3 bucket (example illustrates using a separate role - it is not necessary)

**Notes:**

* All AWS access to StitcherAI is granted via an AWS Role the customer creates in their environment to which they grant StitcherAI the ability assume-role. This access is limited to the customer environment only. This is the AWS recommend way to grant a 3rd party password-less, controlled access to limited resources on an AWS account.
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

* All GCP access to StitcherAI is granted by the customer to a customer environment-specific GCP service account. This is the GCP recommend way to grant a 3rd party password-less, controlled access to limited resources of a customer GCP project.
* For each of the needs above, a role with limiting conditions will be granted to the resources a customer will specify e.g. BigQuery datasets, buckets and paths etc.
