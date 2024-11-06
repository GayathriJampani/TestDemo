terraform {
  backend "s3" {
    bucket  = "terraform-state-wordpress-012"
    key     = "prod-terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

module "vpc" {
  source               = "../../Modules/vpc"
  env                  = var.env
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "rds" {
  source               = "../../Modules/rds"
  env                  = var.env
  private_subnet_ids   = module.vpc.private_subnet_ids
  db_name              = var.db_name
  db_user              = var.db_user
  db_security_group_id = module.vpc.db_security_group_id
  instance_type        = var.db_instance_type
  db_storage           = var.db_storage
}

module "wordpress" {
  source                     = "../../Modules/wordpress"
  env                        = var.env
  ami_id                     = var.wordpress_ami_id
  instance_type              = var.wordpress_instance_type
  public_subnet_ids          = module.vpc.public_subnet_ids
  key_name                   = var.key_name
  vpc_id                     = module.vpc.vpc_id
  db_credentials_secret_name = module.rds.db_credentials_secret_arn
  db_host                    = module.rds.db_endpoint
  private_key_path           = var.private_key_path

}
