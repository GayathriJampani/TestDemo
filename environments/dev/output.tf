output "wordpress_public_ip" {
  value = module.wordpress.wordpress_instance_public_ip
}

output "wordpress_url" {
  value = module.wordpress.wordpress_instance_url
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}