output "vpc_id" {
  description = "ID of project VPC"
  value       = aws_vpc.main.id
}

# output "aws_availability_zones" {
#   description = "List of availability zones"
#   value       = data.aws_availability_zones.available.names
#   #value       = data.aws_availability_zones.available
# }

output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "database_subnet_ids" {
  value = aws_subnet.database_subnet[*].id
}