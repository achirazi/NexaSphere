resource "aws_vpc" "nexaspherevpc" {

  cidr_block = "10.19.0.0/16"

  tags = {
    Name  = var.vpc_name
    Owner = var.owner
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "nexasphere-nodes-subnet" {
  count = 4

  availability_zone = data.aws_availability_zones.available.names[count.index%2]
  cidr_block        = cidrsubnet(aws_vpc.nexaspherevpc.cidr_block, 8, count.index)
  vpc_id            = aws_vpc.nexaspherevpc.id
}