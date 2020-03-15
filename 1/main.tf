provider "aws" {
		access_key= "XXXX"
		secrect_key = "XXXX"
		region = "XXXX"
		}

#VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16" #example
}

#Subnet for web server 
resource "aws_subnet" "webserver" {
  vpc_id     = "${aws_vpc.vpc.id}"
  name       = "webserver"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

#Security group for web server  
resource "aws_security_group" {
  name        = "webserver_sg"
  description = "Allow port 22 for SSH, port 80 and port 443 for http and https"
  vpc_id      = "${data.aws_vpc.vpc.id}"
  egress_rules = ["http-80-tcp", "ssh-22-tcp","https-443-tcp"]
  igress_rules = ["http-80-tcp","https-443-tcp"]
}

#ec2 instance for web server
resource "ec2" {
       instance_count = 1
       name  = "webserver_ec2"
       ami   = "${data.aws_ami.amazon_linux.id}"
       instance_type = "t2.micro"
       subnet_id     = "${aws_subnet.webserver.id}"
       vpc_security_group_ids  = "${aws_security_group.webserver_sg.id}"
       associate_public_ip_address = true
}

#Elastic ip address for web server ec2 instance
resource "aws_eip" "x.x.x.x" {
  instance = "${aws_instance.webserver_ec2.id}"
  vpc      = true
}

#Subnet for app servers
resource "aws_subnet" "appserver" {
  vpc_id     = "${aws_vpc.vpc.id}"
  name       = "appserver"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = false
}

#Security group for app server
resource "aws_security_group" {
  name        = "appserver_sg"
  description = "Allow port 80, port 443 for http, https and port 3389 for rdp"
  vpc_id      = "${data.aws_vpc.vpc.id}"
  egress_rules = ["ssh-22-tcp"]
  igress_rules = ["http-80-tcp","https-443-tcp","remotedesktop-3389-tcp"]
 
}

#ec2 instance for app server
resource "ec2" {
       instance_count = 1
       name  = "appserver_ec2"
       ami   = "${data.aws_ami.amazon_linux.id}"
       instance_type = "t2.micro"
       subnet_id     = "${aws_subnet.appserver.id}"
       vpc_security_group_ids  = "${aws_security_group.appserver_sg.id}"
       associate_public_ip_address = false
}

#Creates RDS cluster
resource "aws_rds_cluster" "rds" {
  cluster_identifier      = "aurora-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.03.2"
  availability_zones      = ["eu-central-1"]
  database_name           = "mydb-admin"
  master_username         = "admin"
  master_password         = "admin123"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
}


#Linux image
data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name = "linuxami"
    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }
}
