resource "aws_instance" "test-server" {
  ami                    = "ami-0866a3c8686eaeeba"
  instance_type         = "t2.micro"
  key_name              = "jenkins"
  vpc_security_group_ids = ["sg-0518ca06826b03dc0"]

  connection {
    type        = "ssh"
    user       = "ubuntu"
    private_key = file("./jenkins.pem")
    host       = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "while ! nc -z ${self.public_ip} 22; do sleep 5; done",  // Wait for SSH
    ]
  }

  provisioner "local-exec" {
    command = <<EOT
      echo ${aws_instance.test-server.public_ip} > inventory
      ansible-playbook '/var/lib/jenkins/workspace/BANKING PROJECT/terraform/ansibleplaybook.yml'
    EOT
  }

  tags = {
    Name = "test-server"
  }
}
