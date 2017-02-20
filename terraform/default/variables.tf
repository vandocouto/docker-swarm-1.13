variable "instance" {
	default = 4
}

variable "type" {
	default = "t2.micro"
}

variable "ami" {
	default = "ami-6edd3078"
}

variable "key" {
	default = "docker-swarm"
}

variable "security" {
	default = "sg-fd653a81"
}

variable "subnet" {
	type = "list"
	default = ["subnet-bda4e7e6" , "subnet-ce7cf5f2" , "subnet-ae085c83" , "subnet-2264616b" ]
}

variable "ssh_user_name" {
  	default = "ubuntu"
}

variable "ssh_key_file" {
  	default = "../../chave/docker-swarm.pem"
}
