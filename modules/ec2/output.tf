
output "instance1_id" {
  value = element(aws_instance.mywebserver.*.id, 1)
}

output "instance2_id" {
  value = element(aws_instance.mywebserver.*.id, 2)
}

output "private_ip" {
  value = aws_instance.mywebserver.*.private_ip
}


output "public_ip" {
  value = aws_instance.mywebserver.*.public_ip
}
