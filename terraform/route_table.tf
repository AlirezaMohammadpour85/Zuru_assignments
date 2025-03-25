resource "aws_route_table" "go_api_rt" {
  vpc_id = aws_vpc.go_api_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.go_api_igw.id
  }

  tags = {
    Name = "go-api-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.go_api_rt.id
}

resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.go_api_rt.id
}
