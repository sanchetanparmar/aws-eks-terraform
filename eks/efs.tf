# variable "creation_token" {}
variable "performance_mode" {}

# EFS resource

resource "aws_efs_file_system" "kubetest-dev-efs" {
  creation_token   = "kubetest.${var.cluster-name}"
  performance_mode = "${var.performance_mode}"

  # encrypted        = "true"

  tags {
    Name = "kubetest.${var.cluster-name}"

    # Environment = "${var.environment}"
  }
}

# Terraform code to create a mount target

resource "aws_efs_mount_target" "kubetest-dev-efs" {
  # count          = "${length(data.aws_subnet_ids.kubetest.ids)}"
  count          = "3"
  file_system_id = "${aws_efs_file_system.kubetest-dev-efs.id}"
  subnet_id      = "${data.aws_subnet_ids.kubetest.ids[count.index]}"

  # vpc_security_group_ids = ["${aws_security_group.ingress-efs.id}"]
  security_groups = ["${aws_security_group.ingress-efs.id}"]
}

# data "aws_vpcs" "eks-vpc" {}

data "aws_subnet_ids" "kubetest" {
  vpc_id     = "${aws_vpc.eks-vpc.id}"
  depends_on = ["aws_subnet.eks-subnet"]
}

# ==============
# SG for EFS .
#
resource "aws_security_group" "ingress-efs" {
  name   = "ingress-efs-sg"
  vpc_id = "${aws_vpc.eks-vpc.id}"

  # depends_on = ["aws_subnet.eks-subnet"]

  // NFS
  ingress {
    # security_groups = "${aws_security_group.ingress-efs.id}"
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    cidr_blocks = [
      "${aws_vpc.eks-vpc.cidr_block}",
    ]
  }
  // Terraform removes the default rule
  egress {
    # security_groups = "${aws_security_group.ingress-efs.id}"
    from_port = 0
    to_port   = 0
    protocol  = "tcp"

    cidr_blocks = [
      "${aws_vpc.eks-vpc.cidr_block}",
    ]
  }
}
