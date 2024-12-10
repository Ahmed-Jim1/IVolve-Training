  
module "network" {
  source        = "./modules/network"
}

module "security-groups" {
  source = "./modules/security-groups"
  my-vpc_id = module.network.my-vpc_id
  depends_on = [ module.network ]
}

module "compute" {
  source = "./modules/compute"
  my-vpc_id = module.network.my-vpc_id
  public-subnet_id = module.network.public-subnet_id
  private-subnet_id = module.network.private-subnet_id
  public-ec2_sg_id = module.security-groups.public-ec2_sg_id
  private-ec2_sg_id = module.security-groups.private-ec2_sg_id 
  lb-backend_dns_name = module.load-load_balancers.lb-backend_dns_name
  depends_on = [ module.network ]

  }

module "load-load_balancers" {
  source = "./modules/load-balancers"
my-vpc_id = module.network.my-vpc_id
private-subnet_id = module.network.private-subnet_id
private_ec2_id = module.compute.private_ec2_id
lb-private_sg_id = module.security-groups.lb-private_sg_id
public-subnet_id = module.network.public-subnet_id
public_ec2_id = module.compute.public_ec2_id
lb-public_sg_id = module.security-groups.lb-public_sg_id

}




