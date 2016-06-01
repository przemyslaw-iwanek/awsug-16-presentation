# Copyright (C) 2016 Cognifide Limited
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Written by:
#   Przemysław Iwanek <przemyslaw.iwanek@cognifide.com> and contributors
#   May 2016
# 

###### CREATING THE INSTANCE

# Create security group
resource "aws_security_group" "sg-demo" {
    vpc_id = "${aws_vpc.demo-vpc.id}"
    
    name = "demo-sg-allow-ssh"
    description = "Allow SSH ingress traffic and all egress"
    
    ingress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "demo-instance" {
    instance_type = "t2.nano"    
    ami = "${var.ami}"

    availability_zone = "${aws_subnet.subnet-public.availability_zone}"
    subnet_id = "${aws_subnet.subnet-public.id}"

    # Create Root EBS Volume - 20 GB, SSD backed
    root_block_device {
        volume_size = 20
        volume_type = "gp2"
    }

    key_name = "${var.key}"

    vpc_security_group_ids = [
        "${aws_security_group.sg-demo.id}"
    ]

    iam_instance_profile = "${aws_iam_instance_profile.demo-iam-profile.id}"
}

resource "aws_eip" "public-eip" {
    instance = "${aws_instance.demo-instance.id}"
    vpc = true
}