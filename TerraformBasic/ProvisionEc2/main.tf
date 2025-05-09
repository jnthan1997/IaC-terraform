resource "aws_instance" "ec2Instance" {

    ami = var.amis
    instance_type = "t2.micro"  
    key_name = aws_key_pair.aws-key.id
    vpc_security_group_ids = [ aws_security_group.aws-sg-1.id ]

    tags = {
      Name = "Ec2 Provision"
    }

}

resource "aws_key_pair" "aws-key" {
    key_name = var.sshKey["key_name"]
    public_key = file("~/.ssh/aws-key.pub")
}

resource "aws_security_group" "aws-sg-1" {
    name = "ec2-sg-1"
    vpc_id = data.aws_vpc.default.id

    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["124.104.36.172/32"]
    }

    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  
    }

    tags = {
      Name = "SG"
    }
  
}

data "aws_vpc" "default" {

    default = true
  
}

output "ip_address" {
  value = aws_instance.ec2Instance.public_ip
}