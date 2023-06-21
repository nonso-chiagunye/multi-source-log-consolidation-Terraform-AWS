
# Import region
data "aws_region" "current" {}

# Import caller Identity
data "aws_caller_identity" "current" {}


# Create Opensearch Doamin
resource "aws_opensearch_domain" "log_aggregation"  {
  domain_name    = "${var.domain_name}"  
  engine_version = "${var.engine_version}"

  cluster_config {
    dedicated_master_count   = var.dedicated_master_count
    dedicated_master_type    = "${var.dedicated_master_type}"
    dedicated_master_enabled = var.dedicated_master_enabled 
    instance_type            = "${var.instant_type}"
    instance_count           = var.instance_count
    zone_awareness_enabled   = var.zone_awareness_enabled
    zone_awareness_config {
      availability_zone_count = var.availability_zone_count
    }
  }

  advanced_security_options {
    enabled                        = var.enable_advanced_security_options 
    anonymous_auth_enabled         = var.anonymous_auth_enabled 
    internal_user_database_enabled = var.internal_user_database_enabled
    master_user_options {
      master_user_name     = "${var.master_username}"
      master_user_password = "${var.master_user_password}"
    }
  }

  encrypt_at_rest {
    enabled = var.encrypt_at_rest
  }

  domain_endpoint_options {
    enforce_https       = var.enforce_https
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"

    custom_endpoint_enabled         = var.custom_endpoint_enabled
    # custom_endpoint                 =
    # custom_endpoint_certificate_arn = 
  }

  ebs_options {
    ebs_enabled = var.ebs_enabled 
    volume_size = var.volume_size
    volume_type = "${var.volume_type}"
    throughput  = var.throughput
  }

  # log_publishing_options {
  #   cloudwatch_log_group_arn = 
  #   log_type                 = 
  # }
  

  node_to_node_encryption {
    enabled = var.enable_node_to_node_encryption
  }

  # vpc_options {
  #   subnet_ids = 

  #   security_group_ids = [aws_security_group.<your_sg>.id]
  # }


  access_policies = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "es:*",
      "Principal": "*",
      "Effect": "Allow",
      "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain}/*"
      
    }
  ]
}
POLICY
}