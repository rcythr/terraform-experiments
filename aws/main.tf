
provider "aws" {
  region = var.region
}

resource "null_resource" "make_key" {
  provisioner "local-exec" {
    command = "./scripts/create_ssh_key.sh"
  }
}

data "local_file" "key" {
  filename = ".gen/id_rsa.pub"
  depends_on = [null_resource.make_key]
}

resource "aws_key_pair" "main" {
  key_name = "main-key"
  public_key = data.local_file.key.content
}

data "aws_ami" "ubuntu" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["*ubuntu-groovy-20.10*"]
  }

  filter {
    name   = "architecture"
    values  = ["x86_64"]
  }
}
