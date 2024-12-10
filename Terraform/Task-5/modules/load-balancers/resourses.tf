resource "aws_lb" "lb-backend" {
  name               = "lb-backend"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.lb-private_sg_id]
  subnets            = var.private-subnet_id
  enable_deletion_protection = false
  tags = {
    Name = "lb-backend"
  }
}
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.lb-backend.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_tg.arn
  }
  
}
resource "aws_lb_target_group" "private_tg" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.my-vpc_id

 health_check {
    enabled  = true
    healthy_threshold = 2
    interval = 30
    path     = "/"
    port     = "80"
    protocol = "HTTP"
    timeout  = 5
    unhealthy_threshold = 2
  }
  stickiness {
    type            = "lb_cookie"
    enabled         = true
    cookie_duration = 5  # Sets stickiness duration to 60 seconds
  }



  tags = {
    Name = "TargetGroup"
  }
}

resource "aws_lb_target_group_attachment" "ec2_instance_attachment" {
  count = 2
  target_group_arn = aws_lb_target_group.private_tg.arn
  target_id        = var.private_ec2_id[count.index]
  port             = 80
  
}

# Application Load Balancer
resource "aws_lb" "lb-web" {
  name               = "lb-web"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.lb-public_sg_id]
  subnets            = var.public-subnet_id

  enable_deletion_protection = false

  tags = {
    Name = "lb-web"
  }
}

resource "aws_lb_listener" "http_listener2" {
  load_balancer_arn = aws_lb.lb-web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pub_tg.arn
  }
}

resource "aws_lb_target_group" "pub_tg" {
  name     = "public-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.my-vpc_id
  tags = {
    Name = "Public-TargetGroup"
  }
}

resource "aws_lb_target_group_attachment" "ec2_instance_1_attachment" {
  count = 2
  target_group_arn = aws_lb_target_group.pub_tg.arn
  target_id        = var.public_ec2_id[count.index]
  port             = 80
}









