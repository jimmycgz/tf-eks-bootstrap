
output "aws-vpc" {
  value = aws_vpc.jmyvpc.id
}
output "subnet-private1" {
  value = aws_subnet.private1.id
}
output "subnet-private2" {
  value = aws_subnet.private2.id
}
output "subnet-private3" {
  value = aws_subnet.private3.id
}

output "subnet-public1" {
  value = aws_subnet.public1.id
}
output "subnet-public2" {
  value = aws_subnet.public2.id
}
output "subnet-public3" {
  value = aws_subnet.public3.id
}