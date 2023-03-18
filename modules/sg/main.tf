resource "aws_security_group" "sg" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  ingress {
    description     = var.description
    from_port       = var.from_port
    to_port         = var.to_port
    protocol        = "TCP"
    cidr_blocks     = var.cidr_blocks
    security_groups = var.security_groups
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = var.name
  }

}
