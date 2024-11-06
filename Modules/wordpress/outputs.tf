output "wordpress_instance_id" {
  value       = aws_instance.wordpress_instance.id
  description = " WordPress EC2 instance ID"
}

output "wordpress_security_group_id" {
  value       = aws_security_group.wordpress_sg.id
  description = "The security group ID attached to the WordPress instances"
}

output "wordpress_instance_public_ip" {
  value       = aws_instance.wordpress_instance.public_ip
  description = "The public IP address of the WordPress instances"
}

output "wordpress_instance_url" {
  value       = aws_instance.wordpress_instance.public_dns
  description = " URLs to access Dns"
}
