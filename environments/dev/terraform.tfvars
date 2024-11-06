env = "dev"

##vpc
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
##RDS
db_user          = "wordpress_dev"
db_instance_type = "db.t3.micro"
db_storage       = 20
db_name          = "wordpress_dev"

##EC2Instance
wordpress_ami_id        = "ami-0866a3c8686eaeeba"
wordpress_instance_type = "t2.micro"
key_name                = "wordpress"