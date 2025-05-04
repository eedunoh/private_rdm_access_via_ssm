

# Something to note when defining policies;   "Effect": "Allow"  OR  Effect = "Allow" can be used. 

# They can be used interchangably

# JSON uses colons (:) and double quotes ("") 
# WHILE 
# Terraform HCL uses equals signs (=) without quotes for keys.



resource "aws_iam_role" "rds_monitoring" {
  name = "rds-enhanced-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      },
      Effect = "Allow",
      Sid    = ""
    }]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_attachment" {
  role       = aws_iam_role.rds_monitoring.name

  # This allows RDS to write Enhanced Monitoring metrics to CloudWatch. (Enhanced Monitoring, Performance Insights and Log Exports)

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}




# Create a role that grant permissions/Allows EC2 instances access to Systems Manager (SSM), including: Session Manager (for SSH-less access), 
# Run Command, Patch Manager, Inventory, and send logs to CloudWatch

resource "aws_iam_role" "ssm_ec2" {
  name = "ssm-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Effect = "Allow",
      Sid    = ""
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_ec2_attachment" {
  role       = aws_iam_role.ssm_ec2.name

  # This policy lets SSM Agent on your EC2 instance: Register with SSM. Receive commands from SSM (like start-session or install CloudWatch agent).
  # Use Parameter Store or Secrets Manager if needed.

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"      
}


resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm-ec2-instance-profile"
  role = aws_iam_role.ssm_ec2.name
}




output "rds_role_arn" {
  value = aws_iam_role.rds_monitoring.arn
}


output "ec2_instance_profile" {
    value = aws_iam_instance_profile.ssm_instance_profile.name
}
