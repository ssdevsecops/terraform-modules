data "aws_ami" "amazonlx" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "mywebserver" {
  ami                    = data.aws_ami.amazonlx.id
  count                  = var.ec2_count
  instance_type          = var.instance_type
  key_name               = var.keyname
  vpc_security_group_ids = var.sg_id
  subnet_id              = element(var.subnets, count.index)

  user_data = <<-EOF
                #! /bin/bash
                yum update -y
                yum install httpd -y
                systemctl start httpd
                systemctl enable httpd
                echo "The hostname is: `hostname`." > /var/www/html/index.html
                EOF
  tags = {
    Name = "${var.instance_name} ${count.index + 1}"
  }
}







