
output "aws-vpc" {
  value = aws_vpc.jmyvpc.id
}

output "subnets-private" {
  value = aws_subnet.private-subnets[*].id
}

output "subnets-public" {
  value = aws_subnet.public-subnets[*].id
}

/*
locals {
  my_num_list=[0,1,2,3,4,5]
}
output "subnet-azs" {
  value=[for no in local.my_num_list:element(var.azs, no)]
}
*/