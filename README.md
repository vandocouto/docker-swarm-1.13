# Docker Swarm V1.13

## Clone do projeto

<pre>
$ git clone https://github.com/vandocouto/docker-swarm-1.13.git
</pre>

## Ajustes na AWS

- Crie um usuário no "Your Security Credentials"
- Crie um security group chamado "docker-swarm" (All traffic para a VPC)
- De permissão para o usuário no "EC2 full Access"
- Crie uma chave (key) chamada "docker-swarm.key"
- Mova a chave para o diretório "terraform/chave/"
- Ajuste a permissão da chave para "chmod 0400 terraform/chave/docker-swarm.key"

## Ajustes no Terraform

#### Ajustando o script de deploy

- Abra o script

<pre>
$ vim terraform/deploy.sh
</pre>

- Insira o Access Key ID do usuário
- Insira o Secret Access Key do usuário

<pre>
if [ -z "$1" ]
then
  echo "Usage: must pass the terraform directory"
  exit 1
fi

export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""

cd $1
terraform $2
</pre>


- Executando o plan do projeto [ O comando terraform plan é usado para criar o plano de execução ]

<pre>
$  ./terraform/deploy.sh terraform/default/ plan
</pre>

- Executando o apply do projeto [ O comando terrafrom apply é usado para o deploy ]

<pre>
$  ./terraform/deploy.sh terraform/default/ apply
</pre>

## Ajustes no Ansible

#### Arquivo hosts
- Neste arquivo será adicionado os ip's das instâncias
- Exemplo da saída (output) do Terraform após o apply 

<pre>
Outputs:

Private IP = 10.0.0.134,10.0.3.231,10.0.1.14,10.0.2.150
Public IP = 54.210.142.62,34.207.57.29,54.91.98.32,52.90.54.17
</pre>

<pre>
$ vim ansible/docker-swarm/hosts
</pre>

- [docker-engine] 	- deverá conter todos os ip's públicos da sáida output
- [master] 		    - deverá conter o primeiro ip (52.3.252.205) público da saída output
- [manager] 		- deverá conter o segundo ip (107.23.179.233) público da saída output
- [worker] 		    - deverá conter os dois últimos ip's públicos (54.172.39.123) da saída output
- [all:vars] 		- deverá conter o primeiro ip privado (10.0.3.204) da saída output

<pre>
[docker-engine]
54.210.142.62   hostname=master
34.207.57.29    hostname=manager
54.91.98.32     hostname=worker1
52.90.54.17     hostname=worker2

[master]
54.210.142.62

[manager]
34.207.57.29

[worker]
54.91.98.32
52.90.54.17

[all:children]
docker-engine
master
worker
manager

[all:vars]
docker_swarm_addr=10.0.0.134
docker_swarm_port=2377
swarm_subnet=192.168.0.0/24
swarm_subnet_name=network_swarm
ansible_ssh_user=ubuntu
ansible_ssh_private_key_file=../chave/docker-swarm.pem
hostname_default_ip=127.0.0.1
</pre>

- Executando o playbook

<pre>
$ cd ansible/
$ ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts ./tasks/main.yml 
</pre>

- OBS: A versão do Ansible precisa ser > 2

## Encerrando o projeto

<pre>
$  ./terraform/deploy.sh terraform/default/ destroy
</pre>
