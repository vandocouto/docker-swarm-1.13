# Docker Swarm Ubuntu

## clone do projeto

<pre>
$ git clone 
</pre>

## Ajustes na AWS

- Crie um usuaŕio no "Your Security Credentials"
- Crie um security group chamado "docker-swarm" 
- Crie uma chave *.key chamada "docker-swarm.key"
- Mova a chave para o diretório "terraform/chave/"
- Ajuste a permissão da chave para "chmod 0400 terraform/chave/docker-swarm.key"

## Ajustando o Terraform

- Executando o plan do projeto [ O comando terraform plan é usado para criar o plano de execução ]

<pre>
$  ./terraform/deploy.sh terraform/default/ plan
</pre>

- Executando o apply do projeto [ O comando terrafrom apply é usado para o deploy ]

<pre>
$  ./terraform/deploy.sh terraform/default/ apply
</pre>

## Ajustando o Ansible

#### Arquivo hosts
- Neste arquivo será adicionado os ip's das instâncias
- Exemplo da saída (output) do Terraform após o apply 

<pre>
Outputs:
Private IP = 10.0.0.111,10.0.3.97,10.0.1.31,10.0.2.153
Public IP = 54.85.45.8,54.210.87.3,54.86.167.161,52.90.223.152
</pre>

<pre>
$ vim ansible/docker-swarm/hosts
</pre>

- [docker-engine] 	- deverá conter todos os ip's públicos da sáida output
- [master] 		- deverá conter apenas um ip público da saída output
- [manager] 		- deverá conter apenas um ip público da saída output
- [worker] 		- deverá conter dois ip's públicos da saída output
- [all:vars] 		- deverá conter um ip privado da saída output

<pre>
[docker-engine]
54.85.45.8
54.210.87.3
54.86.167.161
52.90.223.152

[master]
54.85.45.8

[manager]
54.210.87.3

[worker]
54.86.167.161
52.90.223.152

[all:children]
docker-engine
master
worker
manager

[all:vars]
docker_swarm_addr=10.0.0.111
docker_swarm_port=2377
swarm_subnet=10.0.0.0/24
swarm_subnet_name=network_swarm
ansible_ssh_user=ubuntu
ansible_ssh_private_key_file=../../chave/docker-swarm.pem
</pre>


<pre>
$ cd /ansible/docker-swarm
$ ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts ./tasks/main.yml 
</pre>
