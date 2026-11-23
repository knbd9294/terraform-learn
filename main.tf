provider "aws" {
 region = "us-east-2"
}

variable avail_zone {}

variable "subnet_cidr_block" {
    description = "subnet cidr block"
    default = "10.0.10.0/24"
    type = string
}

variable "vpc_cidr_block" {
    description = "vpc cidr block"
    default = "10.0.0.0/16"
    type = string
}

variable "environment" {
    description = "deployment environment"
}

resource "aws_vpc" "development-vpc" {
    cidr_block = var.vpc_cidr_block #"10.0.0.0/16"
    tags = {
        Name : var.environment #"development"
        vpc_env: "dev"
    }
}

resource "aws_subnet" "dev-subnet-1" {
    vpc_id = aws_vpc.development-vpc.id
    cidr_block = var.subnet_cidr_block #"10.0.10.0/24"
    availability_zone =  var.avail_zone
    tags = {
        Name : "subnet-1-dev"
    }
}

data "aws_vpc" "existing_vpc" {
    default = true
}

resource "aws_subnet" "dev-subnet-2" {
    vpc_id = data.aws_vpc.existing_vpc.id
    cidr_block = "172.31.48.0/20"
    availability_zone = var.avail_zone
    tags = {
        Name : "subnet-2-default"
    }
}

output "dev-vpc-id" {
    value = aws_vpc.development-vpc.id
}

output "dev-subnet-id" {
    value = aws_subnet.dev-subnet-1.id
}