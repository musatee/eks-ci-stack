output "public_subnets" {
  value = { for az, subnet in aws_subnet.public_subnet : az => subnet.id }
}
output "private_subnets" {
  value = { for az, subnet in aws_subnet.private_subnet : az => subnet.id }
}

output "vpc_id" {
  value = aws_vpc.main.id
}