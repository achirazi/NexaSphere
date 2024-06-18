resource "aws_vpc" "nexaspherevpc" {

  cidr_block = local.cidr_block

  tags = {
    Name  = var.vpc_name
    Owner = var.owner
  }
}

resource "aws_subnet" "nexasphere-nodes-subnet" {
  count = 4

  availability_zone = data.aws_availability_zones.available.names[count.index % 2]
  cidr_block        = cidrsubnet(aws_vpc.nexaspherevpc.cidr_block, 8, count.index)
  vpc_id            = aws_vpc.nexaspherevpc.id
}

resource "aws_security_group" "nexasphere-security-group" {
  name        = "nexasphere-sec-group"
  description = "Security group used to whitelist IPs for cluster access"
  vpc_id      = aws_vpc.nexaspherevpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = local.allowed_ips
    description = "Ingress rule for SSH access of whitelisted IPs"
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = local.allowed_ips
    description = "Egress rule for SSH access of whitelisted IPs"
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "HTTP"
    cidr_blocks = local.allowed_ips
    description = "Egress rule for HTTP access of whitelisted IPs"
  }
}
