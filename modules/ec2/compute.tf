resource "aws_instance" "web" {
  count		= "${var.ec2_count}"
  ami           = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${var.subnet_id}"
  associate_public_ip_address = "true"
  key_name        = var.key_name
  security_groups = [aws_security_group.instance_sg.id]

  tags = {
    Name = "Public Instance"
  }
}

resource "aws_instance" "other" {
  count		= "${var.ec2_count}"
  ami           = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${var.private_subnet_id}"
  associate_public_ip_address = "false"
  key_name        = var.key_name
  security_groups = [aws_security_group.instance_sg.id]

  tags = {
    Name = "Private Instance"
  }
}

#-------
resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "Allow Traffic to intance"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow HTTP from Personal CIDR block to instance"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["${data.external.myipaddr.result.ip}/32"]
  }

  ingress {
    description      = "Allow SSH from Personal CIDR block"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${data.external.myipaddr.result.ip}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Instance SG"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20220610*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm*"]
  }

  owners = ["099720109477"] # Canonical
}

data "external" "myipaddr" {
    program = ["bash", "-c", "curl -s 'https://ipinfo.io/json'"]
}

output "my_public_ip" {
  value = "${data.external.myipaddr.result.ip}/32"
}