# Introduction

<!-- toc -->

## Projet CI/CD de publication

Auteur : {{ book.author }}

Date de fabrication : {{ gitbook.time }}

* [PDF](ebooks/gitbook-gitlab.pdf)
* [EPUB](ebooks/gitbook-gitlab.epub)
* [MOBI](ebooks/gitbook-gitlab.mobi)

### Objectifs du document

Ce document a pour objectif premier de fournir un énoncé dans le cadre d'une étude de cas DevOps notamment avec la mise en oeuvre d'outils tels que git, gitlab, gitlab-ci, jenkins, docker, puppet, ansible, terraform, etc. sur une infrastructure AWS.

Les illustrations proposées sont à :

* évaluer
* adapter
* améliorer

Le résultat attendu est de fournir une solution sous forme de code informatique avec une documentation la plus complète. Il est livré sous forme de code dans un repo git chez un fournisseur tel que Github ou Gitlab.

Ce document d'énoncé n'a pas pour objectif de fournir une solution aboutie. Il pourrait toutefois évoluer dans cette direction.

### Scénario

Scénario : CI /CD, Hébergement d'un site Web statique sur AWS en CDN et en HTTPS.

![Projet CI/CD de publication](https://www.lucidchart.com/publicSegments/view/1de78137-3887-4e08-9364-07ed2a7031f8/image.jpeg)

L'énoncé pourrait être formulé de la manière suivante :

> Générer un livre numérique (ebook) en différents formats (HTML, PDF, MOBI, EPUB) en _intégration continue_ et _en livraison continue_ à partir d'un contenu écrit en Markdown sur une infrastructure dans le nuage. Le résultat attendu est la livraison continue du document sur un site Web aux normes actuelles (HTTPS et CDN) offrant les différents formats de lecture. La solution est fournie sous forme de code. Le résultat est évaluer sur base d'une vision défendue de la philosophie DevOps.

On trouvera dans ce document des points de départs et des outils à évaluer, à adapter et à améliorer.

* Hébergement du code source : git
* Application : Gitbook-cli Toolchain
* Pipeline : Gitlab-ci
  * avec un gitlab-runner (Docker)
* Hébergement Web :
  * AWS IAM
  * AWS S3,
  * AWS Route53,
  * AWS Cloudfront,
  * AWS Certificate Manager (ACM)

## Budget

Budget AWS | Prix $ HTVA | Prix EUR TVAC
--- | --- | ---
Inscription AWS | 2 $ HTVA | 2,12 EUR TVAC
Nom de domaine | 12$ HTVA | 12,75 EUR TVAC
Divers  | 4 $ HTVA  |  4,24 EUR TVAC
Total  | 18 $ HTVA  |  19,12 EUR TVAC

## Modèles et références

* [Gitbook.com Legacy](https://legacy.gitbook.com/) et Calibre
* [Softcover](https://www.softcover.io/)
* [Netlify](https://www.netlify.com/features/) : _Build, deploy, and manage modern web projects. An all-in-one workflow that combines global deployment, continuous integration, and automatic HTTPS. And that’s just the beginning._

### Autres références

* [Pandoc](https://pandoc.org/), un convertisseur open-source
* [Book publishing toolchain based on AsciiDoc](https://github.com/jd/asciidoc-book-toolchain)
* [Latex](https://www.latex-project.org/)
* Jekyll
* MkDocs-Material

## Principes DevOps

Rappel définition

![Les trois manières: les principes sur lesquels se base DevOps](https://dick1stark.files.wordpress.com/2016/11/three-ways.png)

1. Le premier concerne le flux de travail de gauche à droite, du développement aux opérations informatiques.
2. Le second concerne le flux constant de retours rapides de droite à gauche à toutes les étapes du flux de valeur.
3. La troisième méthode consiste à créer une culture qui favorise deux choses : l'expérimentation continue et la compréhension du fait que la répétition et la pratique sont les conditions préalables à la maîtrise.

Source : [The Three Ways: The Principles Underpinning DevOps](https://itrevolution.com/the-three-ways-principles-underpinning-devops/)

### Dev : Toolchains

Dev = Application, frameworks, stack, toolchain

Outil | Fournisseur | Alternatives
--- | --- | ---
Application Toolchain | **Gitbook-cli** (_basé NPM_), calibre | ...
Source Control Management | **Git**, **Gitlab** | Github, Gitlab Hosted (AWS), AWS CodeCommit, ...
CI / CD Tool | **Gitlab-ci**, **Gitlab-runner** | Jenkins, AWS CodePipeline, AWS CodeDeploy, Bitbucket
Container Repository | **Gitlab Hub** | Docker Hub,
Test | versions, **markdown-lint**, **npm** (gitbook), **pip** (aws-cli) | ...
Deploy  | **aws-cli s3**  | Python API, aws-cli, openstack-cli, Ansible, ...

### Ops : Infrastructure as code

Ops = Infrastructure

Service | Fournisseur | Alternatives
--- | --- | ---
Name Registry  | AWS Registrar  |  OVH, Gandi
DNS | AWS Route53 | Cloudflare, OVH
TLS / HTTPS | AWS Certificate Manager | Let's Encrypt
CDN | Cloudfront | Cloudflare, OVH
Hosting / Storage | AWS S3 | ...
Build Node | Gitlab-ci hosted | ...

#### Méthodes de configuration de l'infrastructure

* Manuelle
* Ansible
* Cloudformation
