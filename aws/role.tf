# resource "aws_iam_role" "test_role" {
#   name = "test_role"

#   assume_role_policy = <<EOF
# {
# "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "ec2.amazonaws.com"
#         },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }

# openvpn instance profile
resource "aws_iam_instance_profile" "role" {
  name  = "ec2-profile"
  roles = ["${ aws_iam_role.role.name }"]
}

# openvpn IAM role
resource "aws_iam_role" "role" {
  name = "ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
