# 创建VPC
resource "alicloud_vpc" "vpc"{
    name        = "${var.vpc.["name"]}"
    cidr_block  = "${var.vpc.["cidr_block"]}"
}

# 获取az

data "alicloud_zones" "az" {
}

# 创建vswitch,在每个az区创建，保证服务高可用。

resource "alicloud_vswitch" "vsw" {
    vpc_id  = "${alicloud_vpc.vpc.id}"
    count = "${length(var.az)}"
    cidr_block  = "${lookup(var.cidr_blocks,"az${count.index+1}")}" 
    availability_zone = "${lookup(var.az,"az${count.index+1}")}"
    name = "${var.vpc["name"]}-private-az-${count.index+1}"
}

# 增加NAT网关.一个VPC只能创建一个NAT网关

resource "alicloud_nat_gateway" "nat" {
    vpc_id = "${alicloud_vpc.vpc.id}"
    specification = "${var.nat_gateway["spec"]}"
    name = "${var.vpc["name"]}-nat"
}

# 增加弹性IP
resource "alicloud_eip" "eip" {
    bandwidth = "${var.nat_gateway["eip_bandwidth"]}"
    internet_charge_type = "${var.nat_gateway["eip_internet_charge_type"]}"
}

# 为NAT网关绑定一个弹性IP
resource "alicloud_eip_association" "eip_asso" {
    allocation_id = "${alicloud_eip.eip.id}"
    instance_id = "${alicloud_nat_gateway.nat.id}"
} 

# 增加安全组

resource "alicloud_security_group" "accept_all_internal" {
    name = "accept_all_internal"
    vpc_id = "${alicloud_vpc.vpc.id}"
}

# 设置安全组规则

resource "alicloud_security_group_rule" "accept_all_internal" {
    type = "ingress"
    ip_protocol = "all"
    policy = "accept"
    priority = 1
    security_group_id = "${alicloud_security_group.accept_all_internal.id}"
    cidr_ip= "${var.vpc["cidr_block"]}"
}

resource "alicloud_security_group_rule" "accept_ssh" {
    type = "ingress"
    ip_protocol = "tcp"
    policy = "accept"
    priority = 1
    port_range  = "22/22"
    security_group_id = "${alicloud_security_group.accept_all_internal.id}"
    cidr_ip= "${var.vpc["cidr_block"]}"
    cidr_ip = "0.0.0.0/0"
}


