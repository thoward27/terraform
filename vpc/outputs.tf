
output "vpc_id" {
    value = aws_vpc.prod.id
}

output "aws_internal_subnet_ids" {
    value = aws_subnet.prod_internal.*.id
}

output "aws_external_subnet_ids" {
    value = aws_subnet.prod_external.*.id
}
