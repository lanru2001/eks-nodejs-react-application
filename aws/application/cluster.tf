#Get caller identity 
data "aws_caller_identity" "current" {}

#EKS Cluster 
resource "aws_eks_cluster" "eks_cluster" {
  name                      = var.cluster_name
  version                   = var.eks_version 
  role_arn                  = aws_iam_role.eks_cluster_role.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  
   vpc_config {
    subnet_ids         = [ aws_subnet.app_public_subnets[0].id  , aws_subnet.app_public_subnets[1].id, aws_subnet.app_private_subnets[0].id  ]
    security_group_ids =  [ aws_security_group.eks_security_group.id ]
  }
   
   tags = {
     Name    = "eks-cluster-${var.name}"
   }
}

resource "aws_cloudwatch_log_group" "eks_cluster" {
  name              = "/aws/eks/${var.name}-${var.environ}/cluster"
  retention_in_days = 30

  tags = {
    Name        = "${var.name}-${var.environ}-eks-cloudwatch-log-group"
    Environment = var.environ
  }
}

#EKS Addon - Amazon VPC CNI(Enable pod networking within your cluster)
# aws_eks_addon.amazon_vpc_cni:
resource "aws_eks_addon" "amazon_vpc_cni" {
    addon_name    = "vpc-cni"
    addon_version = "v1.17.1-eksbuild.1"
    cluster_name  = aws_eks_cluster.eks_cluster.name
}

#EKS Addon - coredns(Enable service discovery within your cluster)
# aws_eks_addon.core_dns:
resource "aws_eks_addon" "core_dns" {
    addon_name    = "coredns"
    addon_version = "v1.10.1-eksbuild.7"
    cluster_name  = aws_eks_cluster.eks_cluster.name

}

#EKS Addon - kube proxy (Enable service networking within your cluster)
# aws_eks_addon.kube_proxy:
resource "aws_eks_addon" "kube_proxy" {
    addon_name    = "kube-proxy"
    addon_version = "v1.28.6-eksbuild.2"
    cluster_name  = aws_eks_cluster.eks_cluster.name

}

#Enable Elastic Block Storage(EBS) within the cluster
resource "aws_eks_addon" "ebs_csi-driver" {
    addon_name    = "aws-ebs-csi-driver"
    addon_version = "v1.28.0-eksbuild.1"
    cluster_name  = aws_eks_cluster.eks_cluster.name
}

#It is actually possible to run the entire cluster fully on Fargate, but it requires some tweaking of the CoreDNS deployment
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name                = aws_eks_cluster.eks_cluster.name
  node_group_name             = var.node_grp_name
  node_role_arn               = aws_iam_role.eks_worker_nodes.arn 
  subnet_ids                  = [ aws_subnet.app_public_subnets[0].id ] 
  instance_types              =  [var.instance_type]
  disk_size                   = var.disk_size

  remote_access {
    ec2_ssh_key               = var.keypair
    source_security_group_ids = [ aws_security_group.eks_security_group.id ]
    
  }
  
  scaling_config {
    desired_size = 3
    max_size     = 4
    min_size     = 3
  }

}
