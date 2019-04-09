# terraform-aws-peered-vpcs

The first module creates three VPCs in the following AWS regions:

- us-east-1
- us-west-2
- eu-west-1

The VPCs are peered to us-east-1, where the new application will be deployed in the private subnet.
