# Présentation de Amazon Web services

<!-- toc -->

## 1. AWS : Présentation des services

* [Amazon EC2](https://aws.amazon.com/fr/ec2/) : Serveurs virtuels dans le cloud
* [Amazon Simple Storage Service (S3)](https://aws.amazon.com/fr/s3/) : Stockage adaptatif dans le cloud
* [Amazon DynamoDB](https://aws.amazon.com/fr/dynamodb/) : Base de données NoSQL gérée
* [Amazon RDS](https://aws.amazon.com/fr/rds/) : Service de base de données relationnelle géré pour MySQL, PostgreSQL, Oracle, SQL Server et MariaDB
* [AWS Lambda](https://aws.amazon.com/fr/lambda/?nc2=h_m1) : Exécution de code à la demande sans avoir à se soucier des serveurs
* [Amazon VPC](ttps://aws.amazon.com/fr/vpc/) : Contrôle, accès, services réseau
* [Amazon Lightsail](https://aws.amazon.com/fr/lightsail/) : Lancement et gestion de serveurs virtuels privés
* [Amazon Simple Notification Service (SNS)](https://aws.amazon.com/fr/ses/) : Pub/Sub, notifications Push sur mobile et SMS
* [AWS IAM](https://aws.amazon.com/fr/iam/) : service d'accès
* [AWS ROUTE53](https://aws.amazon.com/fr/route53/) : Service DNS
* [AWS Certificate Manager ACM](https://aws.amazon.com/fr/certificate-manager/) : Autorité de certification TLS, gestionnaire de certificats TLS
* [AWS Cloudfront](https://aws.amazon.com/fr/cloudfront/) : CDN mondial
* [AWS Elastic Beanstalk](https://aws.amazon.com/fr/elasticbeanstalk/) : Exécuter et gérer des applications web
* [Amazon EC2 Auto Scaling](https://aws.amazon.com/fr/ec2/autoscaling/) : Mettre à l'échelle la capacité de calcul pour répondre à la demande
* [Elastic Load Balancing (ELB)](https://aws.amazon.com/fr/elasticloadbalancing/) : Distribution de trafic entrant vers plusieurs cibles
* [AWS CloudFormation](https://aws.amazon.com/fr/cloudformation/) : Infrastructure en tant que code
* [AWS OpsWorks](https://aws.amazon.com/fr/opsworks/) : Automatisations des opérations grâce à Chef et Puppet
* [AWS CodeDeploy](https://aws.amazon.com/fr/codedeploy/?nc2=h_m1) : Automatisation des déploiements de code
* [Amazon Elastic Container Registry (ECR)](https://aws.amazon.com/fr/ecr/) : Registre de conteneurs
* [Amazon Elastic Container Service (ECS)](https://aws.amazon.com/fr/ecs/) : Service de conteneurs

Illustration de la fonction Lambda sur Neltify :

[Create your own URL shortener with Netlify's Forms and Functions](https://www.netlify.com/blog/2018/03/19/create-your-own-url-shortener-with-netlifys-forms-and-functions/) : [https://linkylinky.netlify.com/](https://linkylinky.netlify.com/) dont l'application : [https://shortener.eu/](https://shortener.eu/).

## 2. Magic Quadrant for Cloud Infrastructure as a Service

[AWS Named as a Leader in Gartner’s Infrastructure as a Service (IaaS) Magic Quadrant for 7th Consecutive Year](https://aws.amazon.com/fr/blogs/aws/aws-named-as-a-leader-in-gartners-infrastructure-as-a-service-iaas-magic-quadrant-for-7th-consecutive-year/)

![AWS Named as a Leader in Gartner’s Infrastructure as a Service (IaaS) Magic Quadrant for 7th Consecutive Year, 2017](/images/gartner_mq_iaas_2017_1.jpg)

Source : [Magic Quadrant for Cloud Infrastructure as a Service, Worldwide](https://www.gartner.com/doc/reprints?id=1-2G2O5FC&ct=150519&st=sb)

## 3. AWS /cli

[https://docs.aws.amazon.com/fr_fr/cli/latest/userguide/aws-cli.pdf](https://docs.aws.amazon.com/fr_fr/cli/latest/userguide/aws-cli.pdf)

### Installation d'AWS Command Line Interface

[Installation d'AWS Command Line Interface](https://docs.aws.amazon.com/fr_fr/cli/latest/userguide/cli-chap-welcome.html)

L'AWS CLI est un outil à code source libre qui vous permet d'interagir avec les services AWS à l'aide des commandes du shell de ligne de commande. Avec une configuration minimale, vous pouvez commencer à utiliser toutes les fonctionnalités fournies par la console AWS Management Console depuis l'invite de commande de votre programme terminal préféré.

### Configuration de l'AWS CLI

[Configuration de l'AWS CLI](https://docs.aws.amazon.com/fr_fr/cli/latest/userguide/cli-chap-configure.html)

### Boto 3

```bash
pip install boto3
```

## 4. Régions et AZ (zone de disponibilté)

Le cloud AWS gère 60 zones de disponibilité dans 20 régions géographiques autour du monde.

* [https://aws.amazon.com/fr/about-aws/global-infrastructure/](https://aws.amazon.com/fr/about-aws/global-infrastructure/)
* [https://docs.aws.amazon.com/fr_fr/AWSEC2/latest/UserGuide/using-regions-availability-zones.html](https://docs.aws.amazon.com/fr_fr/AWSEC2/latest/UserGuide/using-regions-availability-zones.html)

**Les régions AWS fournissent plusieurs zones de disponibilité physiquement séparées et isolées**, reliées par un réseau à faible latence, à débit élevé et à forte redondance.

![Infrastructure mondiale](https://d1.awsstatic.com/about-aws/regions/global-infra_3.30.18.b559f46825615c1ae40f319d0c4d9139fea9c492.png)

Amazon Infrastructure sur [Wiki Leaks](https://wikileaks.org/amazon-atlas/).

### Europe/Moyen-Orient/Afrique

![Europe/Moyen-Orient/Afrique](https://d1.awsstatic.com/global-infrastructure/maps/EMEA-UAE1000X1000.4c5421ef5ef22a2598d0e05da52996934e36fbb4.png)

Région Europe (Irlande)

* Zones de disponibilité EC2 : 3
* Lancée en 2007

Région Europe (Francfort)

* Zones de disponibilité EC2 : 3
* Lancée en 2014

Région Europe (Londres)

* Zones de disponibilité EC2 : 3
* Lancée en 2016

Région Europe (Paris)

* Zones de disponibilité EC2 : 3
* Lancée en 2017

Emplacements de réseaux périphériques AWS

Emplacements périphériques : Amsterdam, Pays-Bas (2) ; Berlin, Allemagne ; Le Cap, Afrique du Sud ; Copenhague, Danemark ; Dubai, Émirats arabes unis ; Dublin, Irlande Francfort, Allemagne (8) ; Fujairah, Émirats arabes unis, Helsinki, Finlande ; Johannesburg, Afrique du Sud ; Londres, Angleterre (7) ; Madrid, Espagne (2) ; Manchester, Angleterre ; Marseille, France ; Milan, Italie ; Munich, Allemagne ; Oslo, Norvège ; Palerme, Italie ; Paris, France (4) ; Prague, République tchèque ; Stockholm, Suède (3) ; Vienne, Autriche ; Varsovie, Pologne ; Zurich, Suisse

Caches périphériques régionaux : Francfort, Allemagne, Londres, Angleterre

```bash
aws ec2 describe-regions --output table
----------------------------------------------------------
|                     DescribeRegions                    |
+--------------------------------------------------------+
||                        Regions                       ||
|+-----------------------------------+------------------+|
||             Endpoint              |   RegionName     ||
|+-----------------------------------+------------------+|
||  ec2.ap-south-1.amazonaws.com     |  ap-south-1      ||
||  ec2.eu-west-3.amazonaws.com      |  eu-west-3       ||
||  ec2.eu-west-2.amazonaws.com      |  eu-west-2       ||
||  ec2.eu-west-1.amazonaws.com      |  eu-west-1       ||
||  ec2.ap-northeast-2.amazonaws.com |  ap-northeast-2  ||
||  ec2.ap-northeast-1.amazonaws.com |  ap-northeast-1  ||
||  ec2.sa-east-1.amazonaws.com      |  sa-east-1       ||
||  ec2.ca-central-1.amazonaws.com   |  ca-central-1    ||
||  ec2.ap-southeast-1.amazonaws.com |  ap-southeast-1  ||
||  ec2.ap-southeast-2.amazonaws.com |  ap-southeast-2  ||
||  ec2.eu-central-1.amazonaws.com   |  eu-central-1    ||
||  ec2.us-east-1.amazonaws.com      |  us-east-1       ||
||  ec2.us-east-2.amazonaws.com      |  us-east-2       ||
||  ec2.us-west-1.amazonaws.com      |  us-west-1       ||
||  ec2.us-west-2.amazonaws.com      |  us-west-2       ||
|+-----------------------------------+------------------+|

```
