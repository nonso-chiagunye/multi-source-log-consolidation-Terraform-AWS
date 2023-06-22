# multi-source-log-consolidation-Terraform-AWS

This project creates a consolidated log from multiple AWS Log Sources - CloudTrail, GuardDuty, and VPC Flow Log (this will be added shortly)

It also creates Opensearch Doamin with necessary IAM Roles and Policies to stream logs to Opensearch.

The script to subscribe to logs from the CloudWatch Log Groups to opensearch are also included, however, this is currently showing errors because terraform do not have direct API to achieve this.

As a result of this, the final subscription from CloudWatch Log Group to opensearch will be done mannually on the console. But all the resources, roles and persmissions to be used are created in this project.

Enjoy!!! 
