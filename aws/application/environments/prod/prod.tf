# S3 remote state 

terraform {
 backend "s3" {
    bucket         = "tf-state-file3"  
    key            = "project/prod/ecs"
    region         = "us-east-2"
    dynamodb_table = "eks_ecommerce_dynamodb"

 }
}

module "node_ecs". {

   source                    = ../../
   vpc_cidr                  = "172.31.0.0/16"
   public_subnets_cidr       = [ "172.31.6.0/24" , "172.31.7.0/24" ]
   private_subnets_cidr      = [ "172.31.8.0/24" , "172.31.9.0/24" ]
   create                    = true
   name                      = "node"
   namespace                 = "lightfeather"
   docker_image              = "873079457075.dkr.ecr.us-east-2.amazonaws.com/node-app:latest"
   environment               = "nodejs"
   stage                     = "dev"
   aws_region                = "us-east-2"
   azs                       = ["us-east-2a" , "us-east-2b"]
   cloudwatch_log_group_name = "ecs/lightfeather-nodejs-dev"
   cloudwatch_log_stream     = "ecs"
   bucket_name               = "lightfeather-lb-logs"
   node_container_port       = "80"
   name_prefix               = "light-app"
   health_check_path         = "/robots.txt"
   ami_id                    = "ami-03d64741867e7bb94"
   #public_subnet_id         =  { "subnet-097c6f21a3fc9e20a" }
   PATH_TO_PUBLIC_KEY        = "mykey.pub"
   PATH_TO_PRIVATE_KEY       = "mykey"
   db_name                   = "eks_db"
   db_instance_port          = 3306
   username                  = "mysqladmin" 
   password                  = "opensourceiseverywhere"  #Password in SSM parameter store
   family                    = "mysql5.7"
   private_subnet_id         = "subnet-0c6700f2915010226" 
   engine                    = "mysql"
   engine_version            = "5.7.26"
   instance_class            = "db.t2.micro"
   tag                       = "app-dev"
   container_port            = 80
   disk_size                 = 10
   pvt_desired_size          = 2
   pvt_max_size              = 2
   pvt_min_size              = 2
   publ_desired_size         = 2
   publ_max_size             = 2
   publ_min_size             = 2
   desired_size              = 2 
   instance_type             = "t2.medium" 
   identifier                = "node-react-app-db"
   #certificate_arn           = 
}