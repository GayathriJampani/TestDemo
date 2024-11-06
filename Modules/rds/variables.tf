variable "env" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "db_name" {
  description = "Database name for the RDS instance"
  type        = string
}

variable "db_user" {
  description = "Database username"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the RDS database instance"
  type        = string
  
}

variable "db_storage" {
  description = "Allocated storage for the RDS instance in GB"
  type        = number
  
}

variable "db_security_group_id" {
  description = "Security group ID for the RDS instance to control access"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs where the RDS instance will be deployed"
  type        = list(string)
}
