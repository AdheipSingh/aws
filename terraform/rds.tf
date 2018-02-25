provider "aws" {
        access_key = ""
        secret_key = ""
        region = "ap-south-1"
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "9.5.4"
  instance_class       = "db.r3.large"
  name                 = "mydb"
  username             = "adheipsingh"
  password             = "adheipsinghsadhrao"
}
                       
