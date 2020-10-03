##################################################################
# Crete Ec2 instances
##################################################################


resource "aws_instance" "web" {

  ami                    = "ami-0dba2cb6798deb6d8"
  instance_type          = "t2.micro"
  key_name               = "demo"
  vpc_security_group_ids  = [ aws_security_group.sg_ec2.id ]
  

  count = 2
  subnet_id = sort(data.aws_subnet_ids.example.ids)[count.index]
  associate_public_ip_address  = false
  
  tags = {
    Terraform   = "true"
    Environment = "SRS-task"
    name = "SRS-task"
    Name = "SRS-task"
  }

}

