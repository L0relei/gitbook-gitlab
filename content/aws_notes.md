# Notes

<!-- toc -->

## 1. AWS CloudFormation

AWS CloudFormation fournit un langage commun pour décrire et provisionner toutes les ressources d'infrastructure dans votre environnement cloud. CloudFormation vous permet d'utiliser un simple fichier texte (JSON ou YAML) pour modéliser et approvisionner de manière automatisée et sécurisée toutes les ressources nécessaires pour des applications à travers toutes les régions et tous les comptes. Ce fichier sert de source unique de vérité pour un environnement cloud.

### Fonctionnement AWS CloudFormation

![Fonctionnement AWS CloudFormation](https://d1.awsstatic.com/CloudFormation%20Assets/howitworks.c316d3856638c6c9786e49011bad660d57687259.png)

### Notes

[https://console.aws.amazon.com/cloudformation/designer](https://console.aws.amazon.com/cloudformation/designer)

[https://templates.cloudonaut.io/en/stable/](https://templates.cloudonaut.io/en/stable/)

[https://github.com/widdix/learn-cloudformation/](https://github.com/widdix/learn-cloudformation/)

[https://medium.com/boltops/a-simple-introduction-to-aws-cloudformation-part-1-1694a41ae59d](https://medium.com/boltops/a-simple-introduction-to-aws-cloudformation-part-1-1694a41ae59d)

[https://github.com/tongueroo/cloudformation-examples/blob/master/templates/single-instance.yml](https://github.com/tongueroo/cloudformation-examples/blob/master/templates/single-instance.yml)

### Template Cloudformation de création d'un site web statique

* [Cloudformation template for creating static website](https://github.com/sjevs/cloudformation-s3-static-website-with-cloudfront-and-route-53)

![Cloudformation template for creating static website](/images/WebsiteBucket-designer.png)

## 3. Json

Un objet est "embarqué" entre les accolades (_curly braces_). Un tableau (_array_) d'objets est embarqué dans des crochets (_square brackets_). Les données sont représentées dans des paires nom/valeur séparées par des virgules.

Deux types de structures d'objet sont reconnues en JSON :

* Une collection de paires nom/valeur
* Des listes ordonnées de valeurs : tableau, liste, vecteurs, séquences, etc.

Ici un tableau "book" qui comprend deux objets (lignes) avec quatre propriétés (colones).

```json
{
   "book": [

      {
         "id": "01",
         "language": "Java",
         "edition": "third",
         "author": "Herbert Schildt"
      },

      {
         "id": "07",
         "language": "C++",
         "edition": "second",
         "author": "E.Balagurusamy"
      }

   ]
}
```

Ces données en format JSON peut être représentées sous forme de tableau.

<table><tbody><tr><td colspan="2"><div class="td_head">book</div><table style="width:100%"><tbody><tr><td><div class="td_head">id</div></td><td><div class="td_head">language</div></td><td><div class="td_head">edition</div></td><td><div class="td_head">author</div></td></tr><tr><td class="td_row_even"><div class="td_row_even">01</div></td><td class="td_row_even"><div class="td_row_even">Java</div></td><td class="td_row_even"><div class="td_row_even">third</div></td><td class="td_row_even"><div class="td_row_even">Herbert Schildt</div></td></tr><tr><td class="td_row_odd"><div class="td_row_odd">07</div></td><td class="td_row_odd"><div class="td_row_odd">C++</div></td><td class="td_row_odd"><div class="td_row_odd">second</div></td><td class="td_row_odd"><div class="td_row_odd">E.Balagurusamy</div></td></tr></tbody></table></td></tr></tbody></table>



### Tutorial jq avec curl sur l'api de Github

À visiter absolument

[jq tutorial](https://stedolan.github.io/jq/tutorial/)

```bash
api="https://api.github.com"
echo ${api}
user="goffinet"
echo ${user}
user_url=${api}/users/${user}
echo ${user_url}
repos_url=$(curl -s ${user_url} | jq -r .repos_url)
echo ${repos_url}

```

## 4. Nouvelle structure de cours

### 1. Introduction à AWS

#### 1.1. Impact des technologies en nuage

Sémantique :

* Définition, type et modèles en nuage
* IaC
* DevOps, NoOps, ...
* Serverless, micro-services
* CI/CD
* Agile

#### 1.2. Présentation AWS

Introduction

Marché et capitalisation boursière

Infrastructure AWS

#### 1.3. Services AWS

Présentation rapide des différents services AWS

#### 1.4. Certifications AWS

* Programme / prix / conditions / type
* Contenu
* Practice
* Examen

### 2. Service IAM et Billing

#### 2.1. Méthodes d'administration

* AWS console
* aws cli et Python

#### 2.2. Se connecter à AWS

* Lien de connexion des utilisateurs IAM
* utilisateurs et groupes
* Différence entre rôles et stratégies
* Guide des bonnes pratiques IAM
* Interface de facturation
* Balises

### 2.3. Pratiques d'administration IAM

TP : S'inscrire sur AWS et configurer son compte racine

TP: Créer un compte d'administration

TP : Créer des accès S3 pour utilisateurs IAM

TP : Créer des accès EC2 pour utilisateurs IAM

TP : Créer une alerte de facturation

### 3. Amazon Simple Storage Service (Amazon S3)

Présentation des produits de stockage

#### 3.1. Présentation du service S3

Description

Performances, scalabilité, disponibilité et durabilité

Gamme de classes de stockage

Sécurité, conformité et audit

Modèles de prix S3

#### 3.2. Initiation à S3

En Console Web

* Création et peuplement d'un Bucket
* Autorisations (accès public, ACl, stratégie de bucket, CORS)
* Versionning

#### 3.3. Pratique d'administration S3

TP : ... python

TP : ... Bash

TP : ... S3 Website

TP : ... Réplication entre régions




### 4. Cloudfront

TP :


### 5. Route 53

DNS

Simple Routing Policy

Wheighted Routing Policy

Latency Routing Policy

Failover Routing Policy

Geolocation Routing Policy

### 6. EC2

AMI

Type d'instances

EBS

Groupes Auto-scaling

TP : Site Wordpress Auto-hébergé

TP : Serverless Website with Lambda

### 7. RDS

### 8. VPC
