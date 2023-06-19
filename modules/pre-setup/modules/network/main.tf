resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true 
  tags = {
    Name = "${var.name}-VPC"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "IGW-${var.name}"
  }
}

resource "aws_route_table" "routeTable" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "RouteTable-${var.name}"
  }
}

resource "aws_subnet" "subnets" {
  count     = 8
  vpc_id    = "${aws_vpc.vpc.id}"
  cidr_block = "${cidrhost(var.vpc_cidr, count.index * 32)}/27"
  availability_zone = count.index % 2 == 0 ? "${var.region}a" : "${var.region}b"
  tags = {
    Name = "PrivateSubnet-${var.name}-${count.index}-${element(["Database", "Database", "Serverless", "Serverless", "Containers", "Containers", "Compute", "Compute"], count.index)}"
  }
}
 
resource "aws_route_table_association" "rt_associate" {
  count          = length(aws_subnet.subnets)
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.routeTable.id
}

resource "aws_security_group" "core_sg" {
    name = "SG-${var.name}-CUSTOM"
    vpc_id = "${aws_vpc.vpc.id}"
    tags = {
        Name = "SG-${var.name}-CUSTOM"
    }
    ingress  {
        cidr_blocks = [ "0.0.0.0/0" ]
        ipv6_cidr_blocks = ["::/0"]
        description = "Allow HTTP for all"
        from_port = 80 
        protocol = "tcp"  
        to_port = 80
        prefix_list_ids = []
        security_groups = []
        self    = false
    } 
    ingress  {
        cidr_blocks = [ "0.0.0.0/0" ]
        ipv6_cidr_blocks = ["::/0"]
        description = "Allow HTTPs for all"
        from_port = 443 
        protocol = "tcp"  
        to_port = 443
        prefix_list_ids = []
        security_groups = []
        self    = false
    }
    ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    } 
    egress = [ {
        cidr_blocks = [ "0.0.0.0/0" ]
        ipv6_cidr_blocks = ["::/0"]
        description = "Allow all"
        from_port = 0
        protocol = "-1" 
        to_port = 0
        prefix_list_ids = []
        security_groups = []
        self    = false
    } ]
}