resource "aws_iam_user" "users" {
  for_each = toset(var.iamusers)
  name     = each.value
}
