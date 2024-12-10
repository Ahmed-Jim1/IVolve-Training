
variable "my-vpc_id" {
  type = string
}

variable "private-subnet_id" {
    type = list(string)
  }

variable "private_ec2_id" {
  type = list(string)
}
 
variable "lb-private_sg_id" {
  type = string
}
variable "public_ec2_id" {
  type = list(string)
}
variable "lb-public_sg_id" {
  type = string
}
variable "public-subnet_id" {
  type = list(string)
}