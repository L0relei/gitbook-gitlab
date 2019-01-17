# Hébergement d'un site Web statique sur AWS S3

<!-- toc -->

## 1. Idée de base

Basé sur le _White Paper_ ["Hosting Static Websites on AWS"](https://aws.amazon.com/fr/getting-started/projects/host-static-website/)

![Hébergement d'un site Web statique sur AWS](https://d1.awsstatic.com/Projects/v1/AWS_StaticWebsiteHosting_Architecture_4b.da7f28eb4f76da574c98a8b2898af8f5d3150e48.png)

On trouvera ici une proposition à évaluer, à adapter et à améliorer sous forme IaC (Infrastructure as Code).

* Stockage / hébergement : AWS S3
* DNS : AWS Route 53
* CDN / Logging : AWS Cloudfront
* HTTPS : AWS Certificate Manager
* Credits Management : AWS IAM

### Phases

* Phase de construction et éploiement sur un Bucket S3 existant (pipeline CI/CD)
* Infrastructure nécessaire : Nom, DNS, Distribution, certificat, utilisateur et policies (IaC)
* Comment intégrer les deux ?

### Phase Infra

* Création du Bucket S3 avec une propriété 'website'. Existe-t-il ?
* Une distribution Cloudfront associée au Bucket S3 existe-t-elle ?
* Le nom de domaine est-il en gestion Route 53 ? Est-il associé ?
* Le certificat HTTPS existe-t-il pour le domaine ?
* Idempotence ?

### 1.1. Livrable Web aux normes actuelles

* IPv6
* HTTP 2.0
* CDN
* HTTPS
* Robustesse du stockage

### 1.2. Avantages des sites Web statiques

Qu'est-ce qu'un générateur de site statique ?

Le concept de base d'un générateur de site statique (aussi appelé moteur de site statique) est simple: **prendre du contenu et des données dynamiques et générer des fichiers HTML/JavaScript/CSS statiques pouvant être déployés sur le serveur.** Cette idée n'est pas nouvelle. [^static-site-generators]

[^static-site-generators]: [Voir cet excellent source  du blog O'Reilly](https://www.oreilly.com/ideas/static-site-generators).

On peut caractériser les sites fabriqués de cette manière :

* Il existe de nombreux services, gratuits et payants, qui offrent la possibilité d'ajouter des aspects dynamiques dans des pages statiques.
* Les fichiers de sites statiques sont livrés à l'utilisateur final exactement comme ils le sont sur le serveur.
* Il n'y a pas de langage côté serveur.
* Il n'y a pas de base de données.
* Les sites statiques sont en HTML, CSS et JavaScript.
* Les performances, l'hébergement, la sécurité, la gestion des versions de contenu sont des avantages des sites statiques.

### 1.3. Coûts estimés

Coûts estimés mensuels.

![Coûts estimés mensuels](/images/aws-static-costs.png)

[AWS Tableau de bord Gestion de la facturation et des coûts](https://console.aws.amazon.com/billing/home?region=us-east-1#/)

### 1.4. Aspects dynamiques

Il y a lieu de réfléchir aux aspects dynamiques à donner au livrable.

* Interaction avec les utilisateurs : commentaires, support en ligne
* Vente en ligne des artefacts, vente en ligne sur Amazon (production de livres papier)
* Protection des pages, fidélisation
* URL signées
* ...

### Droits nécessaires

À définir précisément.

* S3
* Cloudfront
* Route53
* ACM

## 2. Expérimentation dans la console AWS

[Mise en route sur Amazon Simple Storage Service](https://docs.aws.amazon.com/fr_fr/AmazonS3/latest/gsg/GetStartedWithS3.html)

Inspiration : un tuto parmi beaucoup d'autres [Hosting a HTTPS static website on Amazon S3 w/ CloudFront and Route 53](https://medium.com/@matthewmanuel/hosting-a-https-static-website-on-amazon-s3-w-cloudfront-and-route-53-f347a16b6a91) avec des captures d'écran.

### 2.1. Création d'un bucket avec un utilisateur autorisé

* IAM
* [Comment créer un compartiment S3 ?](https://docs.aws.amazon.com/fr_fr/AmazonS3/latest/user-guide/create-bucket.html)
* [Utilisation des commandes s3 de haut niveau avec l'AWS Command Line Interface](https://docs.aws.amazon.com/fr_fr/cli/latest/userguide/using-s3-commands.html)
* [s3](https://docs.aws.amazon.com/cli/latest/reference/s3/)

### 2.2. Configuration d'un site web statique

[Inspiration](https://docs.aws.amazon.com/fr_fr/AmazonS3/latest/dev/HostingWebsiteOnS3Setup.html)

* Création d'un compartiment et configuration de celui-ci comme site web
* Ajout d'une stratégie de compartiment permettant de rendre disponible publiquement le contenu de votre compartiment
* Chargement d'un document Web, Chargement d'un document d'index
* Test de votre site web

### 2.3. Configuration d'un site web statique grâce à un domaine personnalisé

[Inspiration](https://docs.aws.amazon.com/fr_fr/AmazonS3/latest/dev/website-hosting-custom-domain-walkthrough.html)

* enregistrez un domaine
* créez et configurez des compartiments et chargez des données
  * créez deux compartiments
  * configurez des compartiments pour l'hébergement de site Web
  * configurez la redirection de site web
  * configurez la "journalisation" pour le trafic du site web (facultatif)
  * testez le point de terminaison et la redirection
* ajoutez des enregistrements d'alias pour example.com et www.example.com
* test

### 2.4. accélérez votre site web avec Amazon CloudFront

[Inspiration](https://docs.aws.amazon.com/fr_fr/AmazonS3/latest/dev/website-hosting-cloudfront-walkthrough.html)

* Création d'une distribution CloudFront
* Mise à jour des jeux d'enregistrements pour votre domaine et votre sous-domaine
* (Facultatif) Vérification des fichiers journaux

## 3. Expérimentation avec aws-cli

On suppose qu'un certificat HTTPS est disponible et que l'on dispose de son ARN. On suppose que la zone Route 53 existe.

Se référer à [Hosting a Static Website with Hugo and AWS](https://nickolaskraus.org/articles/hosting-a-website-with-hugo-and-aws/) pour la correction.

### Étape 1 : Créer le bucket pour un hébergment Web Statique

Créer un compartiment et activer l'hébergement d'un site web statique sur le compartiment.

Le point de terminaison de votre compartiment est `bucketname.s3-website-region.amazonaws.com`.

Ajoutez une stratégie de compartiment qui autorise un accès en lecture public sur le compartiment que vous avez créé.

```bash
BUCKET_NAME="test1.aws-fr.com"
BUCKET_REGION="eu-west-3"
aws s3 mb s3://${BUCKET_NAME} --region ${BUCKET_REGION}
echo '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Allow Public Access to All Objects",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::'${BUCKET_NAME}'/*"
    }
  ]
}' > /tmp/policy.json

aws s3api put-bucket-policy --bucket ${BUCKET_NAME} --policy file:///tmp/policy.json
aws s3 website s3://${BUCKET_NAME} --index-document index.html --error-document error.html

mkdir website
cat < EOF >> website/index.html
<html xmlns="http://www.w3.org/1999/xhtml" >
<meta charset="UTF-8">
<head>
    <title>My Website Home Page</title>
</head>
<body>
  <h1>Welcome to my website</h1>
  <p>Now hosted on Amazon S3!</p>
</body>
</html>
EOF
aws s3 sync --acl public-read --delete website/ s3://${BUCKET_NAME}
curl http://${BUCKET_NAME}.s3-website.eu-west-3.amazonaws.com/

```

```bash
aws s3 rm s3://${BUCKET_NAME} --recursive
aws s3 rb s3://${BUCKET_NAME}
```

### Étape 2 Distribution Cloudfront et certificat HTTPS

Créez une distribution web CloudFront. Assurez-vous de configurer les paramètres suivants :

* Pour Nom du domaine d'origine, indiquez le point de terminaison.
* Pour Méthodes HTTP autorisées, sélectionnez GET, HEAD, OPTIONS.
* Pour Autres noms de domaine (CNAME), entrez le CNAME que vous souhaitez utiliser pour votre site web.

Si vous souhaitez utiliser le protocole SSL pour votre site web, vous pouvez choisir l'option Demander ou importer un certificat avec ACM pour demander un certificat.

```bash
aws acm request-certificate --domain-name example.com --subject-alternative-names a.example.com b.example.com *.c.example.com

```

Quoi qu'il en soit l'"arn" du certificat sera nécessaire, on le place dans une variable `CERTIFICATE_ARN`


à vérifier et à corriger

```bash
aws configure set preview.cloudfront true
```

```bash
CERTIFICATE_ARN="arn:aws:acm:us-east-1:733718180495:certificate/e60e1dd7-6329-4598-bc85-6003b2237cf5"
```


```shell
cat < EOF >> /tmp/distconfig.json
{
    "DistributionConfig": {
        "Comment": "Demo Distribution",
        "CacheBehaviors": {
            "Quantity": 0
        },
        "IsIPV6Enabled": true,
        "Logging": {
            "Bucket": "",
            "Prefix": "",
            "Enabled": false,
            "IncludeCookies": false
        },
        "WebACLId": "",
        "Origins": {
            "Items": [
                {
                    "OriginPath": "",
                    "CustomOriginConfig": {
                        "OriginSslProtocols": {
                            "Items": [
                                "TLSv1",
                                "TLSv1.1",
                                "TLSv1.2"
                            ],
                            "Quantity": 3
                        },
                        "OriginProtocolPolicy": "http-only",
                        "OriginReadTimeout": 30,
                        "HTTPPort": 80,
                        "HTTPSPort": 443,
                        "OriginKeepaliveTimeout": 5
                    },
                    "CustomHeaders": {
                        "Quantity": 0
                    },
                    "Id": "S3-${BUCKET_NAME}",
                    "DomainName": "${BUCKET_NAME}.s3-website-${BUCKET_REGION}.amazonaws.com"
                }
            ],
            "Quantity": 1
        },
        "DefaultRootObject": "index.html",
        "PriceClass": "PriceClass_100",
        "Enabled": true,
        "DefaultCacheBehavior": {
            "FieldLevelEncryptionId": "",
            "TrustedSigners": {
                "Enabled": false,
                "Quantity": 0
            },
            "LambdaFunctionAssociations": {
                "Quantity": 0
            },
            "TargetOriginId": "S3-${BUCKET_NAME}",
            "ViewerProtocolPolicy": "redirect-to-https",
            "ForwardedValues": {
                "Headers": {
                    "Quantity": 0
                },
                "Cookies": {
                    "Forward": "none"
                },
                "QueryStringCacheKeys": {
                    "Quantity": 0
                },
                "QueryString": false
            },
            "MaxTTL": 2592000,
            "SmoothStreaming": false,
            "DefaultTTL": 86400,
            "AllowedMethods": {
                "Items": [
                    "HEAD",
                    "GET"
                ],
                "CachedMethods": {
                    "Items": [
                        "HEAD",
                        "GET"
                    ],
                    "Quantity": 2
                },
                "Quantity": 2
            },
            "MinTTL": 0,
            "Compress": true
        },
        "CallerReference": "'${BUCKET_NAME}'-'`date +%s`'",
        "ViewerCertificate": {
            "SSLSupportMethod": "sni-only",
            "ACMCertificateArn": "${CERTIFICATE_ARN}",
            "MinimumProtocolVersion": "TLSv1.1_2016",
            "Certificate": "${CERTIFICATE_ARN}",
            "CertificateSource": "acm"
        },
        "CustomErrorResponses": {
            "Items": [
                {
                    "ErrorCode": 403,
                    "ResponsePagePath": "/index.html",
                    "ResponseCode": "200",
                    "ErrorCachingMinTTL": 300
                },
                {
                    "ErrorCode": 404,
                    "ResponsePagePath": "/index.html",
                    "ResponseCode": "200",
                    "ErrorCachingMinTTL": 300
                }
            ],
            "Quantity": 2
        },
        "OriginGroups": {
            "Items": [],
            "Quantity": 0
        },
        "HttpVersion": "http2",
        "Restrictions": {
            "GeoRestriction": {
                "RestrictionType": "none",
                "Quantity": 0
            }
        },
        "Aliases": {
            "Items": [
                "${BUCKET_NAME}"
            ],
            "Quantity": 1
        }
    }
}
EOF
```

```bash
aws cloudfront create-distribution --distribution-config file:///tmp/distconfig.json > /tmp/distconfig_result.json

cat /tmp/distconfig_result.json | jq .Distribution.DomainName

```


### Étape 3

Mettez à jour les enregistrements DNS pour que votre domaine pointe le CNAME de votre site web vers votre nom de domaine de distribution CloudFront. Le nom de domaine de votre distribution est disponible dans la console CloudFront dans un format similaire à celui-ci : d1234abcd.cloudfront.net.

Attendez que vos modifications de DNS soient propagées et que les entrées précédentes du DNS expirent.

[Comment créer des jeux d'enregistrements de ressources d'alias dans Route 53 à l'aide de l'interface de ligne de commande AWS CLI ?](https://aws.amazon.com/fr/premiumsupport/knowledge-center/alias-resource-record-set-route53-cli/)

[Jeu d'enregistrement de ressources d'alias pour une distribution CloudFront](https://docs.aws.amazon.com/fr_fr/AWSCloudFormation/latest/UserGuide/quickref-route53.html#w2ab1c17c23c81c11)

```json
"myDNS" : {
    "Type" : "AWS::Route53::RecordSetGroup",
    "Properties" : {
        "HostedZoneId" : { "Ref" : "myHostedZoneID" },
        "RecordSets" : [{
            "Name" : { "Ref" : "myRecordSetDomainName" },
            "Type" : "A",
            "AliasTarget" : {
                "HostedZoneId" : "Z2FDTNDATAQYW2",
                "DNSName" : { "Ref" : "myCloudFrontDistributionDomainName" }
            }
        }]
    }
}
```

Note : Pour les points de terminaison optimisés pour les périphériques, l'ID de la zone hébergée Route 53 est Z2FDTNDATAQYW2 pour toutes les régions.

### Étape 4

Utilisateur S3 pour les mise à jour

Create the user

```bash
aws iam create-user --user-name S3-user
```

Create the policy

```bash
aws iam create-policy --policy-name S3-user-write --policy-document file://iam.json

```

Attach the iam policy to the user (policy-arn will be in output from previous command)

```bash
aws iam attach-user-policy --usr-name S3-user --policy-arn arn:aws:iam::938109129012:policy/S3-user-write

```

You probably want the access and secret key for your user to use somewhere:

```bash
aws iam create-access-key --user-name S3-user

```

### Étape 5

```bash
CDN_DISTRIBUTION_ID="E2E3MF8G25BWVL"
aws s3 sync --acl public-read --delete website/ s3://${BUCKET_NAME}
aws cloudfront create-invalidation --distribution-id ${CDN_DISTRIBUTION_ID} --paths "/*"
# The next time a viewer requests the file, CloudFront returns to the origin to fetch the latest version of the file.
```

## 4. Outils d'approvisionnement, de gestion de configuration, d'orchestration, IaC

### 4.1. Bash avec aws cli et jq

* [A collection of bash shell scripts for automating various tasks with Amazon Web Services using the AWS CLI and jq.](https://github.com/swoodford/aws)

### 4.2. Ansible

* [Ansible route53_zone - add or delete Route53 zones](https://docs.ansible.com/ansible/latest/modules/route53_zone_module.html)
* ACM ?
* [Ansible Role - Sets up a website in a S3 bucket fronted by Cloudfront for HTTPs and custom domains](https://github.com/mediapeers/ansible-role-s3-website-hosting)

### 4.3. Cloudformation

* [Cloudformation template for creating static website](https://github.com/sjevs/cloudformation-s3-static-website-with-cloudfront-and-route-53)

### 4.3. Terraform

* [Terraform scripts to setup an S3 based static website, with a CloudFront distribution and the required Route53 entries.](https://github.com/ringods/terraform-website-s3-cloudfront-route53)
* [Terraform module to easily provision CloudFront CDN backed by an S3 origin https://cloudposse.com/](https://github.com/cloudposse/terraform-aws-cloudfront-s3-cdn)

## 5. Expérimentation Ansible

Voici un exemple de livre de jeu en un seul fichier déploie un site web en HTTP sur un Bucket S3 et qui le détruit ensuite (fichier [demo-s3-http.yml](ansible-aws/demo-s3-http.yml)).

```yaml
#demo-s3-http.yml
---
- name: Deploy S3 Static Website
  hosts: localhost
  vars:
    BUCKET_NAME: "{{ ansible_date_time.iso8601_micro | to_uuid }}" # random bucket name
    BUCKET_REGION: "eu-west-3"
    SOURCE_PATH: /tmp/website
  tasks:
    - name: create a website directory to host the website files
      file:
        path: "{{ SOURCE_PATH }}"
        state: directory
    - name: create a index.html file
      copy:
        dest: "{{ SOURCE_PATH }}/index.html"
        content: |
          <html xmlns="http://www.w3.org/1999/xhtml" >
          <head>
              <title>My Website Home Page {{ BUCKET_NAME }}</title>
          </head>
          <body>
            <h1>Welcome to my website {{ BUCKET_NAME }}</h1>
            <p>Now hosted on Amazon S3!</p>
          </body>
          </html>
    - name: Create a bucket and attach policy
      s3_bucket:
        name: "{{ BUCKET_NAME }}"
        state: present
        region: "{{ BUCKET_REGION }}"
        policy:
          Version: '2012-10-17'
          Statement:
          - Sid: Allow Public Access to All Objects
            Effect: Allow
            Principal: "*"
            Action: s3:GetObject
            Resource: arn:aws:s3:::{{ BUCKET_NAME }}/*
    - name: set website configuration index/error file
      s3_website:
        name: "{{ BUCKET_NAME }}"
        state: present
        error_key: error.html
    - name: synchronize the files
      s3_sync:
        bucket: "{{ BUCKET_NAME }}"
        file_root: "{{ SOURCE_PATH }}/"
        permission: public-read
        delete: yes
    - name: 5 sec. waiting
      pause:
        seconds: 5
        prompt: "Please check the URL http://{{ BUCKET_NAME }}.s3-website.{{ BUCKET_REGION }}.amazonaws.com/"
    - name: test the website
      uri:
        url: "http://{{ BUCKET_NAME }}.s3-website.{{ BUCKET_REGION }}.amazonaws.com/"
        return_content: yes
      register: thepage
      failed_when: "'{{ BUCKET_NAME }}' not in thepage.content"
    - name: 3 minutes waiting before deleting the bucket
      pause:
        minutes: 3
    - name: Delete a bucket and all contents
      aws_s3:
        bucket: "{{ BUCKET_NAME }}"
        mode: delete
```

### 5.1. Livre de jeu

Voir le document local [ansible-aws](ansible-aws/roles/s3-website-hosting/README.md)

On crée un libre de jeu adapté avec les bonnes variables.

```yaml
#s3-website.yml
- hosts: localhost
  vars:
    website_root: 'website/'
    s3_website_bucket_name: 'test6.aws-fr.com'
    s3_website_alias_domain_names:
      - 'test6.aws-fr.com'
    s3_website_certificate_arn: 'arn:aws:acm:us-east-1:733718180495:certificate/e60e1dd7-6329-4598-bc85-6003b2237cf5'
    s3_website_create_dns_record: true
    s3_website_root_object: 'index.html'
  roles:
     - s3-website-hosting
```

#### Rôle d'hébergement

On a ajouté une tâche de synchronisation d'un site de test.

```yaml
#roles/s3-website-hosting/tasks/main.yml
---
- import_tasks: s3-cloudfront-route53.yml
- import_tasks: sync-s3.yml
```

On ajouté des entrées `ignore_errors` pour être en mesure de jouer le rôle.

```yaml
#grep 'name:' roles/s3-website-hosting/tasks/s3-cloudfront-route53.yml
- name: Name of the website s3 bucket that will be used
- name: Create S3 bucket for website hosting
- name: S3 bucket details
- name: Configure S3 bucket for website hosting
- name: Output Website domains
- name: Search CloudFront distribution based on alias domain names given (task fails if cloudfront still needs creating)
- name: Assign first found element to variable
- name: Extract distribution config if Cloudfront distribution was found
- name: Output infos of existing CloudFront distribution (confirm if correct one was matched)
- name: Wait to give time to read above message
- name: Set caller reference to pre-existing one or generate new one for creating new Cloudfront distribution
- name: Output caller reference to be used to identify Cloudfront dist
- name: Create Cloudfront Website distribution
- name: Output result diff
- name: Save Cloudfront Domain and ID in variables
- name: Output Cloudfront domain
- name: Output Cloudfront ID
- name: Create DNS alias for CloudFront distribution on Route53
```

Cette liste de tâche on été ajoutée.

```yaml
#roles/s3-website-hosting/tasks/sync-s3.yml
---
- name: synchronize files
  s3_sync:
    bucket: "{{ website_bucket.name }}"
    file_root: "{{ website_root }}"
    file_change_strategy: force
    permission: public-read
    delete: yes
- name: create a batch of invalidations using a distribution_id for a reference
  cloudfront_invalidation:
    distribution_id: "{{ cloudfront_website_distribution.id }}"
    target_paths:
      - /*
```

#### Optimisation

* Création du certificat
* Restriction des droits

## 6. En Python

* [S3 Website Using cf , Route 53 and Python Scripts](https://100awsprojects.com/post/2018-01-27-s3-website-using-cf--route-53-and-python-scripts/#create-route53-a-record-and-cname)

## 7. Template Cloudformation

* [Cloudformation template for creating static website](https://github.com/sjevs/cloudformation-s3-static-website-with-cloudfront-and-route-53)

![Cloudformation template for creating static website](/images/WebsiteBucket-designer.png)
