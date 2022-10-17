module "my_vpc"{
  source = "../modules/vpc"
  vpc_cidr = "192.168.0.0/16"
  tenancy = "default"
  vpc_id = "${module.my_vpc.vpc_id}"
  subnet_cidr = "192.168.0.0/24"
  private_subnet_cidr = "192.168.1.0/24"
  gw_id = "${module.my_vpc.gw_id}"
  rt_id = "${module.my_vpc.rt_id}"
  subnet_id = "${module.my_vpc.subnet_id}"
  allocation_id = "${module.my_vpc.allocation_id}"
  nat_id = "${module.my_vpc.nat_id}"
  private_subnet_id = "${module.my_vpc.private_subnet_id}"
  rt_prv_id = "${module.my_vpc.rt_prv_id}"
}

module "my_ec2"{
  source = "../modules/ec2"
  ec2_count = 1
  ami_id = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  subnet_id = "${module.my_vpc.subnet_id}"
  private_subnet_id = "${module.my_vpc.private_subnet_id}"
  vpc_id = "${module.my_vpc.vpc_id}"
  key_name = "new_vir"
}