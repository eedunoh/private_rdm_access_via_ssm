variable "region" {
  default = "eu-north-1"
  description = "aws region"
  type = string
}


variable "first_az" {
    default = "eu-north-1a"
    description = "first availability zone in the region"
    type = string
}


variable "vpc_cidr" {
    default = "10.0.0.0/16"
    description = "vpc cidr block"
    type = string
}


variable "vpc_name" {
    default = "private_rds_vpc"
    description = "aws vpc name"
    type = string 
}


variable "ec2_name" {
    default = "ssm-ec2-rds"
    description = "ec2 name for secure connection to private RDS"
    type = string
}


variable "rds_identifier" {
    default = "database1"
    description = "my private RDS identifier"
    type = string
}


variable "initial_database_name" {
    default = "dbfinance"
    description = "initial database name for my private RDS"
    type = string
}


variable "db_username" {
    default = "testingadmin"
    description = "db admin username for testing"
    type = string
}


variable "db_password" {
    default = "Admin1234ed"   # I'm using this for testing. Replace this with real password but make it secure!
    description = "db password for testing"
    type = string
}