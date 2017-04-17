resource "aws_instance" "webapp" {
  count                       = 1
  ami                         = "${var.ami}"
  instance_type               = "${var.aws_instance_type}"
  key_name                    = "${aws_key_pair.admin_key.key_name}"
  security_groups             = ["${aws_security_group.base_security_group.name}"]
  associate_public_ip_address = true
  user_data = "${file("installpkgs.sh")}"
  connection {
        user = "root",
        private_key = "${file("keys/aws_terraform")}",
        agent = false
  }

  provisioner "file" {
    source      = "ssl"
    destination = "/tmp"
  }

  provisioner "file" {
    source      = "drupal7"
    destination = "/tmp/drupal7"
  }

  provisioner "file" {
    source      = "nginx.conf"
    destination = "/tmp/nginx.conf"
  }

  tags {
    Name = "Ubuntu launched by Terraform"
  }
}
