variable "access_key" {
  description = "aliyun access key"
}

variable "secret_key" {
  description = "aliyun secret_key"
}

variable "region" {
  description = "aliyun region"
  default     = "cn-beijing"
}

variable "az" {
    description = "availability_zones"
    default = {
        az1 = "cn-beijing-a"
        az2 = "cn-beijing-b"
    }   
}

variable "cidr_blocks" {
    description = "availability_zones"
    default = {
        az1 = "10.100.1.0/24"
        az2 = "10.100.2.0/24"
    }
}

variable "ami" {
  description = "aliyun image"
  default     = "m-2ze3p7zpoi600b92v6l5"
}

variable "vpc" {
  description = "aliyun vpc"
  default     = {
    name       = "kubernetes-common"
    cidr_block = "10.100.0.0/16"
  }
}

variable "nat_gateway" {
    description = "nat 实例规格大小[Small,Middle,Large],https://www.alibabacloud.com/help/zh/doc-detail/42757.htom"
    default = {
        spec = "Small"
        eip_bandwidth = "5"
        eip_internet_charge_type = "PayByTraffic"
    }   
}

variable "instance" {
    default = {
        internet_charge_type = "PayByTraffic"
        instance_type = "ecs.s3.medium"
        key_pair = "meiqia-sa"
    }
}

variable "kubernetes" {
    default = {
        name = "kubernetes-common"
    }
}


