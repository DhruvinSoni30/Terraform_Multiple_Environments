module "ec2" {
  source = "../modules/ec2"

  ami_id            = var.ami_id
  instance_type     = var.instance_type
  availability_zone = var.availability_zone
  name              = var.name
  env               = var.env
  region            = var.region

}
