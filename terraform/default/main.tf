# zone
provider "aws" {
	region = "${var.region}"
}

# deploy
resource "aws_instance" "docker-swarm" {
 	count = "${var.instance}"
	subnet_id = "${element(var.subnet, count.index)}"
	instance_type = "${var.type}"
	ami = "${var.ami}"
	key_name = "${var.key}"
  	security_groups = ["${var.security}"]
	associate_public_ip_address = true

	root_block_device {
        	volume_size = "${var.size}"
    }

	provisioner "remote-exec" {
		connection {
      			user = "${var.ssh_user_name}"
      			private_key = "${file(var.ssh_key_file)}"
    		}

		inline = [
			"sudo apt-get update -y",
			"sudo apt-get install python-simplejson -y",
    		]
	}

}

# output
output "Private IP" {
	value = "${join(",", aws_instance.docker-swarm.*.private_ip)}"
 
}

output "Public IP" {
        value = "${join(",", aws_instance.docker-swarm.*.public_ip)}"

}


