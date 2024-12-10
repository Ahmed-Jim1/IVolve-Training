variable "ami" {
  default = "ami-0453ec754f44f9a4a"
}
variable "my-vpc_id" {
  type = string
}
variable "private-ec2_sg_id" {
  type = string
}

variable "private-subnet_id" {
  type = list(string)
}
variable "public-ec2_sg_id" {
  type = string
}
variable "public-subnet_id" {
  type = list(string)
}
variable "lb-backend_dns_name" {
  type = string
}