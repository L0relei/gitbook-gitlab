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

* Déploiement sur un Bucket S3 existant
* Infrastructure nécessaire : Nom, DNS, Distribution, certificat, utilisateur et policies.
* Construction

#### Phase Infra

* Création du Bucket S3 avec une propriété 'website'. Existe-t-il ?
* Une distribution Cloudfront associée au Bucket S3 existe-t-elle ?
* Le nom de domaine est-il en gestion Route 53 ? Est-il associé ?
* Le certificat HTTPS existe-t-il pour le domaine ?

### 1.1. Livrable Web aux normes actuelles

* IPv6
* HTTP 2.0
* CDN
* HTTPS
* Robustesse du stockage

### 1.2. Avantages des sites Web statiques

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

## 2. Expérimentation dans la console AWS

[Mise en route sur Amazon Simple Storage Service](https://docs.aws.amazon.com/fr_fr/AmazonS3/latest/gsg/GetStartedWithS3.html)

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

### Étape 1

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
cat << EOF >> website/index.html
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title>My Website Home Page</title>
</head>
<body>
  <h1>Welcome to my website</h1>
  <p>Now hosted on Amazon S3!</p>
</body>
</html>
EOF
aws s3 sync --acl public-read --sse --delete website/ s3://${BUCKET_NAME}
curl http://${BUCKET_NAME}.s3-website.eu-west-3.amazonaws.com/

```

```bash
aws s3 rm s3://${BUCKET_NAME} --recursive
aws s3 rb s3://${BUCKET_NAME}
```

### Étape 2

4. Créez une distribution web CloudFront. Assurez-vous de configurer les paramètres suivants :

Pour Nom du domaine d'origine, indiquez le point de terminaison.
Pour Méthodes HTTP autorisées, sélectionnez GET, HEAD, OPTIONS.
Pour Autres noms de domaine (CNAME), entrez le CNAME que vous souhaitez utiliser pour votre site web.

5. Si vous souhaitez utiliser le protocole SSL pour votre site web, vous pouvez choisir l'option Demander ou importer un certificat avec ACM pour demander un certificat. Pour plus d'informations, consultez Utilisation de noms de domaines alternatifs et de HTTPS.

6. Choisissez Créer une distribution.

```bash
aws configure set preview.cloudfront true

cat << EOF >> /tmp/distconfig.json
{
    "CallerReference": "'${BUCKET_NAME}'-'`date +%s`'",
    "Aliases": {
        "Quantity": 0
    },
    "DefaultRootObject": "",
    "Origins": {
        "Quantity": 1,
        "Items": [
            {
                "OriginPath": "",
                "S3OriginConfig": {
                    "OriginAccessIdentity": ""
                },
                "Id": "S3-${BUCKET_NAME}",
                "DomainName": "${BUCKET_NAME}.s3.amazonaws.com"
            }
        ]
    },
    "DefaultCacheBehavior": {
        "TrustedSigners": {
            "Enabled": false,
            "Quantity": 0
        },
        "TargetOriginId": "S3-${BUCKET_NAME}",
        "ViewerProtocolPolicy": "allow-all",
        "ForwardedValues": {
            "Headers": {
                "Items": [
                    "Access-Control-Request-Headers",
                    "Origin"
                ],
                "Quantity": 2
            },
            "Cookies": {
                "Forward": "none"
            },
            "QueryString": true
        },
        "MaxTTL": 31536000,
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
        "MinTTL": 0
    },
    "CacheBehaviors": {
        "Quantity": 0
    },
    "Comment": "",
    "Logging": {
        "Bucket": "",
        "Prefix": "",
        "Enabled": false,
        "IncludeCookies": false
    },
    "WebACLId": "",
    "PriceClass": "PriceClass_All",
    "Enabled": true,
    "ViewerCertificate": {
        "CloudFrontDefaultCertificate": true,
        "MinimumProtocolVersion": "SSLv3"
    },
    "CustomErrorResponses": {
        "Quantity": 0
    },
    "Restrictions": {
        "GeoRestriction": {
            "RestrictionType": "none",
            "Quantity": 0
        }
}
EOF

aws cloudfront create-distribution --distribution-config file:///tmp/distconfig.json > /tmp/distconfig_result.json

cat /tmp/distconfig_result.json | jq .Distribution.DomainName

```

### Étape 3

7. Mettez à jour les enregistrements DNS pour que votre domaine pointe le CNAME de votre site web vers votre nom de domaine de distribution CloudFront. Le nom de domaine de votre distribution est disponible dans la console CloudFront dans un format similaire à celui-ci : d1234abcd.cloudfront.net.

8. Attendez que vos modifications de DNS soient propagées et que les entrées précédentes du DNS expirent.

### TLS

```bash
aws acm request-certificate --domain-name example.com --subject-alternative-names a.example.com b.example.com *.c.example.com
```

## 4. Outils d'approvisionnement, de gestion de configuration, d'orchestration, IaC

[A collection of bash shell scripts for automating various tasks with Amazon Web Services using the AWS CLI and jq.
](https://github.com/swoodford/aws)

### 4.1. Cloudformation

* [Cloudformation template for creating static website](https://github.com/sjevs/cloudformation-s3-static-website-with-cloudfront-and-route-53)

### 4.2. Ansible

* [Ansible route53_zone - add or delete Route53 zones](https://docs.ansible.com/ansible/latest/modules/route53_zone_module.html)
* ACM ?
* [Ansible Role - Sets up a website in a S3 bucket fronted by Cloudfront for HTTPs and custom domains](https://github.com/mediapeers/ansible-role-s3-website-hosting)

### 4.3. Terraform

* [Terraform scripts to setup an S3 based static website, with a CloudFront distribution and the required Route53 entries.](https://github.com/ringods/terraform-website-s3-cloudfront-route53)

## 5. Expérimentation Ansible

Voir le document local [ansible-aws/roles/s3-website-hosting](ansible-aws/roles/s3-website-hosting/README.md)

### 5.1. Livre de jeu

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

### 2. Rôle d'hébergement

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

### 5.3. Optimisation

* Création du certificat
* Restriction des droits