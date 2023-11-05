provider "aws" {
  region = "us-east-1"
}

data "aws_ssm_parameter" "rds_user" {
  name = "rds-user"
}

data "aws_ssm_parameter" "rds_password" {
  name           = "rds-password"
  with_decryption = true
}

resource "aws_db_instance" "lanchonete-55-mysql" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name              = "lanchonete55"
  parameter_group_name = "default.mysql5.7"

  username             = data.aws_ssm_parameter.rds_user.value
  password             = data.aws_ssm_parameter.rds_password.value
}

resource "aws_security_group" "mysql-db" {
  name_prefix = "db-"
}

resource "aws_security_group_rule" "db_ingress" {
  type        = "ingress"
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.mysql-db.id
}