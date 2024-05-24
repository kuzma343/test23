provider "aws" {
    region     = "eu-north-1"
    access_key =    var.aws_access_key
    secret_key =    var.aws_secret_key
}
resource "aws_instance" "test" {
    availability_zone =  "eu-north-1a"
    ami =  "ami-0fe8bec493a81c7da"
    instance_type = "t3.micro"
    key_name = "lucky"
    vpc_security_group_ids = [aws_security_group.DefaultTerraformSG.id] 
    ebs_block_device {
      device_name = "/dev/sda1"
      volume_size = 18
      volume_type = "standard"
      tags = {
        Name = "root-disk"
      }
    }
    user_data = file("app/install.sh")

    tags = {
      Name ="EC2-instance"
    }
}
resource "aws_security_group" "DefaultTerraformSG" {
  name =  "DefaultTerraformSG"
  description = "Allw 22, 80, 443 inbound taffic"
  
  ingress {
    description = "Allow HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    description = "Allow SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
