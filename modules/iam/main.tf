resource "aws_iam_user" "this" {
  name = var.user_name
  path = "/"

  tags = {
    Team        = var.team
    Environment = var.environment
  }
}