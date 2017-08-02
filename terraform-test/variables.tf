variable "access_key" {}
variable "secret_key" {}

variable "keypair" {}

variable "subnet" {}

variable "region" {}
variable "sgroup" {}
variable "ami" {
    default = "ami-9e2f0988"
}

variable "itype" {
    default = "t2.micro"
}

variable "cluster_nodes" {
    default = {
        "0" = "terraform-0"
        "1" = "terraform-1"
        "2" = "terraform-2"
        "3" = "terraform-3"
        "4" = "terraform-4"
    }
}

variable "count" {
    default = {
        "cnodes" = "3"
    }
}

variable "platform" {
    default = "centos 7"
}