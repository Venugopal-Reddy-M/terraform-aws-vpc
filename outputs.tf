output "vpc_id" {
  description = "ID of project VPC"
  value       = aws_vpc.main.id
}

output "aws_availability_zones" {
  description = "List of availability zones"
  value       = data.aws_availability_zones.available.names
}