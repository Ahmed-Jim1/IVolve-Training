# EC2 Instance in Private Subnet (Apache)
resource "aws_instance" "apache" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnets["private_subnet"].id
  vpc_security_group_ids = [aws_security_group.private_ec2_sg.id]
  key_name               = "ivolve"

  tags = {
    Name = "apache-instance"
  }

  # User data script to install Apache
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install httpd -y
              sudo systemctl start httpd
              sudo systemctl enable httpd
              EOF
}

    # EC2 Instance in Public Subnet (Nginx)
    resource "aws_instance" "nginx" {
    ami                    = var.ami_id
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.subnets["public_subnet"].id
    vpc_security_group_ids = [aws_security_group.public_ec2_sg.id]
    key_name = "ivolve"
    tags = {
        Name = "nginx-instance"
    }

    provisioner "remote-exec" {
        inline = [
        "sudo yum update -y",
        "sudo yum install nginx -y",
        "sudo systemctl start nginx"
        ]
    }

    connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file("./ivolve.pem")
        host        = self.public_ip
    }
    }