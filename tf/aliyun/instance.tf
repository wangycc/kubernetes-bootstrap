# 创建kubernetes master机器
resource "alicloud_instance" "kubernetes_master" {
    count = 3
    image_id = "${var.ami !="" ? var.ami : "centos_7_04_64_20G_alibase_201701015.vhd"}"
    instance_type = "${var.instance["instance_type"]}"
    security_groups = ["${alicloud_security_group.accept_all_internal.id}"]
    vswitch_id = "${element(alicloud_vswitch.vsw.*.id,count.index)}"
    key_name = "${var.instance["key_pair"]}"
    internet_charge_type = "${var.instance["internet_charge_type"]}"
    instance_name = "${var.kubernetes["name"]}-master-${count.index}"
    host_name = "${var.kubernetes["name"]}-node-${count.index}"
}

# 创建kubernetes node机器
resource "alicloud_instance" "kubernetes_node" {
    count = 2
    image_id = "${var.ami !="" ? var.ami : "centos_7_04_64_20G_alibase_201701015.vhd"}"
    instance_type = "${var.instance["instance_type"]}"
    security_groups = ["${alicloud_security_group.accept_all_internal.id}"]
    vswitch_id = "${element(alicloud_vswitch.vsw.*.id,count.index)}"
    key_name = "${var.instance["key_pair"]}"
    internet_charge_type = "${var.instance["internet_charge_type"]}"
    instance_name = "${var.kubernetes["name"]}-node-${count.index}"
    host_name = "${var.kubernetes["name"]}-node-${count.index}"
}
