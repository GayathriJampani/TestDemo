# Define the IAM role
resource "aws_iam_role" "wordpress_instance_role" {
  name = "${var.env}-wordpress-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

# Define the IAM policy for Secrets Manager access
resource "aws_iam_policy" "secrets_manager_policy" {
  name        = "${var.env}-secrets-manager-policy"
  description = "Policy to allow access to Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "*"
      } ,
      {
        Effect = "Allow"
        Action = [
          "rds:DescribeDBInstances",
          "rds:Connect"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "attach_secrets_manager_policy" {
  policy_arn = aws_iam_policy.secrets_manager_policy.arn
  role       = aws_iam_role.wordpress_instance_role.name
}
resource "aws_iam_instance_profile" "wordpress_instance_profile" {
  name = "${var.env}-wordpress-instance-profile"
  role = aws_iam_role.wordpress_instance_role.name
}
resource "aws_security_group" "wordpress_sg" {
  name        = "${var.env}-wordpress-sg"
  description = "Allow traffic for WordPress instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.env}-wordpress-sg"
    Environment = var.env
  }
}

resource "aws_instance" "wordpress_instance" {
  ami               = var.ami_id
  instance_type    = var.instance_type
  key_name          = var.key_name
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]
  subnet_id        = var.public_subnet_ids[0]
  iam_instance_profile   = aws_iam_instance_profile.wordpress_instance_profile.name

  tags = {
    Name        = "${var.env}-wordpress-instance"
    Environment = var.env
    Project     = "WordPress"
  }

}

locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)
  db_username    = local.db_credentials["username"]
  db_password    = local.db_credentials["password"]
  db_name        = local.db_credentials["dbname"]
}

data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = var.db_credentials_secret_name
  version_stage = "AWSCURRENT"
  #depends_on = [ aws_secretsmanager_secret.db_credentials ]
}

resource "null_resource" "wordpress_provisioner" {
  depends_on = [ aws_instance.wordpress_instance ]

  connection {
    type = "ssh"
    host = aws_instance.wordpress_instance.public_ip
    user = "ubuntu"
    private_key = var.private_key_path
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",                # Update package list
      "sudo apt install -y apache2",    # Install Apache2
      "sudo systemctl start apache2",   # Start Apache2 service
      "sudo systemctl enable apache2",  # Enable Apache2 to start on boot
      "sudo apt install -y mysql-client", # Install MySQL client
      "sudo apt-get install -y php libapache2-mod-php", # Install PHP and Apache2 PHP module
      "sudo apt install -y php php-mysql php-gd php-cli php-common",

       # Download and unpack WordPress
      "wget https://wordpress.org/latest.tar.gz",
      " tar -xzf latest.tar.gz",
      "sudo cp -r wordpress/* /var/www/html/",
  

      # Fetch DB credentials from Secrets Manager
      "DB_USERNAME='${local.db_username}'",
      "DB_PASSWORD='${local.db_password}'",
      "DB_NAME='${local.db_name}'",
      "DB_HOST='${var.db_host}'",


      # Configure wp-config.php with the DB credentials
      "sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php",
      "sudo sed -i \"s/database_name_here/$DB_NAME/\" /var/www/html/wp-config.php",
      "sudo sed -i \"s/username_here/$DB_USERNAME/\" /var/www/html/wp-config.php",
      "sudo sed -i \"s/password_here/$DB_PASSWORD/\" /var/www/html/wp-config.php",
      "sudo sed -i \"s/localhost/$DB_HOST/\" /var/www/html/wp-config.php",
      "sudo rm -r /var/www/html/index.html",
      "sudo systemctl restart apache2"
    
    ]
 
}
triggers = {
  instance_id = aws_instance.wordpress_instance.id
  run_id = timestamp()
}
}

