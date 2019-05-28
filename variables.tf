# Variables Configuration

variable "aws_zone_name" {
  default     = "region1.env.root.domain"
  type        = "string"
  description = "FQDN of the cluster"
}

variable "cluster-name" {
  default     = "my-cluster1"
  type        = "string"
  description = "The name of your EKS Cluster"
}

variable "aws-region" {
  default     = "us-east-1"
  type        = "string"
  description = "The AWS Region to deploy EKS"
}

variable "k8s-version" {
  default     = "1.12"
  type        = "string"
  description = "Required K8s version"
}

variable "vpc-subnet-cidr" {
  default     = "10.0.0.0/16"
  type        = "string"
  description = "The VPC Subnet CIDR"
}

variable "node-instance-type" {
  default     = "t2.medium"
  type        = "string"
  description = "Worker Node EC2 instance type"
}

variable "desired-capacity" {
  default     = 1
  type        = "string"
  description = "Autoscaling Desired node capacity"
}

variable "max-size" {
  default     = 5
  type        = "string"
  description = "Autoscaling maximum node capacity"
}

variable "min-size" {
  default     = 1
  type        = "string"
  description = "Autoscaling Minimum node capacity"
}

# For EFS

variable "performance_mode" {
  description = "performance mode of your file system."
  type        = "string"
  default     = "generalPurpose"
}

# variable "environment" {
#   type    = "string"
#   default = "dev"
# }

variable "creation_token" {
  description = "toket for efs."
  type        = "string"
  default     = "kubetest"
}

variable "bootstrap_arguments" {
  default     = ""
  description = "Additional arguments when bootstrapping the EKS node."
}

variable "node-userdata" {
  default     = ""
  description = "Additional user data used when bootstrapping the EC2 instance."
}

variable "subnet_count" {
  default = "3"
}
