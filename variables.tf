
variable "ENVIRONMENT" {
    default = "Staging"
}

variable "AWS_REGION" {
    default = ""
}

variable "cloudtrail_log_group_name" {
    default = "/aws/events/cloudtrail/logs"
}

variable "cloudtrail_retention_period" {
    type = number 
    default = 1
}

variable "cloudtrail_iam_role" {
    default = ""
}

variable "cloudtrail_iam_policy" {
    default = ""
}

variable "trail_name" {
    default = ""
}

variable "s3_key_prefix" {
    type = string
    default = ""
}

variable "include_global_service_event" {
    type = bool
    default = true
}

variable "read_write_type" {
    type = string
    default = "All"
}

variable "include_management_events" {
    type = bool
    default = true   
}

variable "bucket_name" {
    type = string
    default = ""
}

variable "force_destroy" {
    type = bool
    default = true 
}

variable "enable_guardduty" {
    type = bool
    default = true
}

variable "enable_s3_logs" {
    type = bool
    default = true
}

variable "enable_kubernetes_audit" {
    type = bool
    default = false 
}

variable "enable_malware_protection" {
    type = bool
    default = true
}

variable "guardduty_log_group_name" {
    default = "/aws/events/guardduty/logs"
}

variable "guardduty_retention_period" {
    type = number 
    default = 1
}

variable "lambda_to_es_role_name" {
    type = string
    default = ""
}

variable "domain_name" {
    type = string 
    default = "log-aggregation"
}

variable "engine_version" {
    type = string
    default = "OpenSearch_2.5"
}

variable "dedicated_master_count" {
    type = number
    default = 3
}

variable "dedicated_master_type" {
    type = string
    default = "m6g.large.search"
}

variable "dedicated_master_enabled" {
    type = bool
    default = true 
}

variable "instant_type" {
    type = string
    default = "m6g.large.search"
}

variable "instance_count" {
    type = number
    default = 3
}

variable "zone_awareness_enabled" {
    type = bool
    default = true
}

variable "availability_zone_count" {
    type = number
    default = 3 
}

variable "enable_advanced_security_options" {
    type = bool
    default = true 
}

variable "anonymous_auth_enabled" {
    type = bool
    default = false
}

variable "internal_user_database_enabled" {
    type = bool
    default = true 
}

variable "master_username" {
    type = string
    default = "yourusername"
}

variable "master_user_password" {
    type = string
    default = ""
}

variable "encrypt_at_rest" {
    type = bool
    default = true
}

variable "enforce_https" {
    type = bool
    default = true 
}

variable "custom_endpoint_enabled" {
    type = bool
    default = false 
}

variable "ebs_enabled" {
    type = bool
    default = true 
}

variable "volume_size" {
    type = number
    default = 1000
}

variable "volume_type" {
    type = string
    default = "gp3"
}

variable "throughput" {
    type = number
    default = 400
}

variable "enable_node_to_node_encryption" {
    type = bool
    default = true
}



