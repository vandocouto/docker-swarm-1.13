# Docker Swarm Ubuntu

## clone do projeto

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

export AWS_ACCESS_KEY_ID="AKIAJPX66JYLXQMTCDKA"
export AWS_SECRET_ACCESS_KEY="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"
export AWS_DEFAULT_REGION="us-west-1"

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

Private IP = 10.0.0.150,10.0.3.68,10.0.1.32,10.0.2.24
Public IP = 54.173.75.70,52.3.251.179,54.167.45.179,54.160.225.84
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
54.173.75.70
52.3.251.179
54.167.45.179
54.160.225.84

[master]
54.173.75.70

[manager]
52.3.251.179

[worker]
54.167.45.179
54.160.225.84

[all:children]
docker-engine
master
worker
manager

[all:vars]
docker_swarm_addr=10.0.0.150
docker_swarm_port=2377
swarm_subnet=10.0.0.0/24
swarm_subnet_name=network_swarm
ansible_ssh_user=ubuntu
ansible_ssh_private_key_file=../../chave/docker-swarm.pem
</pre>

- Executando o playbook

<pre>
$ cd ansible/docker-swarm
$ ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts ./tasks/main.yml 
</pre>
