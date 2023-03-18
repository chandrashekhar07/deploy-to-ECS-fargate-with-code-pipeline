#Create target group
resource "aws_alb_target_group" "alb_tg" {
  name = "${var.namespace}-${var.stage}-alb-tg"
  port = var.port

  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path    = var.health_check_path
    timeout = 5
  }
}


// Host based routing rules
resource "aws_alb_listener_rule" "host_based" {
  listener_arn = var.alb_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_tg.arn
  }

  condition {
    host_header {
      values = var.hosts
    }
  }
}
