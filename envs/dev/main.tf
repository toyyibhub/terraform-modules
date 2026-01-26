module "ec2" {
  source = "../../modules/ec2"

  ami_id         = "ami-0532be01f26a3de55"
  instance_type = "t2.micro"
  instance_name = "dev-ec2"
  env            = var.env
}

module "s3" {
  source = "../../modules/s3"

  bucket_name = "my-simple-dev-bucket-12345"
  env         = var.env
}


module "secondec2" {
  source = "../../modules/ec2"

  ami_id         = "ami-0532be01f26a3de55"
  instance_type = "t2.micro"
  instance_name = "dev2-ec2"
  env            = var.env
}