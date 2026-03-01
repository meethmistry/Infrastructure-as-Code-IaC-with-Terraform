
# ============================================
# DAY 2 - SECURITY GROUPS
# ============================================

# Web Server Security Group
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = aws_vpc.main_vpc.id

  # HTTP from anywhere
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 🔐 SSH from YOUR IP ONLY (for security)
  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["152.59.37.17/32"]  
  }

  # Outbound Rules
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

# Database Security Group
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Allow MySQL only from web-sg"
  vpc_id      = aws_vpc.main_vpc.id

  # MySQL from web-sg
  ingress {
    description     = "MySQL from web-sg"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  # 🔐 TEMPORARY: SSH from web-sg (remove after MySQL is installed)
  ingress {
    description     = "SSH from web-sg (temporary)"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}