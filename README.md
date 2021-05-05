# Terraform for SE demo of Falcon Container Runtime Protection

This terraform demo
 * creates single GKE cluster
 * creates single GCP instance for managing the cluster
 * enables container registry
 * enables secrets manager
 * stores falcon credentials in GCP secrets manager

### Prerequsites
 - Get access to GCP
 - install terraform command-line tool

### Usage

 - Spin up the demo
   ```
   terraform init
   terraform apply
   ```
 - Tear down the demo
   ```
   terraform destroy
   ```

### Known limitations

 - Currently, each demo instance needs to be spun up in separate GCP project.
 - This is early version. Please report or even fix issues.
