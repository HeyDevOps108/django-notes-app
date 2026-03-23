output "notes_app_public_ip" {
  value = aws_instance.notes-app.public_ip
}

output "notes_app_private_ip" {
  value = aws_instance.notes-app.private_ip
}

output "notes_app_public_dns" {
  value = aws_instance.notes-app.public_dns
}

