resource "aws_security_group" "rds-ec2-1" {
  name        = "rds-ec2-1"
  description = "rds-ec2-1"

  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow MySQL traffic"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]   # Only allow traffic from Ec2 instance. Secured!
  }

  tags = {
    Name = "rds-ec2-1"
  }
}


resource "aws_security_group" "ec2-rds-1" {
  name        = "ec2-rds-1"
  description = "ec2-rds-1"

  vpc_id      = aws_vpc.main.id

  egress {
    description = "Allow MySQL traffic"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.rds-ec2-1.id]   # Allow MySQL traffic from RDS instance. Secured!
  }

  tags = {
    Name = "ec2-rds-1"
  }
}





resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Security group for the ec2 instance"
  
  vpc_id      = aws_vpc.main.id

  
  ingress {
    description = "Allow MySQL traffic"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # WARNING: Allowing MySQL from all IPs; restrict to your IP if possible.
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-security-group"
  }
}




output "rds-ec2-1-sg" {
    value = aws_security_group.rds-ec2-1.id
}


output "ec2-rds-1-sg" {
    value = aws_security_group.ec2-rds-1.id
}


output "instance_sg_id" {
    value = aws_security_group.ec2_sg.id
}