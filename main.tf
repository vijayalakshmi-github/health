provider "aws"{
        region = "us-east-1"
}
resource "aws_instance" "prod-server1"{
	ami = "ami-007855ac798b5175e"
	instance_type = "t2.medium"
	key_name = "aws"
        vpc_security_group_ids =["sg-0d665c5855066777e"]
	tags = {
   	  Name = "prod-server1"
	}
	provisioner "local-exec" {
	    command = "sleep 60 && echo 'Instance ready'"
  	}
        connection{
                type = "ssh"
                user = "ubuntu"
                private_key = file("./aws.pem")
                host = aws_instance.prod-server1.public_ip
        }
	provisioner "local-exec"{
		command = "echo ${aws_instance.prod-server1.public_ip} > inventory"
	}
	provisioner "local-exec"{
		command = "ansible-playbook /var/lib/jenkins/workspace/medicure/configure.yml"
	}
}
