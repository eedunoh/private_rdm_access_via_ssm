resource "aws_db_instance" "default" {
  identifier             = var.rds_identifier
  engine                 = "mysql"
  engine_version         = "8.0.41"
  instance_class         = "db.t3.medium"

  username               = var.db_username
  password               = var.db_password
  port                   = 3306

  db_name                = var.initial_database_name         # Initial schema like "artisanapp"
  allocated_storage      = 20                                # GB of disk space
  
  deletion_protection    = false
  skip_final_snapshot    = true
  publicly_accessible    = false


  availability_zone      = var.first_az
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds-ec2-1.id]


  # Enable Performance Insights
  performance_insights_enabled       = true
  #   performance_insights_retention_period = 2  # Retain data for 2 days
  
  # Enabling Enhanced Monitoring
  monitoring_role_arn   = aws_iam_role.rds_monitoring.arn
  monitoring_interval   = 60 # Required when using a monitoring role for Enhanced Monitoring
  
  # Exporting logs to CloudWatch
  enabled_cloudwatch_logs_exports = ["error", "slowquery", "general", "audit"]

  depends_on             = [aws_instance.ssm-ec2-rds]  # Ensure EC2 is created first (if relevant)
}
