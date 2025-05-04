resource "aws_instance" "ssm-ec2-rds" {

  ami           = "ami-016038ae9cc8d9f51"    # Amazon Linux 2023 AMI
  instance_type = "t3.micro"

  subnet_id = aws_subnet.public_subnet_1.id

  instance_initiated_shutdown_behavior = "terminate"
  
  associate_public_ip_address = true
  
  security_groups = [aws_security_group.ec2_sg.id, aws_security_group.ec2-rds-1.id]

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name
  
  user_data = base64encode(file("user_data.sh"))
  
  monitoring             = true  # enables 1-minute granularity instead of default 5-minute

#   Only basic cloud watch metrics will be sent to cloud watch; 
#   CPU-Utilization (% of EC2 instance's CPU used), 
#   NetworkIn / NetworkOut (Bytes received/sent on all interfaces)
#   DiskReadBytes / DiskWriteBytes (Total bytes read/written to disk)
#   DiskReadOps / DiskWriteOps (Number of I/O operations)
#   StatusCheckFailed	(1 if system or instance check failed)

# If you need detailed logs, you need to install cloud watch agent.


  tags = {
    Name = var.ec2_name
  }
}


output "instance_id" {
    value = aws_instance.ssm-ec2-rds.id
}