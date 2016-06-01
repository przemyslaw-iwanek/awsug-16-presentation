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

###### PREPARING ROLES FOR ACCESSING S3 FROM EC2 INSTANCE

# Create EC2 Role
resource "aws_iam_role" "demo-s3-access" {
    name = "demo-s3-access-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

# Policy to access our S3 bucket
resource "aws_iam_policy" "s3-access-policy" {
    name = "s3-access-policy"
    path = "/"
    description = "Policy for accessing S3"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:ListObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}/*"
            ]
        }
    ]
}
EOF
}

# Attach this policy to role
resource "aws_iam_policy_attachment" "s3-access-policy-attachement" {
    name = "s3-access-policy-attachement"
    roles = ["${aws_iam_role.demo-s3-access.name}"]
    policy_arn = "${aws_iam_policy.s3-access-policy.arn}"
}

# Instance profile with role assignment.
resource "aws_iam_instance_profile" "demo-iam-profile" {
    name = "demo-iam-profile"
    roles = ["${aws_iam_role.demo-s3-access.name}"]
}
