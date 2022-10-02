# AWS EC2 Instance Module
module "ec2_public" {
  depends_on = [
    module.vpc
  ]
  
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.4"

  name = "${local.name}-BastionHost"

  ami = data.aws_ami.amz_linux2.id
  instance_type = var.instance_type
  key_name = var.instance_keypair

  vpc_security_group_ids = [module.public_bastion_sg.security_group_id]
  subnet_id = module.vpc.public_subnets[0]

  tags = local.common_tags
}