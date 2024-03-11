# terraform-automation

To deploy:
- terraform plan
- terraform apply

To destroy:
- terraform destroy


# On Workstation Machines:

- chmod 400 /path/to/YOUR-SSH-KEY

Connect via SSH:
- ssh -i /path/to/terraform-ssh-key workshop@vm_public_ip

# After Login do:
- chmod +x automate-json-ingestion.sh
- ./automate-json-ingestion.sh
