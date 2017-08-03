variable "access_key" {}
variable "secret_key" {}
variable "region" {}

variable "ami" {
    default = "ami-9e2f0988"
}

variable "public_subnet" {
    default = {
        name = "terraform.subnet.public"
        cidr_block = "10.10.0.0/24"
    }
}

variable "private_subnet" {
    default = {
        name = "terraform.subnet.private"
        cidr_block = "10.10.1.0/24"
    }
}

variable "public_route" {
    default = {
        name = "terraform.route.public"
    }
}

variable "private_route" {
    default = {
        "name" = "terraform.route.private"
    }
}

variable "ig" {
    default = {
        name = "internet_gateway"
    }
}

variable "vpc" {
    default = {
        cidr_block = "10.10.0.0/16"
        name = "terraform.vpc"
    }
}



variable "nat" {
    default = {
        sg_name = "terraform.sg.nat"
        itype = "t2.micro"
        iname = "terraform.instance.nat"
        ikey = "terraform.keys.nat"
        ipub = "keys/nat.pub"
    }
}


variable "bastion" {
    default = {
        sg_name = "terraform.sg.bastion"
        itype = "t2.micro"
        iname = "terraform.instance.bastion"
        ikey = "terraform.keys.bastion"
        ipub = "keys/bastion.pub"
    }
}


variable "client" {
    default = {
        sg_name = "terraform.sg.client"
        itype = "t2.micro"
        iname = "terraform.instance.client"
        ikey = "terraform.keys.client"
        ipub = "keys/client.pub"
    }
}