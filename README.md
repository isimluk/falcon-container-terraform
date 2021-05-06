# Terraform for SE demo of Falcon Container Runtime Protection

This terraform demo
 * creates single GKE cluster
 * creates single GCP instance for managing the cluster
 * enables container registry (GCR)
 * enables secrets manager
 * stores falcon credentials in GCP secrets manager
 * downloads Falcon Container sensor
 * pushes Falcon Container sensor to GCR
 * deploys Falcon Container sensor to the cluster
 * deploys vulnerable.example.com application

### Prerequsites
 - Get access to GCP
 - install terraform command-line tool

### Usage

 - Spin up the demo
   ```
   terraform init
   terraform apply
   ```

 - Get access to the admin VM that manages the GKE
   ```
   terraform output admin_access
   ```
   or directly
   ```
   $(terraform output admin_access | tr -d '"')
   ```

 - Get access to the vulnerable.example.command
   ```
   terraform output vulnerable-example-com
   ```

 - Tear down the demo
   ```
   terraform destroy
   ```

### Known limitations

 - Currently, each demo instance needs to be spun up in separate GCP project.
 - This is early version. Please report or even fix issues.
