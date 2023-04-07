# S3 remote state 
terraform {
 backend "s3" {
    bucket         = "tf-remote-dev-bkt"  
    key            = "project/DLFrame/eks"
    region         = "us-east-1"
    dynamodb_table = "DLFrame_state_locking"

 }
} 

module "dev_eks" {
    
    source                    = "../../"
    public_subnets_cidr       = 
    private_subnets_cidr      = 
    vpc_cidr                  = 
    create                    = true
    name                      = 
    namespace                 = 
    stage                     = "dev"
    azs                       = [
    cloudwatch_log_group_name = "user-app-eks-dev"
    cloudwatch_log_stream     = "eks"
    name_prefix               = "user-app"
    tag                       = "user-app-dev"
    disk_size                 = 20
    cluster_name              = "user-app-dev"
    PATH_TO_PUBLIC_KEY        = "mykey.pub"
    PATH_TO_PRIVATE_KEY       = "mykey"
    kubernetes_version        = "1.23"
    node_grp_name             = "user-app_node_group"
    ami_id                    = "ami-08e637cea2f053dfa"
    keypair                   = "mykeypair"
    domain                    = "user-app"
    environ                   = "dev"

}
