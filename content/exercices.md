# Exercices

<!-- toc -->

## Projet 1. Créer un Bucket de type website et y pousser une page Web

### 1.a. En AWS CLI

Publier un repo `user/s3-website-cli`.

### 1.b. En Python 3

Publier un repo `user/s3-website-python3`.

## Projet 2. Reproduire le lab d'automation Wordpress

### 2.a. En AWS CLI

publier un repo `user/ec2-wordpress-cli`.

[Voir Exécution de commandes sur votre instance Linux lors du lancement](https://docs.aws.amazon.com/fr_fr/AWSEC2/latest/UserGuide/user-data.html#user-data-api-cli)

Script "init" disponible sur [https://raw.githubusercontent.com/goffinet/aws-112018/master/scripts/script8.sh](https://raw.githubusercontent.com/goffinet/aws-112018/master/scripts/script8.sh).

### 2.b. En Python 3

### 2.c. Avec Ansible

## Projet 3. Déployer un site Web Statique en HTTPS CDN IPV6 sur un domaine

### 3.a. Avec Ansible

publier un repo `user/s3-https-cdn-ansible`.

### 3.b. Avec Cloudformation

publier un repo `user/s3-https-cdn-cf`.

### 3.c. Avec Terraform

publier un repo `s3-https-cdn-tf`.

## Projet 4. Configurer son projet Gitlab-gitbook

### 4.a. Mise en place

publier un repo `user/gitlab-gitbook`

* Fork du projet
* clé SSH
* image conteneur docker
* fichier gitlab-ci.yml
* Bucket S3
* Variables

### 4.b. Améliorations à proposer

* Choix du service SCM.
* Choix et emplacement du serveur d'intégration.
* Choix et emplacement des noeuds d'exécution.
* Choix du registry Docker
* Fabrication automatique des images "container" sur un registry (docker hub, gitlab hub ou encore AWS).
* Fabrication d'une seule image intégrée (gitbook et aws-cli) en couches ou unique.
* Mieux intégrer npm et calibre, voire pandoc dans le stage "build".
* Découpler la phase "deploy" et ses dépendances pour chaque build.
* Ajouter un stage post-test sur les artefacts.
* Convertir en livre de jeu Ansible.
* Partir d'un contenu jekyll pour la sortie HTML et markdown sans frontmatter pour traitement ultérieur en PDF, MOBI, EPUB, Kindle, notamment avec Gitbook ou MkDocs-material.
* Test du site Web (OWASP Top 10)

## Projet 5. Créer et publier un présentation en HTML 5

publier un repo `user/devops-aws-ppt`.

Exemples :

* [LandSlide - Generate HTML5 slideshows from markdown, ReST, or textile](https://github.com/adamzap/landslide)
* [Example Presentations in reveal.js](https://github.com/hakimel/reveal.js/wiki/Example-Presentations)
* [Gitpitch](https://gitpitch.com/)
