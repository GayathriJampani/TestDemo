env = "prod"

##vpc
vpc_cidr             = "10.1.0.0/16"
public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnet_cidrs = ["10.1.3.0/24", "10.1.4.0/24"]
##RDS
db_user          = "wordpress_prod"
db_instance_type = "db.t3.micro"
db_storage       = 20
db_name          = "wordpress_prod"

##EC2Instance
wordpress_ami_id        = "ami-0866a3c8686eaeeba"
wordpress_instance_type = "t2.micro"
key_name                = "wordpress"
private_key_path        = "C:\\Users\\Koya Seetharam\\Downloads\\wordpress.pem"