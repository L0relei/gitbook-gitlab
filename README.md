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

![Projet CI/CD de publication](https://www.lucidchart.com/publicSegments/view/3babd77b-00ef-42ac-a9b9-570b5feee80e/image.png)

## Modèle

[Netlify](https://www.netlify.com/features/) : Build, deploy, and manage modern web projects. An all-in-one workflow that combines global deployment, continuous integration, and automatic HTTPS. And that’s just the beginning.

## Dev

Dev = Application

Outil | Fournisseur | Alternatives
--- | --- | ---
Application Toolchain | **Gitbook-cli** | ...
Source Control Management | **Git**, **Gitlab** | Github, Gitlab Hosted (AWS), AWS CodeCommit, ...
CI / CD Tool | **Gitlab-ci**, **Gitlab-runner** | Jenkins, AWS CodePipeline, AWS CodeDeploy, Bitbucket
Container Repository | **Gitlab Hub** | Docker Hub,
Test | versions, markdown-lint, npm (gitbook), pip (aws-cli) | ...

ToDo :

* Fabrication automatique des images container

## Ops

Ops = Infrastructure

Service | Fournisseur | Alternatives
--- | --- | ---
Name Registry  | AWS Registrar  |  OVH, Gandi
DNS | AWS Route53 | Cloudflare, OVH
TLS / HTTPS | AWS Certificate Manager | Let's Encrypt
CDN | Cloudfront | Cloudflare, OVH
Hosting / Storage | AWS S3 | ...

**Méthodes**

* Manuelle
* Ansible
* Cloudformation
