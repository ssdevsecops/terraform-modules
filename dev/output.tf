output "private_ip" {
  value = module.myec2_dataapp.private_ip
}

output "public_ip" {
  value = module.myec2_webapp.public_ip
}
