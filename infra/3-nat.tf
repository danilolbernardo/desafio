resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = "eks-nat-eip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.eks_subnet_public_1.id

  tags = {
    Name = "eks-nat-gateway"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.eks_subnet_private_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.eks_subnet_private_2.id
  route_table_id = aws_route_table.private_route_table.id
}