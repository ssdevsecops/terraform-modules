resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

data "aws_subnet_ids" "subnet" {
  vpc_id = aws_default_vpc.default.id
}

resource "aws_lb_target_group" "mytargetgroup" {
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
  name        = "mytargetgroup"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_default_vpc.default.id
}

/*resource "aws_lb_target_group_attachment" "ec2_attach1" {
  target_group_arn = aws_lb_target_group.mytargetgroup.arn
  target_id        = var.instance1_id
}

resource "aws_lb_target_group_attachment" "ec2_attach2" {
  target_group_arn = aws_lb_target_group.mytargetgroup.arn
  target_id        = var.instance2_id
}*/


resource "aws_lb" "myalb" {
  name               = "myalb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.subnet.ids
  ip_address_type    = "ipv4"
  security_groups    = [var.sg]
  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "myalb" {
  load_balancer_arn = aws_lb.myalb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mytargetgroup.arn
  }
}




