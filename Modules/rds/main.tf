# Generate a random password for the database
resource "random_password" "db_password" {
  length           = 12
  special          = true
  min_lower        = 2
  min_upper        = 2
  min_numeric      = 2
  min_special      = 2
  #override_special = "_%@"
}

# Store database credentials in AWS Secrets Manager
resource "aws_secretsmanager_secret" "db_credentials" {
  name = "wordpress-db-credentials-${var.env}-01"

  tags = {
    Environment = var.env
  }
}

# Create a secret version to store DB credentials as a JSON object
resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_user,
    password = random_password.db_password.result,
    dbname   = var.db_name
  })
  depends_on = [ aws_secretsmanager_secret.db_credentials ]
}

# Create a DB subnet group for RDS to specify private subnets
resource "aws_db_subnet_group" "main" {
  name       = "${var.env}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.env}-db-subnet-group"
    Environment = var.env
  }
}

# Create the RDS MySQL instance
resource "aws_db_instance" "main" {
  identifier              = "${var.env}-wordpress-db"
  engine                  = "mysql"
  instance_class          = var.instance_type
  allocated_storage       = var.db_storage
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [var.db_security_group_id]
  username                = var.db_user
  password                = random_password.db_password.result  # Use the generated password here
  db_name                 = var.db_name
  publicly_accessible     = false
  skip_final_snapshot     = true

  tags = {
    Name        = "${var.env}-wordpress-db"
    Environment = var.env
  }
}

