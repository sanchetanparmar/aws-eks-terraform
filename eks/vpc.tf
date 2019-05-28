#
# VPC Resources

variable cluster-name {}

variable "aws-region" {}
variable "vpc-subnet-cidr" {}

resource "aws_vpc" "eks-vpc" {
  cidr_block           = "${var.vpc-subnet-cidr}"
  enable_dns_hostnames = true

  tags = "${
    map(
     "Name", "${var.cluster-name}-eks-vpc",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_subnet" "eks-subnet" {
  count = 3

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "${cidrsubnet(var.vpc-subnet-cidr, 8, count.index )}"
  vpc_id            = "${aws_vpc.eks-vpc.id}"

  tags = "${
    map(
     "Name", "${var.cluster-name}-eks",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "eks-eks-igw" {
  vpc_id = "${aws_vpc.eks-vpc.id}"

  tags {
    Name = "${var.cluster-name}-eks-igw"
  }
}

resource "aws_route_table" "eks-routetable" {
  vpc_id = "${aws_vpc.eks-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.eks-eks-igw.id}"
  }
}

resource "aws_route_table_association" "eks-routetable" {
  count = 3

  subnet_id      = "${aws_subnet.eks-subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.eks-routetable.id}"
}
