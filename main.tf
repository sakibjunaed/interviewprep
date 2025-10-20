terraform {
    backend "s3" {
        bucket = "sakib-terraform-state-9647"
        key = "global/s3/terraform.tfstate"
        region = "us-east-1"
    }
}

provider "aws" {
    region = "us-east-1"
}

data "aws_vpc" "default" {
    default = true
}

data "aws_subnet" "mySubnet" {
    id = "subnet-0ce1515776d6743d5"
}

resource "aws_efs_file_system" "efs" {
    creation_token = "myefs"
    performance_mode = "generalPurpose"
    throughput_mode = "bursting"
}

resource "aws_security_group" "efs_sg" {
    name = "efs-security-group"
    description = "security group for EFS mount target"
    vpc_id = data.aws_vpc.default.id

    ingress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_efs_mount_target" "efs_mount" {
    file_system_id = aws_efs_file_system.efs.id
    subnet_id = data.aws_subnet.mySubnet.id
    security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_instance" "user-1" {
    ami = "ami-0341d95f75f311023"
    instance_type = "t3.micro"
    subnet_id = data.aws_subnet.mySubnet.id
    security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_instance" "user-2" {
    ami = "ami-0341d95f75f311023"
    instance_type = "t3.micro"
    subnet_id = data.aws_subnet.mySubnet.id
    security_groups = [aws_security_group.efs_sg.id]
}