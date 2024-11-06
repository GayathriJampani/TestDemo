output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value       = aws_subnet.public.*.id
  description = "List of IDs for public subnets"
}

output "private_subnet_ids" {
  value       = aws_subnet.private.*.id
  description = "List of IDs for private subnets"
}

output "db_security_group_id" {
  value       = aws_security_group.db.id
  description = "Security group ID for database access in private subnets"
}
