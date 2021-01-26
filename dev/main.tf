module "mysg" {
  source = "../modules/securitygroup"
  sgtag  = "my_web_accesss"
}

module "myec2" {
  source        = "../modules/ec2"
  instance_type = "t3.micro"
  ec2_count     = 2
  keyname       = "bibek"
  sg_id         = [module.mysg.security_group_id]
}
