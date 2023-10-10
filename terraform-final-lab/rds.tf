// create subnet_group for RDS
resource "aws_db_subnet_group" "subnet_gr" {
    name = "db_bg_final"
    subnet_ids = [aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id]
    
}

// create RDS
resource "aws_db_instance" "rds" {
  allocated_storage = 20
  db_name = "wordpress"
  engine = "mysql"
  engine_version = "8.0.33"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  username = "wordpress"
  password = "wordpress"
  instance_class = "db.t3.micro"
  db_subnet_group_name = aws_db_subnet_group.subnet_gr.name
  identifier = "rds"
  skip_final_snapshot = true
  storage_encrypted = true
  publicly_accessible = false
}