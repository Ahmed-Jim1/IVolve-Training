output "public_ec2_public_ip" {
  value = aws_instance.nginx.public_ip
  description = "The public IP of the public EC2 instance"
}

# Output Public EC2 Instance Private IP
output "public_ec2_private_ip" {
  value = aws_instance.nginx.private_ip
  description = "The private IP of the public EC2 instance"
}

# Output Apache EC2 Instance Private IP
output "apache_ec2_private_ip" {
  value = aws_instance.apache.private_ip
  description = "The private IP of the Apache EC2 instance"
}