output "my-vpc_id" {
  value = aws_vpc.my-vpc.id
}
output "public-subnet_id" {
   value = aws_subnet.public.*.id
}
output "private-subnet_id" {
   value = aws_subnet.private.*.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}
