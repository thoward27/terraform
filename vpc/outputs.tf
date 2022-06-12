
output "vpc_id" {
    value = aws_vpc.prod.id
}

output "aws_subnet_ids" {
    value = aws_subnet.prod.*.id
}
