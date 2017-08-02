resource "aws_instance" "node" {
    key_name = "${var.keypair}"

    ami = "${var.ami}"
    instance_type = "${var.itype}"
    vpc_security_group_ids = [ "${var.sgroup}" ]
    subnet_id = "${var.subnet}"

    tags {
        Name = "${lookup(var.cluster_nodes, count.index)}"
        Platform = "${var.platform}"
    }
    count = "${var.count["cnodes"]}"
}