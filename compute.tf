

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# ============================================
# DAY 3 - EC2 INSTANCES
# ============================================

# Web Server in Public Subnet
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = var.key_name
  user_data_replace_on_change = true

  # User data script to install Apache
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello from Terraform Web Server at $(date)</h1>" > /var/www/html/index.html
    echo "<p>This server was built by Terraform on $(date)</p>" >> /var/www/html/index.html
  EOF

  tags = {
    Name        = "${var.environment}-web-server"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Database Server in Private Subnet
resource "aws_instance" "db" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name  # ADD THIS LINE

 user_data = <<-EOF
    #!/bin/bash
    yum update -y
    # Install correct MariaDB package for Amazon Linux 2
    amazon-linux-extras install -y mariadb10.5
    yum install -y mariadb-server
    
    # Start and enable MariaDB
    systemctl start mariadb
    systemctl enable mariadb
    
    # Wait for MySQL to be fully ready
    sleep 10
    
    # Create database and user
    mysql -e "CREATE DATABASE IF NOT EXISTS testdb;"
    mysql -e "CREATE USER IF NOT EXISTS 'webuser'@'10.0.1.0/24' IDENTIFIED BY 'password123';"
    mysql -e "GRANT ALL ON testdb.* TO 'webuser'@'10.0.1.0/24';"
    mysql -e "FLUSH PRIVILEGES;"
    
    # Create flag file
    touch /tmp/mysql-installed
  EOF

  tags = {
    Name        = "${var.environment}-db-server"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}