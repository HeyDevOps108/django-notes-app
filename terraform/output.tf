output "notes_app_public_ip" {
  value = {
    for key, instance in aws_aws_instance.notes-app : 
    key => instance.public_ip
  }
}

output "notes_app_private_ip" {
  value = {
    for key, instance in aws_aws_instance.notes-app :
    key => instance.private_ip
  }
}

output "notes_app_public_dns" {
  value = {
    for key, instance in aws_aws_instance.notes-app :
    key => instance.public_dns
  }
}

