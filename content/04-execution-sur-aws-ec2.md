# AWS EC2

<!-- toc -->

## Introduction

Pour lancer une instance EC2, on a besoin :

1. AMI : une image de référence
2. VPC : un switch virtuel auquel va se connecter l'instance EC2 avec des règles d'accès entrant (au minimum TCP22)
3. Clé : une clé privée SSH pour se connecter à l'instance. Il est nécessaire de prendre connaissance du nom d'utilisateur
4. Script Cloud-init : un script à lancer au démarrage de l'instance pour un approvisionnement automatique

## 1. AMI

Une Amazon Machine Image (AMI) fournit les informations requises pour lancer une instance, qui est un serveur virtuel dans le cloud. Vous devez spécifier une AMI source lorsque vous lancez une instance. Lorsque vous avez besoin de plusieurs instances configurées de manière identique, il est possible de lancer plusieurs instances à partir d'une même AMI. Lorsque vous avez besoin d'instances configurées de manière différente, vous pouvez utiliser différentes AMI pour lancer ces instances.

Une AMI comprend les éléments suivants :

* Un modèle d'image pour le volume racine de l'instance (par exemple, un système d'exploitation, un serveur d'applications et des applications)
* Les autorisations de lancement qui contrôlent les comptes AWS qui peuvent utiliser l'AMI pour lancer les instances

Un "mappage" de périphérique de stockage en mode bloc qui spécifie les volumes à attacher à l'instance lorsqu'elle est lancée

