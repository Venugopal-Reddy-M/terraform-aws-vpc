### Terraform aws-vpc-module

This module creates following below Resources:-
----------------------------------------------
1. VPC
2. internet-gateway(IGW) with VPC association.
3. subnets -> public, private, database
4. route tables -> public, private, database 
5. Associations and  routes
6. EIP
7. NAT gateway
8. VPC peering with default vpc on condition.
9. Route table entries through peering

### inputs ###

project- (Required) Stringtype. user should pass the project name
environment- (Required) Stringtype. user should pass the environment name, values should be one of dev, uat, qa and prod