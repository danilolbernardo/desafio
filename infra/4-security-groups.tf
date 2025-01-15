resource "aws_security_group" "eks_security_group" {
  vpc_id = aws_vpc.eks_vpc.id
  name   = "eks-sg"
  tags = {
    Name = "eks-security-group"
  }
}

resource "aws_security_group_rule" "allow_alb_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_security_group.id
}

resource "aws_security_group_rule" "allow_worker_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_security_group.id
}