[https://docs.aws.amazon.com/fr_fr/AWSEC2/latest/UserGuide/AMIs.html](https://docs.aws.amazon.com/fr_fr/AWSEC2/latest/UserGuide/AMIs.html)

Cette commande effectue une recherche d'une AMI Linux Amazon (Amazon Linux AMI) pour une instance "x86_64 HVM GP2" :

```bash
aws ec2 describe-images --filters "Name=description,Values=Amazon Linux AMI * x86_64 HVM GP2" --query 'Images[*].[CreationDate, Description, ImageId]' --output text | sort -k 1 | tail
```

```bash
2018-01-03T19:01:53.000Z Amazon Linux AMI 2017.09.1.20180103 x86_64 HVM GP2 ami-8715a2fa
2018-01-08T18:42:47.000Z Amazon Linux AMI 2017.09.1.20180108 x86_64 HVM GP2 ami-fe03b483
2018-01-15T19:12:53.000Z Amazon Linux AMI 2017.09.1.20180115 x86_64 HVM GP2 ami-8ee056f3
2018-01-18T23:08:21.000Z Amazon Linux AMI 2017.09.1.20171120 x86_64 HVM GP2 ami-27e85e5a
2018-03-07T06:59:00.000Z Amazon Linux AMI 2017.09.1-testlongids.20180307 x86_64 HVM GP2 ami-08f0e11237ddeb2f0
2018-03-07T06:59:52.000Z Amazon Linux AMI 2017.09.1.20180307 x86_64 HVM GP2 ami-4f55e332
2018-04-13T00:25:52.000Z Amazon Linux AMI 2018.03.0.20180412 x86_64 HVM GP2 ami-cae150b7
2018-05-08T18:10:54.000Z Amazon Linux AMI 2018.03.0.20180508 x86_64 HVM GP2 ami-969c2deb
2018-06-22T22:24:50.000Z Amazon Linux AMI 2018.03.0.20180622 x86_64 HVM GP2 ami-d50bbaa8
2018-08-11T02:29:44.000Z Amazon Linux AMI 2018.03.0.20180811 x86_64 HVM GP2 ami-0ebc281c20e89ba4b
```

Retenons l'AMI `ami-0ebc281c20e89ba4b` comme la plus récente.

```bash
export AWS_IMAGE="ami-0ebc281c20e89ba4b"
```

### 1.1. Trouver une AMI Linux

Exemple : Rechercher l'AMI Amazon Linux 2 actuelle

```bash
aws ec2 describe-images --owners amazon \
--filters 'Name=name,Values=amzn2-ami-hvm-2.0.????????-x86_64-gp2' 'Name=state,Values=available' \
--output json | jq -r '.Images | sort_by(.CreationDate) | last(.[]).ImageId'
```

Exemple : Rechercher l'AMI Amazon Linux actuelle

```bash
aws ec2 describe-images --owners amazon \
--filters 'Name=name,Values=amzn-ami-hvm-????.??.?.????????-x86_64-gp2' 'Name=state,Values=available' \
--output json | jq -r '.Images | sort_by(.CreationDate) | last(.[]).ImageId'
```

Exemple : Rechercher l'AMI Ubuntu Server 18.04 LTS actuelle

```bash
aws ec2 describe-images --owners 099720109477 \
--filters 'Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-????????' 'Name=state,Values=available' \
--output json | jq -r '.Images | sort_by(.CreationDate) | last(.[]).ImageId'
```

Exemple : Rechercher l'AMI Red Hat Enterprise Linux 7.6 actuelle

```bash
aws ec2 describe-images --owners 309956199498 \
--filters 'Name=name,Values=RHEL-7.6_HVM_GA*' 'Name=state,Values=available' \
--output json | jq -r '.Images | sort_by(.CreationDate) | last(.[]).ImageId'
```

Exemple : Rechercher l'AMI SUSE Linux Enterprise Server 15 actuelle

```bash
aws ec2 describe-images --owners amazon \
--filters 'Name=name,Values=suse-sles-15-v????????-hvm-ssd-x86_64' 'Name=state,Values=available' \
--output json | jq -r '.Images | sort_by(.CreationDate) | last(.[]).ImageId'
```

### 1.2. Fabriquer une image AMI

* Fabriquer une image AMI avec [Packer](https://www.packer.io/)
* Fabriquer une image AMI avec Packer en intégration continue

comme :

* [Builder](https://www.packer.io/docs/builders/index.html),
* [Provisioner](https://www.packer.io/docs/provisioners/index.html)
* [Post-Processor](https://www.packer.io/docs/post-processors/index.html)

```bash
sudo yum -y install wget unzip
wget https://releases.hashicorp.com/packer/1.4.2/packer_1.4.2_linux_amd64.zip
unzip packer_1.4.2_linux_amd64.zip
chmod +x packer
sudo mv packer /usr/local/bin/
```

Un fichier déclaratif en format JSON : `ami.json`.

```json
{
  "variables": {
    "aws_access_key": "{{env `AWS_ACCESS_KEY_ID`}}",
    "aws_secret_key": "{{env `AWS_SECRET_ACCESS_KEY`}}"
  },
  "builders": [
    {
      "type": "amazon-ebs",
      "access_key": "{{user `aws_access_key`}}",
      "secret_key": "{{user `aws_secret_key`}}",
      "region": "eu-west-3",
      "source_ami": "ami-0c4224e392ec4e440",
      "instance_type": "t2.micro",
      "ssh_username": "{{env `USER`}}",
      "ami_name": "packer_AWS {{timestamp}}"
    }
  ]
}
```

Création de l'AMI.

```bash
packer build ami-ubuntu.json
```

```bash
...
==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs: AMIs were created:
eu-west-3: ami-077dc62244c80aac7
```

Approvisionnement : des logiciels intégrés et tiers installent et configurent l'image après son démarrage sur la VM de construction.

```json
  "provisioners": [
    {
      "type": "shell",
      "execute_command": "{{ .Vars }} sudo -E bash '{{ .Path }}'",
      "inline": [
        "sudo apt-get update",
        "sudo apt-get -y install software-properties-common",
        "sudo apt-add-repository --yes --update ppa:ansible/ansible",
        "sudo apt update",
        "sudo apt -y install ansible"
      ]
    },
    {
      "type": "ansible-local",
      "playbook_file": "ansible/playbook.yml",
      "playbook_dir": "ansible"
    },
    {
      "type": "shell",
      "execute_command": "{{ .Vars }} sudo -E bash '{{ .Path }}'",
      "inline": [
        "sudo apt -y remove ansible",
        "sudo apt-get clean",
        "sudo apt-get -y autoremove --purge"
      ]
    }
  ]
```

Post-traitement :



## 2. Création d'une instance EC2 avec aws cli

### 2.1. VPC

Un Virtual Private Cloud (VPC) est un réseau virtuel dédié logiquement isolé des autres réseaux virtuels dans le cloud AWS. On peut lancer des ressources AWS, comme des instances Amazon EC2, dans un VPC, spécifier une plage d'adresses IP pour le VPC, ajouter des sous-réseaux, associer des groupes de sécurité et configurer des tables de routage.

Un sous-réseau est une plage d'adresses IP dans le VPC.

```bash
aws ec2 describe-vpcs --output table
--------------------------------------------------
|                  DescribeVpcs                  |
+------------------------------------------------+
||                     Vpcs                     ||
|+-----------------------+----------------------+|
||  CidrBlock            |  172.31.0.0/16       ||
||  DhcpOptionsId        |  dopt-93e8ccfa       ||
||  InstanceTenancy      |  default             ||
||  IsDefault            |  True                ||
||  OwnerId              |  733718180495        ||
||  State                |  available           ||
||  VpcId                |  vpc-476c332e        ||
|+-----------------------+----------------------+|
|||           CidrBlockAssociationSet          |||
||+----------------+---------------------------+||
|||  AssociationId |  vpc-cidr-assoc-a9c5c4c0  |||
|||  CidrBlock     |  172.31.0.0/16            |||
||+----------------+---------------------------+||
||||              CidrBlockState              ||||
|||+---------------+--------------------------+|||
||||  State        |  associated              ||||
|||+---------------+--------------------------+|||
```

```bash
export AWS_VPC="vpc-476c332e"
```

```bash
export AWS_VPC=$(aws ec2 describe-vpcs --query 'Vpcs[*].VpcId' --output text)
```

```bash
LABID="${USER}${RANDOM}"
```

```bash
aws ec2 create-security-group \
        --group-name $LABID-demo-lab \
        --description "$LABID Demo Lab Security Group" \
        --vpc-id $AWS_VPC
```

```bash
aws ec2 authorize-security-group-ingress \
        --group-name $LABID-demo-lab \
        --protocol tcp \
        --port 22 \
        --cidr 0.0.0.0/0
```

```bash
aws ec2 authorize-security-group-ingress \
        --group-name $LABID-demo-lab \
        --protocol tcp \
        --port 80 \
        --cidr 0.0.0.0/0
```

```bash
aws ec2 authorize-security-group-ingress \
        --group-name $LABID-demo-lab \
        --protocol tcp \
        --port 3000 \
        --cidr 0.0.0.0/0
```

```bash
aws ec2 describe-security-groups \
        --group-names $LABID-demo-lab \
        --output table
```

```bash
----------------------------------------------------------
|                 DescribeSecurityGroups                 |
+--------------------------------------------------------+
||                    SecurityGroups                    ||
|+--------------+---------------------------------------+|
||  Description |  francois606 Demo Lab Security Group  ||
||  GroupId     |  sg-0a518bf1e2fd2cc83                 ||
||  GroupName   |  francois606-demo-lab                 ||
||  OwnerId     |  733718180495                         ||
||  VpcId       |  vpc-476c332e                         ||
|+--------------+---------------------------------------+|
|||                    IpPermissions                   |||
||+----------------------------------+-----------------+||
|||  FromPort                        |  80             |||
|||  IpProtocol                      |  tcp            |||
|||  ToPort                          |  80             |||
||+----------------------------------+-----------------+||
||||                     IpRanges                     ||||
|||+---------------------+----------------------------+|||
||||  CidrIp             |  0.0.0.0/0                 ||||
|||+---------------------+----------------------------+|||
|||                    IpPermissions                   |||
||+----------------------------------+-----------------+||
|||  FromPort                        |  22             |||
|||  IpProtocol                      |  tcp            |||
|||  ToPort                          |  22             |||
||+----------------------------------+-----------------+||
||||                     IpRanges                     ||||
|||+---------------------+----------------------------+|||
||||  CidrIp             |  0.0.0.0/0                 ||||
|||+---------------------+----------------------------+|||
|||                    IpPermissions                   |||
||+--------------------------------+-------------------+||
|||  FromPort                      |  3000             |||
|||  IpProtocol                    |  tcp              |||
|||  ToPort                        |  3000             |||
||+--------------------------------+-------------------+||
||||                     IpRanges                     ||||
|||+---------------------+----------------------------+|||
||||  CidrIp             |  0.0.0.0/0                 ||||
|||+---------------------+----------------------------+|||
|||                 IpPermissionsEgress                |||
||+------------------------------------+---------------+||
|||  IpProtocol                        |  -1           |||
||+------------------------------------+---------------+||
||||                     IpRanges                     ||||
|||+---------------------+----------------------------+|||
||||  CidrIp             |  0.0.0.0/0                 ||||
|||+---------------------+----------------------------+|||
```

On retiendra l'ID du groupe de sécurité

```bash
export AWS_SGID="sg-0a518bf1e2fd2cc83"
```

### 2.2. Clé d'accès

```bash
aws ec2 create-key-pair --key-name $LABID-demo-lab-key --query 'KeyMaterial' --output text > ~/.ssh/$LABID-demo-lab-key.pem
```

```bash
aws ec2 describe-key-pairs --key-name $LABID-demo-lab-key
```

```json
{
    "KeyPairs": [
        {
            "KeyName": "demo-lab-key",
            "KeyFingerprint": "75:96:3c:ae:00:4f:27:88:af:35:52:a1:b9:cd:6d:0e:ff:2c:f4:58"
        }
    ]
}
```

Restreindre les droits

```bash
chmod 400 ~/.ssh/$LABID-demo-lab-key.pem
```

### 2.3. Lancer une instance t2.micro

```bash
aws ec2 run-instances \
    --instance-type t2.micro \
    --key-name $LABID-demo-lab-key \
    --security-group-ids $AWS_SGID \
    --image-id $AWS_IMAGE
```

```bash
{
    "Instances": [
        {
            "Monitoring": {
                "State": "disabled"
            },
            "PublicDnsName": "",
            "StateReason": {
                "Message": "pending",
                "Code": "pending"
            },
            "State": {
                "Code": 0,
                "Name": "pending"
            },
            "EbsOptimized": false,
            "LaunchTime": "2018-10-28T12:34:52.000Z",
            "PrivateIpAddress": "172.31.35.250",
            "ProductCodes": [],
            "VpcId": "vpc-476c332e",
            "CpuOptions": {
                "CoreCount": 1,
                "ThreadsPerCore": 1
            },
            "StateTransitionReason": "",
            "InstanceId": "i-03f6971fddaff8558",
            "ImageId": "ami-0ebc281c20e89ba4b",
            "PrivateDnsName": "ip-172-31-35-250.eu-west-3.compute.internal",
            "KeyName": "demo-lab-key",
            "SecurityGroups": [
                {
                    "GroupName": "demo-lab",
                    "GroupId": "sg-04edf90e659364a62"
                }
            ],
            "ClientToken": "",
            "SubnetId": "subnet-074deb4a",
            "InstanceType": "t2.micro",
            "NetworkInterfaces": [
                {
                    "Status": "in-use",
                    "MacAddress": "0e:3e:0a:fc:59:56",
                    "SourceDestCheck": true,
                    "VpcId": "vpc-476c332e",
                    "Description": "",
                    "NetworkInterfaceId": "eni-092f4bd7687ea0b89",
                    "PrivateIpAddresses": [
                        {
                            "PrivateDnsName": "ip-172-31-35-250.eu-west-3.compute.internal",
                            "Primary": true,
                            "PrivateIpAddress": "172.31.35.250"
                        }
                    ],
                    "PrivateDnsName": "ip-172-31-35-250.eu-west-3.compute.internal",
                    "Attachment": {
                        "Status": "attaching",
                        "DeviceIndex": 0,
                        "DeleteOnTermination": true,
                        "AttachmentId": "eni-attach-0f2b364177e190547",
                        "AttachTime": "2018-10-28T12:34:52.000Z"
                    },
                    "Groups": [
                        {
                            "GroupName": "demo-lab",
                            "GroupId": "sg-04edf90e659364a62"
                        }
                    ],
                    "Ipv6Addresses": [],
                    "OwnerId": "733718180495",
                    "SubnetId": "subnet-074deb4a",
                    "PrivateIpAddress": "172.31.35.250"
                }
            ],
            "SourceDestCheck": true,
            "Placement": {
                "Tenancy": "default",
                "GroupName": "",
                "AvailabilityZone": "eu-west-3c"
            },
            "Hypervisor": "xen",
            "BlockDeviceMappings": [],
            "Architecture": "x86_64",
            "RootDeviceType": "ebs",
            "RootDeviceName": "/dev/xvda",
            "VirtualizationType": "hvm",
            "AmiLaunchIndex": 0
        }
    ],
    "ReservationId": "r-091126bd779f312ce",
    "Groups": [],
    "OwnerId": "733718180495"
}
```

### 2.4. Instances EC2

Amazon Elastic Compute Cloud (Amazon EC2) est un service Web qui fournit une capacité de calcul sécurisée et redimensionnable dans le cloud. Destiné aux développeurs, il est conçu pour faciliter l'accès aux ressources de cloud computing à l'échelle du Web.

[Type d'instances](https://docs.aws.amazon.com/fr_fr/AWSEC2/latest/UserGuide/instance-types.html)

[Types de virtualisation AMI Linux](https://docs.aws.amazon.com/fr_fr/AWSEC2/latest/UserGuide/virtualization_types.html)

[Instances dédiées Amazon EC2](https://aws.amazon.com/fr/ec2/purchasing-options/dedicated-instances/)

```bash
aws ec2 describe-instances
```

```bash
aws ec2 describe-instances --output table
```


```bash
aws ec2 describe-instances --filters "Name=instance.group-name,Values=$LABID-demo-lab"

```

```bash
aws ec2 describe-instances --filters "Name=instance-type,Values=t2.micro" --query Reservations[].Instances[].InstanceId
```

```bash
aws ec2 describe-instances --filters "Name=instance.group-name,Values=$LABID-demo-lab" --query Reservations[].Instances[].InstanceId --output text
```

```bash
i-01295da4c589e3178
```

```bash
export AWS_INSTANCE="$(aws ec2 describe-instances --filters "Name=instance.group-name,Values=$LABID-demo-lab" --query Reservations[].Instances[].InstanceId --output text)"
```

```bash
aws ec2 describe-instances \
    --instance-ids $AWS_INSTANCE \
    --query "Reservations[*].Instances[*].PublicDnsName" --output text
```

```bash
INSTANCE=$(aws ec2 describe-instances --instance-ids $AWS_INSTANCE --query "Reservations[*].Instances[*].PublicDnsName" --output text)
```


### 2.5. Connexion à l'instance

Pour une AMI Linux Amazon :

```bash
ssh -i ~/.ssh/$LABID-demo-lab-key.pem ec2-user@$INSTANCE
```

Pour une AMI Ubuntu :

```bash
ssh -i ~/.ssh/$LABID-demo-lab-key.pem ubuntu@$INSTANCE
```


### 2.6. Opérations sur l'instance (Ansible)

```bash
sudo yum -y update
sudo apt -y install python-pip
pip install --upgrade pip
sudo pip install ansible
```

```yaml
# Configure and deploy Apache
- hosts: localhost
  connection: local
  tasks:
    - name: confirm using the latest Apache server
      become: yes
      become_method: sudo
      yum:
        name: httpd
        state: latest
    - name: reload service httpd, in all cases
      become: yes
      become_method: sudo
      service:
        name: httpd
        state: reloaded
    - name: check the service
      shell: curl -s 127.0.0.1
      register: check_apache
    - debug:
        msg: "Is Apache installed ? {{ check_apache.stdout }}"
    - name: Create index.html file for test
      become: yes
      become_method: sudo
      shell: echo 'True' > /var/www/html/index.html
      when: check_apache.stdout != 'True'
```

```bash
ansible-playbook apache.yml -v
```

### 2.7. Une application simple

```bash
sudo yum install --enablerepo=epel -y nodejs
```

Fichier `hellworld.js`

```node
var http = require("http")

http.createServer(function (request, response) {

   // Send the HTTP header
   // HTTP Status: 200 : OK
   // Content Type: text/plain
   response.writeHead(200, {'Content-Type': 'text/plain'})

   // Send the response body as "Hello World"
   response.end('Hello World\n')
}).listen(3000)

// Console will print the message
console.log('Server running')
```

```bash
node helloworld.js
```

```bash
cat << EOF >> /etc/init/helloworld.conf
description "Hello world Deamon"

# Start when the system is ready to do networking.
start on started elastic-network-interfaces

# Stop when the system is on its way down.
stop on shutdown

respawn
script
    exec su --session-command="/usr/bin/node /home/ec2-user/helloworld.js" ec2-user
end script
EOF
```

Démarrage du service

```bash
sudo start helloworld
```

### 2.8. Terminer une instance

```bash
aws ec2 stop-instances --instance-ids $AWS_INSTANCE && aws ec2 terminate-instances --instance-ids $AWS_INSTANCE
```

### 2.9. Supprimer une paire de clés

```bash
aws ec2 delete-key-pair --key-name $LABID-demo-lab-key
```

### 2.10. Supprimer un groupe de sécurité

```bash
aws ec2 delete-security-group --group-name $LABID-demo-lab
```

### 2.11. Déploiement avec Cloud-init

[Exécution de commandes sur votre instance Linux lors du lancement](https://docs.aws.amazon.com/fr_fr/AWSEC2/latest/UserGuide/user-data.html#user-data-api-cli) : on ajoute le paramètres `--user-data file://my_script.sh`lors de la création de l'instance avec la commande `aws ec2 run-instances`, `my_script.sh` étant le script qui s'exécutera au démarrage. C'est la solution [Cloud-init](https://cloudinit.readthedocs.io/en/latest/topics/datasources/ec2.html) qui est utilisée dans ce cas. Beaucoup d'autres prestataires utilisent ce logiciel pour approvisionner des instances.

* Approvisionnement de stack Python, Ansible, encore LAMP ou encoreGitlab Runner.

## 3. AWS automatisé en Bash

Exercice à réaliser

## 4. AWS EC2 avec Ansible

Voir le dossier [ansible-aws](https://gitlab.com/goffinet/gitbook-gitlab/tree/master/ansible-aws) du projet.

* roles ec2 aws
* envoi de crédits
* suppression d'instances et de clés

## 5. Instances légères LightSail

[https://lightsail.aws.amazon.com/ls/docs/en/articles/getting-started-with-amazon-lightsail](https://lightsail.aws.amazon.com/ls/docs/en/articles/getting-started-with-amazon-lightsail)

## 6. PaaS Elastic Beanstalk

[AWS Elastic Beanstalk - Didacticiels et exemples](https://docs.aws.amazon.com/fr_fr/elasticbeanstalk/latest/dg/tutorials.html)
