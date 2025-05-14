data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }


  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "hello-instance" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.allow_http.id]
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -a -G docker ec2-user
              docker run -d -p 80:80 --name hello-server tanvirrashiddon/hello-server 
            EOF

  depends_on = [aws_internet_gateway.gateway]

  tags = {
    app  = "hello-app"
    type = "aws_instance"
  }
}

output "application_url" {
  value       = "http://${aws_instance.hello-instance.public_ip}"
  description = "Application public url"
}

output "test" {
  value       = "curl http://${aws_instance.hello-instance.public_ip}/api"
  description = "Command to test the app"
}
