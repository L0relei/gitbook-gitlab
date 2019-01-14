# AWS EC2

<!-- toc -->

## 1. AMI

Une Amazon Machine Image (AMI) fournit les informations requises pour lancer une instance, qui est un serveur virtuel dans le cloud. Vous devez spécifier une AMI source lorsque vous lancez une instance. Lorsque vous avez besoin de plusieurs instances configurées de manière identique, il est possible de lancer plusieurs instances à partir d'une même AMI. Lorsque vous avez besoin d'instances configurées de manière différente, vous pouvez utiliser différentes AMI pour lancer ces instances.

Une AMI comprend les éléments suivants :

Un modèle pour le volume racine de l'instance (par exemple, un système d'exploitation, un serveur d'applications et des applications)

Les autorisations de lancement qui contrôlent les comptes AWS qui peuvent utiliser l'AMI pour lancer les instances

Un "mappage" de périphérique de stockage en mode bloc qui spécifie les volumes à attacher à l'instance lorsqu'elle est lancée

[https://docs.aws.amazon.com/fr_fr/AWSEC2/latest/UserGuide/AMIs.html](https://docs.aws.amazon.com/fr_fr/AWSEC2/latest/UserGuide/AMIs.html)

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

## 2. Création d'une instance EC2 avec aws cli

### 2.1. VPC

Un Virtual Private Cloud (VPC) est un réseau virtuel dédié logiquement isolé des autres réseaux virtuels dans le cloud AWS. On peut lancer des ressources AWS, comme des instances Amazon EC2, dans un VPC, spécifier une plage d'adresses IP pour le VPC, ajouter des sous-réseaux, associer des groupes de sécurité et configurer des tables de routage.

Un sous-réseau est une plage d'adresses IP dans le VPC.

```bash
aws ec2 describe-vpcs --output table
---------------------------------------------------------------------------------------------------
|                                          DescribeVpcs                                           |
+-------------------------------------------------------------------------------------------------+
||                                             Vpcs                                              ||
|+---------------+----------------+------------------+------------+-------------+----------------+|
||   CidrBlock   | DhcpOptionsId  | InstanceTenancy  | IsDefault  |    State    |     VpcId      ||
|+---------------+----------------+------------------+------------+-------------+----------------+|
||  172.31.0.0/16|  dopt-93e8ccfa |  default         |  True      |  available  |  vpc-476c332e  ||
|+---------------+----------------+------------------+------------+-------------+----------------+|
|||                                   CidrBlockAssociationSet                                   |||
||+--------------------------------------------------------+------------------------------------+||
|||                      AssociationId                     |             CidrBlock              |||
||+--------------------------------------------------------+------------------------------------+||
|||  vpc-cidr-assoc-a9c5c4c0                               |  172.31.0.0/16                     |||
||+--------------------------------------------------------+------------------------------------+||
||||                                      CidrBlockState                                       ||||
|||+----------------------------------+--------------------------------------------------------+|||
||||  State                           |  associated                                            ||||
|||+----------------------------------+--------------------------------------------------------+|||
```

```bash
export AWS_VPC="vpc-476c332e"
```

```bash
export AWS_VPC=$(aws ec2 describe-vpcs --query 'Vpcs[*].VpcId' --output text)
```

```bash
aws ec2 create-security-group \
        --group-name demo-lab \
        --description "Demo Lab Security Group" \
        --vpc-id $AWS_VPC
```

```bash
aws ec2 authorize-security-group-ingress \
        --group-name demo-lab \
        --protocol tcp \
        --port 22 \
        --cidr 0.0.0.0/0
```

```bash
aws ec2 authorize-security-group-ingress \
        --group-name demo-lab \
        --protocol tcp \
        --port 80 \
        --cidr 0.0.0.0/0
```

```bash
aws ec2 authorize-security-group-ingress \
        --group-name demo-lab \
        --protocol tcp \
        --port 3000 \
        --cidr 0.0.0.0/0
```

```bash
aws ec2 describe-security-groups \
        --group-names demo-lab \
        --output table
```

```bash
----------------------------------------------------------------------------------------------------
|                                      DescribeSecurityGroups                                      |
+--------------------------------------------------------------------------------------------------+
||                                         SecurityGroups                                         ||
|+--------------------------+------------------------+------------+---------------+---------------+|
||        Description       |        GroupId         | GroupName  |    OwnerId    |     VpcId     ||
|+--------------------------+------------------------+------------+---------------+---------------+|
||  Demo Lab Security Group |  sg-04edf90e659364a62  |  demo-lab  |  733718180495 |  vpc-476c332e ||
|+--------------------------+------------------------+------------+---------------+---------------+|
|||                                         IpPermissions                                        |||
||+------------------------------+------------------------------------+--------------------------+||
|||           FromPort           |            IpProtocol              |         ToPort           |||
||+------------------------------+------------------------------------+--------------------------+||
|||  80                          |  tcp                               |  80                      |||
||+------------------------------+------------------------------------+--------------------------+||
||||                                          IpRanges                                          ||||
|||+--------------------------------------------------------------------------------------------+|||
||||                                           CidrIp                                           ||||
|||+--------------------------------------------------------------------------------------------+|||
||||  0.0.0.0/0                                                                                 ||||
|||+--------------------------------------------------------------------------------------------+|||
|||                                         IpPermissions                                        |||
||+------------------------------+------------------------------------+--------------------------+||
|||           FromPort           |            IpProtocol              |         ToPort           |||
||+------------------------------+------------------------------------+--------------------------+||
|||  22                          |  tcp                               |  22                      |||
||+------------------------------+------------------------------------+--------------------------+||
||||                                          IpRanges                                          ||||
|||+--------------------------------------------------------------------------------------------+|||
||||                                           CidrIp                                           ||||
|||+--------------------------------------------------------------------------------------------+|||
||||  0.0.0.0/0                                                                                 ||||
|||+--------------------------------------------------------------------------------------------+|||
|||                                      IpPermissionsEgress                                     |||
||+----------------------------------------------------------------------------------------------+||
|||                                          IpProtocol                                          |||
||+----------------------------------------------------------------------------------------------+||
|||  -1                                                                                          |||
||+----------------------------------------------------------------------------------------------+||
||||                                          IpRanges                                          ||||
|||+--------------------------------------------------------------------------------------------+|||
||||                                           CidrIp                                           ||||
|||+--------------------------------------------------------------------------------------------+|||
||||  0.0.0.0/0                                                                                 ||||
|||+--------------------------------------------------------------------------------------------+|||
```

On retiendra l'ID du groupe de sécurité

```bash
export AWS_SGID="sg-04edf90e659364a62"
```

### 2.2. Clé d'accès

```bash
aws ec2 create-key-pair --key-name demo-lab-key --query 'KeyMaterial' --output text > ~/.ssh/demo-lab-key.pem
```

```bash
aws ec2 describe-key-pairs --key-name demo-lab-key
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
chmod 400 ~/.ssh/demo-lab-key.pem
```

### Lancer une instance

```bash
aws ec2 run-instances \
    --instance-type t2.micro \
    --key-name demo-lab-key \
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

### 2.3. Instances EC2

Amazon Elastic Compute Cloud (Amazon EC2) est un service Web qui fournit une capacité de calcul sécurisée et redimensionnable dans le cloud. Destiné aux développeurs, il est conçu pour faciliter l'accès aux ressources de cloud computing à l'échelle du Web.

[Instances dédiées Amazon EC2](https://aws.amazon.com/fr/ec2/purchasing-options/dedicated-instances/)

```bash
aws ec2 describe-instances
```

```bash
aws ec2 describe-instances --output table
```

```bash
aws ec2 describe-instances --output table
------------------------------------------------------------------------------------
|                                 DescribeInstances                                |
+----------------------------------------------------------------------------------+
||                                  Reservations                                  ||
|+---------------------------------+----------------------------------------------+|
||  OwnerId                        |  733718180495                                ||
||  ReservationId                  |  r-091126bd779f312ce                         ||
|+---------------------------------+----------------------------------------------+|
|||                                   Instances                                  |||
||+------------------------+-----------------------------------------------------+||
|||  AmiLaunchIndex        |  0                                                  |||
|||  Architecture          |  x86_64                                             |||
|||  ClientToken           |                                                     |||
|||  EbsOptimized          |  False                                              |||
|||  EnaSupport            |  True                                               |||
|||  Hypervisor            |  xen                                                |||
|||  ImageId               |  ami-0ebc281c20e89ba4b                              |||
|||  InstanceId            |  i-03f6971fddaff8558                                |||
|||  InstanceType          |  t2.micro                                           |||
|||  KeyName               |  demo-lab-key                                       |||
|||  LaunchTime            |  2018-10-28T12:34:52.000Z                           |||
|||  PrivateDnsName        |  ip-172-31-35-250.eu-west-3.compute.internal        |||
|||  PrivateIpAddress      |  172.31.35.250                                      |||
|||  PublicDnsName         |  ec2-35-180-32-243.eu-west-3.compute.amazonaws.com  |||
|||  PublicIpAddress       |  35.180.32.243                                      |||
|||  RootDeviceName        |  /dev/xvda                                          |||
|||  RootDeviceType        |  ebs                                                |||
|||  SourceDestCheck       |  True                                               |||
|||  StateTransitionReason |                                                     |||
|||  SubnetId              |  subnet-074deb4a                                    |||
|||  VirtualizationType    |  hvm                                                |||
|||  VpcId                 |  vpc-476c332e                                       |||
||+------------------------+-----------------------------------------------------+||
||||                             BlockDeviceMappings                            ||||
|||+--------------------------------------+-------------------------------------+|||
||||  DeviceName                          |  /dev/xvda                          ||||
|||+--------------------------------------+-------------------------------------+|||
|||||                                    Ebs                                   |||||
||||+--------------------------------+-----------------------------------------+||||
|||||  AttachTime                    |  2018-10-28T12:34:52.000Z               |||||
|||||  DeleteOnTermination           |  True                                   |||||
|||||  Status                        |  attached                               |||||
|||||  VolumeId                      |  vol-043ff032d638e917a                  |||||
||||+--------------------------------+-----------------------------------------+||||
||||                                 CpuOptions                                 ||||
|||+-----------------------------------------------------------+----------------+|||
||||  CoreCount                                                |  1             ||||
||||  ThreadsPerCore                                           |  1             ||||
|||+-----------------------------------------------------------+----------------+|||
||||                                 Monitoring                                 ||||
|||+-------------------------------+--------------------------------------------+|||
||||  State                        |  disabled                                  ||||
|||+-------------------------------+--------------------------------------------+|||
||||                              NetworkInterfaces                             ||||
|||+-----------------------+----------------------------------------------------+|||
||||  Description          |                                                    ||||
||||  MacAddress           |  0e:3e:0a:fc:59:56                                 ||||
||||  NetworkInterfaceId   |  eni-092f4bd7687ea0b89                             ||||
||||  OwnerId              |  733718180495                                      ||||
||||  PrivateDnsName       |  ip-172-31-35-250.eu-west-3.compute.internal       ||||
||||  PrivateIpAddress     |  172.31.35.250                                     ||||
||||  SourceDestCheck      |  True                                              ||||
||||  Status               |  in-use                                            ||||
||||  SubnetId             |  subnet-074deb4a                                   ||||
||||  VpcId                |  vpc-476c332e                                      ||||
|||+-----------------------+----------------------------------------------------+|||
|||||                                Association                               |||||
||||+----------------+---------------------------------------------------------+||||
|||||  IpOwnerId     |  amazon                                                 |||||
|||||  PublicDnsName |  ec2-35-180-32-243.eu-west-3.compute.amazonaws.com      |||||
|||||  PublicIp      |  35.180.32.243                                          |||||
||||+----------------+---------------------------------------------------------+||||
|||||                                Attachment                                |||||
||||+------------------------------+-------------------------------------------+||||
|||||  AttachTime                  |  2018-10-28T12:34:52.000Z                 |||||
|||||  AttachmentId                |  eni-attach-0f2b364177e190547             |||||
|||||  DeleteOnTermination         |  True                                     |||||
|||||  DeviceIndex                 |  0                                        |||||
|||||  Status                      |  attached                                 |||||
||||+------------------------------+-------------------------------------------+||||
|||||                                  Groups                                  |||||
||||+-------------------------+------------------------------------------------+||||
|||||  GroupId                |  sg-04edf90e659364a62                          |||||
|||||  GroupName              |  demo-lab                                      |||||
||||+-------------------------+------------------------------------------------+||||
|||||                            PrivateIpAddresses                            |||||
||||+---------------------+----------------------------------------------------+||||
|||||  Primary            |  True                                              |||||
|||||  PrivateDnsName     |  ip-172-31-35-250.eu-west-3.compute.internal       |||||
|||||  PrivateIpAddress   |  172.31.35.250                                     |||||
||||+---------------------+----------------------------------------------------+||||
||||||                               Association                              ||||||
|||||+----------------+-------------------------------------------------------+|||||
||||||  IpOwnerId     |  amazon                                               ||||||
||||||  PublicDnsName |  ec2-35-180-32-243.eu-west-3.compute.amazonaws.com    ||||||
||||||  PublicIp      |  35.180.32.243                                        ||||||
|||||+----------------+-------------------------------------------------------+|||||
||||                                  Placement                                 ||||
|||+--------------------------------------------+-------------------------------+|||
||||  AvailabilityZone                          |  eu-west-3c                   ||||
||||  GroupName                                 |                               ||||
||||  Tenancy                                   |  default                      ||||
|||+--------------------------------------------+-------------------------------+|||
||||                               SecurityGroups                               ||||
|||+-------------------------+--------------------------------------------------+|||
||||  GroupId                |  sg-04edf90e659364a62                            ||||
||||  GroupName              |  demo-lab                                        ||||
|||+-------------------------+--------------------------------------------------+|||
||||                                    State                                   ||||
|||+-------------------------------+--------------------------------------------+|||
||||  Code                         |  16                                        ||||
||||  Name                         |  running                                   ||||
|||+-------------------------------+--------------------------------------------+|||
```

```bash
aws ec2 describe-instances --filters "Name=tag:Name,Values=demo-lab"

```

```bash
aws ec2 describe-instances --filters "Name=instance-type,Values=t2.micro" --query Reservations[].Instances[].InstanceId
```

```bash
[
    "i-01295da4c589e3178"
]
```

```bash
export AWS_INSTANCE="i-03f6971fddaff8558"
```

```bash
aws ec2 describe-instances \
    --instance-ids $AWS_INSTANCE \
    --query "Reservations[*].Instances[*].PublicDnsName"
```

### 2.4. Connexion à l'instance

```bash
ssh -i ~/.ssh/demo-lab-key.pem ec2-user@ec2-35-180-32-243.eu-west-3.compute.amazonaws.com
```

### 2.5. Opérations sur l'instance (Ansible)

```bash
sudo yum -y update
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

### 2.6. Une application simple

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

### 2.7. Terminer une instance

```bash
aws ec2 terminate-instances --instance-ids $AWS_INSTANCE
```

## 3. AWS CloudFormation

AWS CloudFormation fournit un langage commun pour décrire et provisionner toutes les ressources d'infrastructure dans votre environnement cloud. CloudFormation vous permet d'utiliser un simple fichier texte pour modéliser et provisionner, de manière automatisée et sécurisée, toutes les ressources nécessaires pour vos applications à travers toutes les régions et tous les comptes. Ce fichier sert de source unique de vérité pour votre environnement cloud.

### 3.1. Fonctionnement AWS CloudFormation

![Fonctionnement AWS CloudFormation](https://d1.awsstatic.com/CloudFormation%20Assets/howitworks.c316d3856638c6c9786e49011bad660d57687259.png)

### 3.2. Notes

[https://console.aws.amazon.com/cloudformation/designer](https://console.aws.amazon.com/cloudformation/designer)

[https://templates.cloudonaut.io/en/stable/](https://templates.cloudonaut.io/en/stable/)

[https://github.com/widdix/learn-cloudformation/](https://github.com/widdix/learn-cloudformation/)

[https://medium.com/boltops/a-simple-introduction-to-aws-cloudformation-part-1-1694a41ae59d](https://medium.com/boltops/a-simple-introduction-to-aws-cloudformation-part-1-1694a41ae59d)

[https://github.com/tongueroo/cloudformation-examples/blob/master/templates/single-instance.yml](https://github.com/tongueroo/cloudformation-examples/blob/master/templates/single-instance.yml)

## 4. LightSail

[https://lightsail.aws.amazon.com/ls/docs/en/articles/getting-started-with-amazon-lightsail](https://lightsail.aws.amazon.com/ls/docs/en/articles/getting-started-with-amazon-lightsail)
