variable "ec2_count"{
  default = "1"
}

variable "ami_id"{
  #default = "data.aws_ami.ubuntu.id"
}

variable "instance_type"{
  default = "t2.micro"
}

variable "subnet_id"{}

variable "private_subnet_id"{}

variable "vpc_id"{}

variable "key_name"{
  default = "../new_vir"
}