# Terraform for SE demo of Falcon Container Runtime Protection

This terraform demo
 * creates single GKE cluster
 * creates single GCP instance for managing the cluster
 * enables container registry

### Usage
 - Edit [terraform.tfvars](terraform.tfvars)
   ```
   vi terraform.tfvars
   ```

 - Spin up the demo
   ```
   terraform init
   terraform apply
   ```
 - Tear down the demo
   ```
   terraform destroy
   ```
