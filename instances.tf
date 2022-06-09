provider "aws" {
region = "us-east-1"
access_key = "AKIA5HPA5JMVZQVD57B3"
secret_key = "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"
}

data "aws_ami" "app_ami" {
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  most_recent = true
  owners = ["amazon"]
}

resource "aws_instance" "ec2-<daniel>_3" {
	ami = data.aws_ami.app_ami.id
	instance_type = "var.instancetype"
	key_name = "wevops-daniel"
	vpc_security_group_ids = ["${aws_security_group.allow_http_https.id}"]

}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "aws_instance.ec2-<daniel>_3.id"
  allocation_id = "aws_eip.eip.id"
}

resource "aws_eip" "eip" {
  instance = "aws_instance.ec2-<daniel>_3.id"
  vpc      = true
}

resource "aws_security_group" "allow_http_https" {
  name        = "allow_http_https"
  description = "Allow TLS inbound traffic"

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_https"
  }
}
