# Hébergement d'un site Web statique sur AWS

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

### 1.1. Livrable Web aux normes actuelles

* IPv6
* HTTP 2.O
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

## 2. Expérimentation dans la console AWS

### 2.1. Création d'un bucket avec un utilisateur autorisé

! Référence à ajouter

* IAM
* Création d'un Bucket

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
  * configurez la journalisation pour le trafic du site web (facultatif)
  * testez le point de terminaison et la redirection
* ajoutez des enregistrements d'alias pour example.com et www.example.com
* test

### 2.4. accélérez votre site web avec Amazon CloudFront

[Inspiration](https://docs.aws.amazon.com/fr_fr/AmazonS3/latest/dev/website-hosting-cloudfront-walkthrough.html)

* Création d'une distribution CloudFront
* Mise à jour des jeux d'enregistrements pour votre domaine et votre sous-domaine
* (Facultatif) Vérification des fichiers journaux

## 3. Expérimentation avec aws-cli

## 4. Outils d'approvisionnement

### 4.1. Cloudformation

* [Cloudformation template for creating static website](https://github.com/sjevs/cloudformation-s3-static-website-with-cloudfront-and-route-53)

### 4.2. Ansible

* [Ansible route53_zone - add or delete Route53 zones](https://docs.ansible.com/ansible/latest/modules/route53_zone_module.html)
* ACM ?
* [Ansible Role - Sets up a website in a S3 bucket fronted by Cloudfront for HTTPs and custom domains](https://github.com/mediapeers/ansible-role-s3-website-hosting)

### 4.3. Terraform

* [Terraform scripts to setup an S3 based static website, with a CloudFront distribution and the required Route53 entries.](https://github.com/ringods/terraform-website-s3-cloudfront-route53)
