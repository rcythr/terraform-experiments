
###############################################################################
## Create the Security Group for Bastion Host(s)
###############################################################################

resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Allow SSH from anywhere, and egress to anywhere on all ports."
  vpc_id      = aws_vpc.experiment.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Experiment - Bastion"
  }
}

###############################################################################
## Create the Bastion Host
###############################################################################

resource "aws_instance" "bastion" {
    subnet_id     = aws_subnet.dmz.id
    ami           = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"

    vpc_security_group_ids = [
      aws_security_group.bastion.id
    ]

    key_name      = aws_key_pair.main.key_name

    root_block_device {
      volume_size = 10
    }

    tags = {
      Name = "Experiment - Bastion"
    }
}
