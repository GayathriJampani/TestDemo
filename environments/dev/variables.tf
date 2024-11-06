variable "env" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_user" {
  description = "Database username"
  type        = string
}

variable "db_instance_type" {
  description = "Instance type for the RDS database instance"
  type        = string

}

variable "db_storage" {
  description = "Allocated storage for the RDS instance in GB"
  type        = number

}
variable "wordpress_ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "wordpress_instance_type" {
  description = "Instance type for the WordPress EC2 instances"
  type        = string

}

variable "key_name" {
  description = "Name of the key pair for SSH access to the instances"
  type        = string
}

variable "private_key_path" {
  description = "privatekey path to private key"
  type        = string
}