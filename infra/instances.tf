resource "aws_key_pair" "note-app-key-pair" {
  key_name = "notes-key"
  public_key = file("notes-key.pub")
}

resource "aws_default_vpc" "notes-app-vpc" {
}

resource "aws_security_group" "notes-app-sg" {
  name = "notes-app-sg"
  description = "this rule created for notes-notes-app"
  vpc_id = aws_default_vpc.notes-app-vpc.id

  ingress  {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8000
    to_port = 8000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "notes-app" {
    for_each = ({
        notes-app-1 = "t2.medium"
        notes-app-2 = "t2.micro"
    })
  key_name = aws_key_pair.note-app-key-pair.key_name
  security_groups = [ aws_security_group.notes-app-sg.name ]
  instance_type = each.value
  ami = var.notes_ami_id
  user_data = file("install.sh")
  root_block_device {
    volume_size = var.notes_app_volume_size
    volume_type = var.notes_app_volume_type
  }

  tags = {
    Name = each.key
  }
}