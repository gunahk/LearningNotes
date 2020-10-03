
##################################################################
# Create ALB and attach ec2 to target groups
##################################################################

resource "aws_lb" "task-alb" {
  name               = "task-alb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.sg_elb.id ]
  subnets            = [for s in data.aws_subnet.example : s.id ]

  enable_deletion_protection = true

  tags = {
    Environment = "task-alb"
  }
}


resource "aws_lb_target_group" "task-alb-tg" {
  name     = "task-alb-tg"
  port     = 3200
  protocol = "HTTP"
  vpc_id   =  data.aws_vpc.task-vpc.id
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.task-alb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.task-alb-tg.arn
  }
}

resource "aws_alb_target_group_attachment" "test" {
  count = length(aws_instance.web)
  target_group_arn = aws_lb_target_group.task-alb-tg.arn
  target_id = aws_instance.web[count.index].id
}
