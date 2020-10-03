
##################################################################
# SEcurity Groups 
##################################################################
#security group for ALB
resource "aws_security_group" "sg_elb" {
  name        = "sg_elb"
  description = "Ports for the kubernets nodeports"
  vpc_id      = data.aws_vpc.task-vpc.id
  revoke_rules_on_delete = true

  ingress {
    description = "security_groups for ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_elb"
  }
}

#security group for EC2
resource "aws_security_group" "sg_ec2" {
  name        = "sg_ec2"
  description = "security_groups for EC2"
  vpc_id      = data.aws_vpc.task-vpc.id
    

  ingress {
    description = "security_groups for ec2-instance"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [ aws_security_group.sg_elb.id ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_ec2"
  }
}
