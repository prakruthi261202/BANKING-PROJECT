resource "aws_instance" "test-server" {
  ami = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"
  key_name = "jenkins"
  vpc_security_group_ids = ["sg-0518ca06826b03dc0"]
  connection {
     type = "ssh"
     user = "ubuntu"
     private_key = file("./jenkins (1).pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/BANKING PROJECT/terraform-files/ansibleplaybook.yml"
     }
  }
