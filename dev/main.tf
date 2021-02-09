module "myvpc" {
  source        = "../modules/vpc"
  vpc_cidr      = "10.0.0.0/16"
  public_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
}

module "mysg" {
  source = "../modules/securitygroup"
  vpc    = module.myvpc.vpc_id
  sgtag  = "my_web_accesss"
}

module "myec2_webapp" {
  source        = "../modules/ec2"
  instance_type = "t3.micro"
  ec2_count     = 2
  keyname       = "bibek"
  sg_id         = [module.mysg.security_group_id]
  subnets       = module.myvpc.public_subnets
  instance_name = "WebApp"
}

module "myec2_dataapp" {
  source        = "../modules/ec2"
  instance_type = "t3.micro"
  ec2_count     = 2
  keyname       = "gigi"
  sg_id         = [module.mysg.security_group_id]
  subnets       = module.myvpc.private_subnets
  instance_name = "DataApp"
}
