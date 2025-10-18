resource "aws_vpc" "samar_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "samar-vpc"
  }
}

resource "aws_internet_gateway" "samar_igw" {
  vpc_id = aws_vpc.samar_vpc.id
  tags = {
    Name = "samar-igw"
  }
}

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.samar_vpc.id
  cidr_block              = "10.0.0.0/20"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true
  tags = { Name = "samar-subnet-public1-eu-west-1a" }
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.samar_vpc.id
  cidr_block        = "10.0.48.0/20"
  availability_zone = "eu-west-1a"
  tags = { Name = "samar-subnet-private1-eu-west-1a" }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.samar_vpc.id
  cidr_block              = "10.0.16.0/20"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true
  tags = { Name = "samar-subnet-public2-eu-west-1b" }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.samar_vpc.id
  cidr_block        = "10.0.64.0/20"
  availability_zone = "eu-west-1b"
  tags = { Name = "samar-subnet-private2-eu-west-1b" }
}

resource "aws_subnet" "public3" {
  vpc_id                  = aws_vpc.samar_vpc.id
  cidr_block              = "10.0.32.0/20"
  availability_zone       = "eu-west-1c"
  map_public_ip_on_launch = true
  tags = { Name = "samar-subnet-public3-eu-west-1c" }
}

resource "aws_subnet" "private3" {
  vpc_id            = aws_vpc.samar_vpc.id
  cidr_block        = "10.0.80.0/20"
  availability_zone = "eu-west-1c"
  tags = { Name = "samar-subnet-private3-eu-west-1c" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.samar_vpc.id
  tags = { Name = "samar-rtb-public" }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.samar_igw.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.samar_vpc.id
  tags = { Name = "samar-rtb-private" }
}

resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.samar_vpc.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public3" {
  subnet_id      = aws_subnet.public3.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private3" {
  subnet_id      = aws_subnet.private3.id
  route_table_id = aws_route_table.private.id
}

resource "aws_flow_log" "public1_allow" {
  log_destination      = var.public_subnet_flow_log_allow_arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ACCEPT"
  subnet_id            = aws_subnet.public1.id
  iam_role_arn         = var.vpc_flow_logs_role_arn
}

resource "aws_flow_log" "public1_deny" {
  log_destination      = var.public_subnet_flow_log_deny_arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "REJECT"
  subnet_id            = aws_subnet.public1.id
  iam_role_arn         = var.vpc_flow_logs_role_arn
}

resource "aws_flow_log" "public2_allow" {
  log_destination      = var.public_subnet_flow_log_allow_arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ACCEPT"
  subnet_id            = aws_subnet.public2.id
  iam_role_arn         = var.vpc_flow_logs_role_arn
}

resource "aws_flow_log" "public2_deny" {
  log_destination      = var.public_subnet_flow_log_deny_arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "REJECT"
  subnet_id            = aws_subnet.public2.id
  iam_role_arn         = var.vpc_flow_logs_role_arn
}

resource "aws_flow_log" "public3_allow" {
  log_destination      = var.public_subnet_flow_log_allow_arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ACCEPT"
  subnet_id            = aws_subnet.public3.id
  iam_role_arn         = var.vpc_flow_logs_role_arn
}

resource "aws_flow_log" "public3_deny" {
  log_destination      = var.public_subnet_flow_log_deny_arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "REJECT"
  subnet_id            = aws_subnet.public3.id
  iam_role_arn         = var.vpc_flow_logs_role_arn
}

resource "aws_flow_log" "private1_allow" {
  log_destination      = var.private_subnet_flow_log_allow_arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ACCEPT"
  subnet_id            = aws_subnet.private1.id
  iam_role_arn         = var.vpc_flow_logs_role_arn
}

resource "aws_flow_log" "private1_deny" {
  log_destination      = var.private_subnet_flow_log_deny_arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "REJECT"
  subnet_id            = aws_subnet.private1.id
  iam_role_arn         = var.vpc_flow_logs_role_arn
}

resource "aws_flow_log" "private2_allow" {
  log_destination      = var.private_subnet_flow_log_allow_arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ACCEPT"
  subnet_id            = aws_subnet.private2.id
  iam_role_arn         = var.vpc_flow_logs_role_arn
}

resource "aws_flow_log" "private2_deny" {
  log_destination      = var.private_subnet_flow_log_deny_arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "REJECT"
  subnet_id            = aws_subnet.private2.id
  iam_role_arn         = var.vpc_flow_logs_role_arn
}

resource "aws_flow_log" "private3_allow" {
  log_destination      = var.private_subnet_flow_log_allow_arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ACCEPT"
  subnet_id            = aws_subnet.private3.id
  iam_role_arn         = var.vpc_flow_logs_role_arn
}

resource "aws_flow_log" "private3_deny" {
  log_destination      = var.private_subnet_flow_log_deny_arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "REJECT"
  subnet_id            = aws_subnet.private3.id
  iam_role_arn         = var.vpc_flow_logs_role_arn
}

