variable "env" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the WordPress EC2 instances"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the key pair for SSH access to the instances"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the instances will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of subnet IDs where the WordPress instances will be launched"
  type        = list(string)
}

variable "db_credentials_secret_name" {
  description = "Name of the Secrets Manager secret storing DB credentials"
  type        = string
}

variable "db_host" {
  description = "RDS instance endpoint"
  type        = string
}

variable "WORDPRESS_KEY" {
  description = "privatekey path to private key"
  type        = string
}
