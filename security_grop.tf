
# =====================================================
# Creating Security Group - bastion
# =====================================================

resource "aws_security_group" "bastion" {
    
  name        = "${var.project}-bastion"
  description = "Allows 22 traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress     = [
      
  {
    description      = ""
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
    prefix_list_ids  = []
    security_groups  = []
    self             = false 
  }

  ]
      
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags     = {
    Name    = "${var.project}-bastion"
    project = var.project
  }
}
# =====================================================
# Creating Security Group - frontend
# =====================================================

resource "aws_security_group" "frontend" {   
  name        = "${var.project}-frontend"
  description = "Allows 80 from all,22 from bastion"
  vpc_id      = aws_vpc.vpc.id
  ingress     = [ 
      
  {
    description      = ""
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [ aws_security_group.bastion.id ]
    prefix_list_ids  = []
    cidr_blocks      = []
    ipv6_cidr_blocks = []
    self             = false 
  },
  {
    description      = ""
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
    prefix_list_ids  = []
    security_groups  = []
    self             = false 
  },
  {
    description      = ""
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
    prefix_list_ids  = []
    security_groups  = []
    self             = false 
  }

  ]
      
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags     = {
    Name    = "${var.project}-frontend"
    project = var.project
  }
}



# =====================================================
# Creating Security Group - backend
# =====================================================

resource "aws_security_group" "backend" {
    
  name        = "${var.project}-backend"
  description = "Allows 3306 from frontend,22 from bastion"
  vpc_id      = aws_vpc.vpc.id
  ingress     = [ 
      
  {
    description      = ""
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [ aws_security_group.bastion.id ]
    prefix_list_ids  = []
    cidr_blocks      = []
    ipv6_cidr_blocks = []
    self             = false 
  },
  {
    description      = ""
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = [ aws_security_group.frontend.id ]
    prefix_list_ids  = []
    cidr_blocks      = []
    ipv6_cidr_blocks = []
    self             = false 
  }
  ]
      
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags     = {
    Name    = "${var.project}-backend"
    project = var.project
  }
}