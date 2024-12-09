resource "aws_db_instance" "my_rds" {
  allocated_storage      = 10                   # Storage size in GB
  db_name                = "mydb"               # Database name
  engine                 = "mysql"              # Database engine
  engine_version         = "8.0"                # MySQL version
  instance_class         = "db.t3.micro"        # Instance type
  username               = "admin"              # Master username
  password               = "MyPassword123!"     # Master password
  parameter_group_name   = "default.mysql8.0"   # Default parameter group for MySQL 8.0
  skip_final_snapshot    = true                 # Skip final snapshot on deletion
  publicly_accessible    = false                # Make the DB private
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

  tags = {
    Name = "My-RDS-Instance"
  }
}
resource "aws_instance" "ec2_instance" {
  ami                    = "ami-0453ec754f44f9a4a" 
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = "ivolve"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y mariadb105
              echo "[client]" > ~/.my.cnf
              echo "user=admin" >> ~/.my.cnf
              echo "password=MyPassword123!" >> ~/.my.cnf
              echo "Connecting to RDS..."
              mysql -h ${aws_db_instance.my_rds.endpoint} -e "SHOW DATABASES;"
              EOF

  tags = {
    Name = "ec2-with-rds-connection"
  }

 # Local provisioner to write EC2 public IP to ec2-ip.txt
  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ec2-ip.txt"
  }



}




