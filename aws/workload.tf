
resource "aws_security_group" "workload" {
  name        = "workload"
  description = "Allow SSH from dmz, and egress to anywhere on all ports."
  vpc_id      = aws_vpc.experiment.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [ aws_vpc.experiment.cidr_block ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Experiment - Workload"
  }
}

resource "aws_instance" "workload" {
    count         = 2
    subnet_id     = aws_subnet.private.id
    ami           = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"

    key_name      = aws_key_pair.main.key_name

    vpc_security_group_ids = [
      aws_security_group.workload.id
    ]

    root_block_device {
      volume_size = 10
    }

    tags = {
      Name = "Experiment - Workload ${count.index}"
    }
}
