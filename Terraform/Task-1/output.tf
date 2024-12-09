output "vpc_id" {
  description = "The ID of the selected VPC"
  value       = data.aws_vpc.selected.id
}
output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private_subnet.id
}

output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.my_rds.endpoint
}

output "rds_username" {
  description = "The username for the RDS instance"
  value       = aws_db_instance.my_rds.username
}

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.ec2_instance.public_ip
}