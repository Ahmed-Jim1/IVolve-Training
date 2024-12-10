output "lb-public_sg_id" {
  value = aws_security_group.lb-public_sg.id
}

output "lb-private_sg_id" {
  value = aws_security_group.lb-private_sg.id
}

output "public-ec2_sg_id" {
  value = aws_security_group.public-ec2_sg.id
}
output "private-ec2_sg_id" {
  value = aws_security_group.private-ec2_sg.id
}
