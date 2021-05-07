# Terraform to demo Falcon Container Runtime Protection

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

User then may
 * Show that container workload (vulnerable.example.com) appears in Falcon Console (under Hosts, or Containers Dashboard)
 * Visit vulnerable.example.com application and exploit it through the web interface
 * Show detections in Falcon Console

### Prerequsites
 - Get access to GCP
 - Have Containers enabled in Falcon console (CWP subscription)
 - install terraform command-line tool
   - install gcloud command-line tool (dependency of terraform)

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
