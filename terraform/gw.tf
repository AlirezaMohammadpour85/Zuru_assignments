resource "aws_internet_gateway" "go_api_igw" {
  vpc_id = aws_vpc.go_api_vpc.id

  tags = {
    Name = "go-api-internet-gateway"
  }
}
