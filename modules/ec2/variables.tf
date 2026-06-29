variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "env" {
  type = string
}

variable "key_name" {
  description = "AWS EC2 Key Pair name"
  type        = string
}