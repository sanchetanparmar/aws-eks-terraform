# EKS Master Cluster IAM Role
resource "aws_iam_role" "master-cluster" {
  name = "terraform-eks-master-cluster1"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "master-cluster-AmazonEKSClusterPolicy1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.master-cluster.name}"
}

resource "aws_iam_role_policy_attachment" "master-cluster-AmazonEKSServicePolicy1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.master-cluster.name}"
}

# EKS Master Cluster Security Group
resource "aws_security_group" "master-cluster" {
  name        = "terraform-eks-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.eks-vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-master"
  }
}

# ===============================================
resource "aws_security_group" "cluster" {
  name        = "${var.cluster-name}-eks-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.eks-vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.cluster-name}-eks-cluster-sg"
  }
}

resource "aws_security_group_rule" "cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.cluster.id}"
  source_security_group_id = "${aws_security_group.node.id}"
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster-ingress-workstation-https" {
  cidr_blocks       = ["${local.workstation-external-cidr}"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.cluster.id}"
  to_port           = 443
  type              = "ingress"
}

resource "aws_eks_cluster" "eks" {
  name     = "${var.cluster-name}"
  role_arn = "${aws_iam_role.master-cluster.arn}"

  vpc_config {
    security_group_ids      = ["${aws_security_group.cluster.id}"]
    subnet_ids              = ["${aws_subnet.eks-subnet.*.id}"]
    endpoint_private_access = true
  }

  depends_on = [
    "aws_iam_role_policy_attachment.master-cluster-AmazonEKSClusterPolicy1",
    "aws_iam_role_policy_attachment.master-cluster-AmazonEKSServicePolicy1",
  ]
}
