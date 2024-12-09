output "vpc_id" {
  description = "The ID of the selected VPC"
  value       = data.aws_vpc.selected.id
}
output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}