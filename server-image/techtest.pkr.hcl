variable "region" {
  type = string 
  default = "eu-west-1"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "example" {
  ami_name      = "packer example ${local.timestamp}"
  instance_type = "t2.micro"
  region        = "${var.region}"
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ec2-user"
}

# a build block invokes sources and runs provisioning steps on them.
build {
  sources = ["source.amazon-ebs.example"]

  provisioner "file" {
    destination = "/home/ec2-user/nginx.conf"
    source      = "./nginx.conf"
  }

  provisioner "file" {
    destination = "/home/ec2-user/index.html"
    source      = "./index.html"
  }

  provisioner "file" {
    destination = "/home/ec2-user/welcome.jpg"
    source      = "./welcome.jpg"
  }

  provisioner "shell" {
    inline = [
      "sleep 30",
      "sudo mkdir -p /etc/nginx",
      "sudo mkdir -p /var/www/html",
      "sudo amazon-linux-extras install -y nginx1.12",
      "sudo cp /home/ec2-user/nginx.conf /etc/nginx/nginx.conf",
      "sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html",
      "sudo cp /home/ec2-user/welcome.jpg /usr/share/nginx/html/welcome.jpg",
      "sudo sed -i \"s/replace_host/`hostname`/g\" /usr/share/nginx/html/index.html",
      "sudo chkconfig nginx on",
      "sudo systemctl start nginx"
    ]
  }
}
