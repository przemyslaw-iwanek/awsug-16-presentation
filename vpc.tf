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

###### CREATING THE NETWORK

# Create VPC
resource "aws_vpc" "demo-vpc" {
    cidr_block = "10.11.12.0/28"
}

# Create DHCP Options
resource "aws_vpc_dhcp_options" "dhcp-opts" {
    domain_name = "example.domain.local"
    domain_name_servers = [
        "127.0.0.1",
        "AmazonProvidedDNS"
    ]
}

# Associate DHCP options with VPC
resource "aws_vpc_dhcp_options_association" "dhcp-opts-assoc" {
    vpc_id = "${aws_vpc.demo-vpc.id}"
    dhcp_options_id = "${aws_vpc_dhcp_options.dhcp-opts.id}"
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.demo-vpc.id}"
}

# Create VPC endpoint
resource "aws_vpc_endpoint" "s3endpoint" {
    vpc_id = "${aws_vpc.demo-vpc.id}"
    service_name = "com.amazonaws.eu-west-1.s3"

    route_table_ids = [
        "${aws_route_table.rt-public.id}"
    ]
}

# Create Route Table
resource "aws_route_table" "rt-public" {
    vpc_id = "${aws_vpc.demo-vpc.id}"

    # Associate IGW with this Route Table as a default route
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }
}

# Create Subnet in second availability zone
resource "aws_subnet" "subnet-public" {
    vpc_id = "${aws_vpc.demo-vpc.id}"

    cidr_block = "10.11.12.0/28"
    availability_zone = "eu-west-1b"
}

# Associate Subnet with Route Table
resource "aws_route_table_association" "subnet-public-assoc" {
    subnet_id = "${aws_subnet.subnet-public.id}"
    route_table_id = "${aws_route_table.rt-public.id}"
}