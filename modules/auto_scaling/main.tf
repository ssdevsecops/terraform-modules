data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}


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

resource "aws_launch_configuration" "mylc" {
  image_id        = data.aws_ami.amazonlx.id
  instance_type   = var.instance_type
  security_groups = [var.sg]
  key_name = var.keyname

  user_data = <<-EOF
                #! /bin/bash
                yum update -y
                yum install httpd -y
                systemctl start httpd
                systemctl enable httpd
                echo "The hostname is: `hostname`." > /var/www/html/index.html
                EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_placement_group" "spread" {
  name     = "spread"
  strategy = "spread"
}

resource "aws_autoscaling_group" "myasg" {
  launch_configuration = aws_launch_configuration.mylc.name
  min_size             = 2
  max_size             = 4
  desired_capacity     = 2
  health_check_type    = "EC2"
  vpc_zone_identifier  = data.aws_subnet_ids.all.ids
  target_group_arns    = [var.target_group_arn]
  placement_group      = aws_placement_group.spread.id
  lifecycle {
    create_before_destroy = true
  }

  tags = [
    {
      key                 = "Environment"
      value               = "stage"
      propagate_at_launch = true
    }
  ]
}

resource "aws_autoscaling_policy" "cpu" {
  name                      = "cpu-auto-scaling"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.myasg.name
  estimated_instance_warmup = 200
  
  target_tracking_configuration {
predefined_metric_specification {
predefined_metric_type = "ASGAverageCPUUtilization"
}
  target_value = 50
}
}
