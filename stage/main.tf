module "mysg" {
  source = "../modules/securitygroup"
  sgtag  = "my_web_accesss"
}


module "myalb" {
  source = "../modules/alb"
  sg     = module.mysg.security_group_id
}


module "myasg" {
  source           = "../modules/auto_scaling"
  target_group_arn = module.myalb.albtargetgroup_arn
  sg               = module.mysg.security_group_id
  instance_type    = "t2.micro"
  keyname          = "bibek"

}
