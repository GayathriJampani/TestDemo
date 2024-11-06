output "db_endpoint" {
  value       = aws_db_instance.main.endpoint
  description = "The endpoint of the RDS database instance"
}

output "db_credentials_secret_arn" {
  value       = aws_secretsmanager_secret.db_credentials.arn
  description = "ARN of the Secrets Manager secret storing the DB credentials (name, username, password)"
}
