resource "aws_vpc" "main" {
    cidr_block  = "${var.vpc["cidr_block"]}"
    tags {
        Name    = "${var.vpc["name"]}"
    }
}

resource "aws_subnet" "public" {
    vpc_id     = "${aws_vpc.main.id}"
    cidr_block = "${var.public_subnet["cidr_block"]}"
    map_public_ip_on_launch = true
    tags {
        Name = "${var.public_subnet["name"]}"
    }
}

resource "aws_subnet" "private" {
    cidr_block = "${var.private_subnet["cidr_block"]}"
    vpc_id     = "${aws_vpc.main.id}"
    tags {
        Name = "${var.private_subnet["name"]}"
    }
}


resource "aws_internet_gateway" "gw" {
    vpc_id     = "${aws_vpc.main.id}"
    tags {
        Name = "${var.ig["name"]}"
    }
}

resource "aws_route_table" "rpublic" {
    vpc_id     = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }
    tags {
        Name = "${var.public_route["name"]}"
    }
}

resource "aws_route_table_association" "rapublic" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.rpublic.id}"
}

resource "aws_route_table" "rprivate" {
    vpc_id     = "${aws_vpc.main.id}"
    tags {
        Name = "${var.private_route["name"]}"
    }
}

resource "aws_route_table_association" "raprivate" {
  subnet_id      = "${aws_subnet.private.id}"
  route_table_id = "${aws_route_table.rprivate.id}"
}

resource "aws_security_group" "sg_nat" {
    name        = "${var.nat["sg_name"]}"
    description = "Security for NAT"
    vpc_id     = "${aws_vpc.main.id}"
    ingress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks = ["${var.private_subnet["cidr_block"]}"]
    }
}

resource "aws_key_pair" "nat" {
    key_name   = "${var.nat["ikey"]}"
    public_key = "${file("${var.nat["ipub"]}")}."
}

resource "aws_instance" "nat_server" {
    ami           = "${var.ami}"
    instance_type = "${var.nat["itype"]}"
    vpc_security_group_ids = ["${aws_security_group.sg_nat.id}"]
    subnet_id = "${aws_subnet.public.id}"
    key_name = "${var.nat["ikey"]}"
    source_dest_check = false
    tags {
        Name = "${var.nat["iname"]}"
    }
    provisioner "file" {
        source = "provision/nash.sh"
        destination = "/tmp/nat.sh"
    }
    provisioner "local-exec" {
        command = "chmod +x /tmp/nat.sh && /tmp/nat.sh"
    }
    
}

resource "aws_route" "nat_route" {
    route_table_id               = "${aws_route_table.rprivate.id}"
    destination_cidr_block    = "0.0.0.0/0"
    instance_id = "${aws_instance.nat_server.id}"
}

resource "aws_security_group" "sg_bastion" {
    name        = "${var.bastion["sg_name"]}"
    description = "Security group for bastion"
    vpc_id     = "${aws_vpc.main.id}"
    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_key_pair" "bastion" {
  key_name   = "${var.bastion["ikey"]}"
  public_key = "${file("${var.bastion["ipub"]}")}."
}

resource "aws_instance" "bastion" {
    ami           = "${var.ami}"
    instance_type = "${var.bastion["itype"]}"
    vpc_security_group_ids = ["${aws_security_group.sg_bastion.id}"]
    subnet_id = "${aws_subnet.public.id}"
    key_name = "${var.bastion["ikey"]}"
    source_dest_check = false
    tags {
        Name = "${var.bastion["iname"]}"
    }
}

resource "aws_key_pair" "client" {
    key_name   = "${var.client["ikey"]}"
    public_key = "${file("${var.client["ipub"]}")}."
}

resource "aws_security_group" "sg_client" {
    name        = "${var.client["sg_name"]}"
    description = "Security group for clients"
    vpc_id     = "${aws_vpc.main.id}"
    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        security_groups = ["${aws_security_group.sg_bastion.id}"]
    }
}

resource "aws_instance" "client" {
    ami           = "${var.ami}"
    instance_type = "${var.client["itype"]}"
    vpc_security_group_ids = ["${aws_security_group.sg_client.id}"]
    subnet_id = "${aws_subnet.private.id}"
    key_name = "${var.client["ikey"]}"
    source_dest_check = false
    tags {
        Name = "${var.client["iname"]}"
    }
}
