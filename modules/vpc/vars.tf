variable "vpc_cidr"{
  default = "10.0.0.0/16"
}

variable "tenancy"{
  default = "dedicated"
}

variable "vpc_id"{}

variable "subnet_cidr"{
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr"{
  default = "10.0.2.0/24"
}

variable "gw_id"{}

variable "ipv6_cidr_block"{
  default = "::/0"
}

variable "eg_gw_id"{
  default = "::/0"
}

variable "rt_id"{}

variable "rt_prv_id"{}

variable "subnet_id"{}

variable "private_subnet_id"{}

variable "allocation_id"{}

variable "nat_id"{}

