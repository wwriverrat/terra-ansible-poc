# ------------------- Security Groups -------------------

# Acquire public IP address for the server we are running on now.
data "http" "local_ip" {
  # Note: This is a hack! Use with caution. This link discovers
  # the "IP you are running this from" from a external source.
  # When terraform is run from the CI server itself, it should either be
  # set to use a DNS entry or specify the ci_server's IP address.
  #  CI server would be backed by DNS name that would provide this IP
  url = "https://ifconfig.me/ip"
}

# Security group to trust CI resource
resource "aws_security_group" "ci_access" {
  name        = "ci_access"
  description = "Allow inbound traffic from a CI server"

  tags = {
    Name = "ci_access"
  }
}

# Rule to allow ssh traffic to ci_server
resource "aws_security_group_rule" "ingress_ssh_rule" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.local_ip.response_body)}/32"]
  security_group_id = aws_security_group.ci_access.id
}

# Rule to allow ssh traffic to ci_server
resource "aws_security_group_rule" "ingress_http_rule" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.local_ip.response_body)}/32"]
  security_group_id = aws_security_group.ci_access.id
}

# Rule to allow ping traffic to ci_server
resource "aws_security_group_rule" "ingress_ping_rule" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["${chomp(data.http.local_ip.response_body)}/32"]
  security_group_id = aws_security_group.ci_access.id
}


# Allow all egress
resource "aws_security_group_rule" "egress_all_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ci_access.id
}
