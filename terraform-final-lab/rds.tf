// create subnet_group for RDS
resource "aws_db_subnet_group" "subnet_gr" {
    name = "db_bg_final"
    subnet_ids = [aws_subnet.private_subnet[0].id, aws_subnet.private_subnet[1].id]
    
}
// create security group for rds
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.vpc.id
  name = "rds_sg"
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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