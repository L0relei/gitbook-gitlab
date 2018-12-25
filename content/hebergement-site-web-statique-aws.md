# Hébergement d'un site Web statique sur AWS

<!-- toc -->

Basé sur le White Paper ["Hosting Static Websites on AWS"](https://aws.amazon.com/fr/getting-started/projects/host-static-website/)

![Hébergement d'un site Web statique sur AWS](https://d1.awsstatic.com/Projects/v1/AWS_StaticWebsiteHosting_Architecture_4b.da7f28eb4f76da574c98a8b2898af8f5d3150e48.png)

* Stockage / hébergement : AWS S3
* DNS : AWS Route 53
* CDN / Logging : AWS Cloudfront
* HTTPS : AWS Certificate Manager
* Credits Management : AWS IAM
* Gitlab-Runner : AWS EC2
* CI / CD : Gitlab
* Repo mgmt : Gitlab
* Advertisements : Slack
* Docker registry : Gitlab

## Coûts estimés

Coûts estimés mensuels.

![Coûts estimés mensuels](/images/aws-static-costs.png)

[AWS Tableau de bord Gestion de la facturation et des coûts](https://console.aws.amazon.com/billing/home?region=us-east-1#/)

## 1. Utilisateur autorisé

* IAM

## 2. Configuration d'un site web statique

[Inspiration](https://docs.aws.amazon.com/fr_fr/AmazonS3/latest/dev/HostingWebsiteOnS3Setup.html)

### Création d'un compartiment et configuration de celui-ci comme site web

### Ajout d'une stratégie de compartiment permettant de rendre disponible publiquement le contenu de votre compartiment

### Chargement d'un document Web

Chargement d'un document d'index

### Test de votre site web

## 3. Configuration d'un site web statique grâce à un domaine personnalisé

[Inspiration](https://docs.aws.amazon.com/fr_fr/AmazonS3/latest/dev/website-hosting-custom-domain-walkthrough.html)

### enregistrez un domaine

### créez et configurez des compartiments et chargez des données

#### créez deux compartiments

#### configurez des compartiments pour l'hébergement de site Web

#### configurez la redirection de site web

#### configurez la journalisation pour le trafic du site web (facultatif)

#### testez le point de terminaison et la redirection

### ajoutez des enregistrements d'alias pour example.com et www.example.com

### test

## 4. accélérez votre site web avec Amazon CloudFront

[Inspiration](https://docs.aws.amazon.com/fr_fr/AmazonS3/latest/dev/website-hosting-cloudfront-walkthrough.html)

### Création d'une distribution CloudFront

### Mise à jour des jeux d'enregistrements pour votre domaine et votre sous-domaine

### (Facultatif) Vérification des fichiers journaux
