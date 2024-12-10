resource "aws_instance" "pub-ec2" {
  count                       = 2
  ami                         = var.ami
  instance_type               = "t2.micro"
  subnet_id                   = var.public-subnet_id[count.index]
  security_groups             = [var.public-ec2_sg_id]
  associate_public_ip_address = true
  key_name = "ivolve"
  tags = {
      Name = "web-ec2_${count.index+1}"
    } 

 provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install nginx -y",
      "sudo echo 'server {listen 80; location / { proxy_pass http://${var.lb-backend_dns_name}; } }' | sudo tee /etc/nginx/conf.d/proxy.conf",
      "sudo rm /usr/share/nginx/html/index.html",
      "sudo touch /usr/share/nginx/html/index.html",
      "sudo echo 'Hello from Proxy1' | sudo tee /usr/share/nginx/html/index.html",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
      "sleep 5", 
      "sudo nginx -t",
      "sudo systemctl restart nginx",
      "echo public-ip-${count.index} : ${self.private_ip} >> all-ips.txt"
    ]
    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("modules/compute/ivolve.pem")
      host = self.public_ip
      timeout = "5m"
    } 
    }
depends_on = [ aws_instance.priv-ec2 ]

}

resource "aws_instance" "priv-ec2" {
  count                       = 2
  ami                         = var.ami
  instance_type               = "t2.micro"
  subnet_id                   = var.private-subnet_id[count.index]
  security_groups             = [var.private-ec2_sg_id] 
  key_name = "ivolve"
  associate_public_ip_address = true
  tags = {
    Name = "backend_ec2_${count.index+1}"  
  }
  user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install -y httpd
  sudo systemctl start httpd
  sudo systemctl enable httpd
  echo '<html><body><h1>Hello from Server ${count.index + 1}</h1></body></html>' | sudo tee /var/www/html/index.html
  sudo systemctl restart httpd
EOF

  provisioner "local-exec" {
    when        = create
    on_failure  = continue
    command = "echo private-ip-${count.index} : ${self.private_ip} >> all-ips.txt"
 }
 
} 
