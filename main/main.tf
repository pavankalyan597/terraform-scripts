module "vpc" {
  source = "/home/ec2-user/terraform/modules/vpc"
}

module "ec2" {
  source            = "/home/ec2-user/terraform/modules/ec2"
  subnet            = module.vpc.subnet_id
  security_group_id = module.vpc.sg_id
}

module "alb" {
  source      = "/home/ec2-user/terraform/modules/alb"
  vpc_id      = module.vpc.vpc_id
  alb_sg      = module.vpc.alb_sg
  subnet1     = module.vpc.subnet_id
  subnet2     = module.vpc.subnet_id_2
  instance_id = module.ec2.instance_id
}

module "asg" {
  source = "/home/ec2-user/terraform/modules/asg"
  sg_id = module.vpc.sg_id
  subnet1 = module.vpc.subnet_id
  subnet2 = module.vpc.subnet_id_2
  target_1_arn = module.alb.target_1_arn  
}
