# Introduction

<!-- toc -->

## Informations générales

Auteur : {{ book.author }}

Date de fabrication : {{ gitbook.time }}

* [PDF](ebooks/gitbook-gitlab.pdf)
* [EPUB](ebooks/gitbook-gitlab.epub)
* [MOBI](ebooks/gitbook-gitlab.mobi)

## Projet CI/CD de publication

Scénario : CI /CD, Hébergement d'un site Web statique sur AWS en CDN et en HTTPS.

* Application : Gitbook-cli Toolchain
* Pipeline : Gitlab-ci
  * avec un gitlab-runner
* Hébergement et domaine : AWS S3/IAM, Route53, Cloudfront, Certificate Manager

![Projet CI/CD de publication](https://www.lucidchart.com/publicSegments/view/1de78137-3887-4e08-9364-07ed2a7031f8/image.jpeg)

## Budget

Budget AWS | Prix $ HTVA | Prix EUR TVAC
Inscription AWS | 2 $ HTVA | 2,12 EUR TVAC
Nom de domaine | 12$ HTVA | 12,75 EUR TVAC
Divers  | 4 $ HTVA  |  4,24 EUR TVAC
Total  | 18 $ HTVA  |  19,12 EUR TVAC

## Modèles

* [Gitbook.com Legacy](https://legacy.gitbook.com/)
* [Softcover](https://www.softcover.io/)
* [Netlify](https://www.netlify.com/features/) : Build, deploy, and manage modern web projects. An all-in-one workflow that combines global deployment, continuous integration, and automatic HTTPS. And that’s just the beginning.

### Autres références

* [Pandoc](https://pandoc.org/)
* [Book publishing toolchain based on AsciiDoc](https://github.com/jd/asciidoc-book-toolchain)
* [Latex](https://www.latex-project.org/)

## Les trois manières: les principes sur lesquels se base DevOps

![Les trois manières: les principes sur lesquels se base DevOps](https://dick1stark.files.wordpress.com/2016/11/three-ways.png)

1. Le premier concerne le flux de travail de gauche à droite, du développement aux opérations informatiques.
2. Le second concerne le flux constant de retours rapides de droite à gauche à toutes les étapes du flux de valeur.
3. La troisième méthode consiste à créer une culture qui favorise deux choses : l'expérimentation continue et la compréhension du fait que la répétition et la pratique sont les conditions préalables à la maîtrise.

Source : [The Three Ways: The Principles Underpinning DevOps](https://itrevolution.com/the-three-ways-principles-underpinning-devops/)

## Dev

Dev = Application

Outil | Fournisseur | Alternatives
--- | --- | ---
Application Toolchain | **Gitbook-cli** (_basé NPM_), calibre | ...
Source Control Management | **Git**, **Gitlab** | Github, Gitlab Hosted (AWS), AWS CodeCommit, ...
CI / CD Tool | **Gitlab-ci**, **Gitlab-runner** | Jenkins, AWS CodePipeline, AWS CodeDeploy, Bitbucket
Container Repository | **Gitlab Hub** | Docker Hub,
Test | versions, markdown-lint, npm (gitbook), pip (aws-cli) | ...
Deploy  | aws-cli s3  | Python API, aws-cli, openstack-cli, Ansible, ...

### ToDo

* Fabrication automatique des images "container"
* Mieux intégrer npm
* Mieux intégrer calibre
* Convertir en livre de jeu Ansible
* Partir d'un contenu jekyll en sortie HTML et markdown sans frontmatter pour traitement ultérieur en PDF, MOBI, EPUB, Kindle

## Ops

Ops = Infrastructure

Service | Fournisseur | Alternatives
--- | --- | ---
Name Registry  | AWS Registrar  |  OVH, Gandi
DNS | AWS Route53 | Cloudflare, OVH
TLS / HTTPS | AWS Certificate Manager | Let's Encrypt
CDN | Cloudfront | Cloudflare, OVH
Hosting / Storage | AWS S3 | ...
Build Node | Gitlab-ci hosted | ...

### Méthodes

* Manuelle
* Ansible
* Cloudformation
