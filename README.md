# Task

## Deploy Multiple WordPress Instances in AWS Using Terraform

Develop a Terraform module that can create the necessary AWS infrastructure for a WordPress application deployment using EC2 and RDS and other necessary AWS services.

### Requirements:
* Use s3 as terraform backend.
* The module should accept variables for configuration, such as instance type, database engine, database size, and other relevant parameters.
* The module can be called to create multiple instances of WordPress for different environments. This should be reflected in all AWS resource names and tags.
* The module should include the creation of a MySQL database user and password (please don’t use the RDS master user). Feel free to use public Terraform providers for the DB resource creation.
* The database user password must be generated automatically and saved in AWS Secrets Manager, and it should be different for each WordPress instance.
* The Terraform output should provide the URL to connect to the WordPress installation page using HTTPS.
* **Bonus**: Include the logic to rotate the database password using Terraform.

### Deliverables:
* **Terraform Code:**
    * A Terraform module directory with all necessary files (`main.tf`, `variables.tf`, `outputs.tf`, etc.).
    * Terraform necessary files to spawn multiple WordPress instances (`main.tf`, `variables.tf`, `outputs.tf`, `terraform.tfvars`, etc.)
    * Example of `terraform.tfvars`:

      ```hcl
      wordpress_instances = {
        testing = {
          instance_type          = "t2.micro"
          db_engine              = "mysql"
          db_size                = "db.t2.micro"
          db_allocated_storage   = 20
          db_name                = "wordpress_test"
          db_username            = "wordpress_test"
        },
        prod = {
          instance_type          = "m5.large"
          db_engine              = "mysql"
          db_size                = "db.m6g.xlarge"
          db_allocated_storage   = 20
          db_name                = "wordpress_prod"
          db_username            = "wordpress_prod"
        }
      }
      ```

* **Documentation:**
    * A `README.md` file explaining how to use the module, including:
        * Prerequisites (e.g. Terraform version, providers, etc.).
        * Instructions for initializing and applying the Terraform configuration.
        * Description of the terraform module's input variables and outputs.
