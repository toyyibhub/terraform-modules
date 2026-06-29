module "ec2" {
  source = "../../modules/ec2"

  ami_id         = "ami-0b6d9d3d33ba97d99"
  instance_type = "t2.micro"
  instance_name = "qa-ec2"
  env            = var.env
  key_name       = "practise-kp"
}

module "s3" {
  source = "../../modules/s3"

  bucket_name = "my-simple-qa-bucket-12345"
  env         = var.env
}

module "iam_user" {
  source = "../../modules/iam"

  user_name   = "john.giwa"
  team        = "DevOps"
  environment = "qa"
}