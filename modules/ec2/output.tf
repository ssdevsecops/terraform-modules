  
output "instance1_id" {
  value = element(aws_instance.mywebserver.*.id, 0)
}


output "instance2_id" {
  value = element(aws_instance.mywebserver.*.id, 1)
}
