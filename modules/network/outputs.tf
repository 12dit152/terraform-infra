output "samar_vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.samar_vpc.id
}

output "public_subnet1_id" {
  description = "ID of public subnet 1"
  value       = aws_subnet.public1.id
}

output "public_subnet2_id" {
  description = "ID of public subnet 2"
  value       = aws_subnet.public2.id
}

output "public_subnet3_id" {
  description = "ID of public subnet 3"
  value       = aws_subnet.public3.id
}

output "private_subnet1_id" {
  description = "ID of private subnet 1"
  value       = aws_subnet.private1.id
}

output "private_subnet2_id" {
  description = "ID of private subnet 2"
  value       = aws_subnet.private2.id
}

output "private_subnet3_id" {
  description = "ID of private subnet 3"
  value       = aws_subnet.private3.id
}