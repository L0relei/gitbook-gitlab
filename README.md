# Introduction

Auteur : {{ gitbook.author }}

Date de fabrication : {{ gitbook.time }}

* [PDF](ebooks/gitbook-gitlab.pdf)
* [EPUB](ebooks/gitbook-gitlab.epub)
* [MOBI](ebooks/gitbook-gitlab.mobi)

## Projet CI/CD de publication

* Scénario : Hébergement d'un site Web statique sur AWS
* Application : Gitbook-cli Toolchain
* Pipeline : Gitlab-ci
  * avec un gitlab-runner

## Scénario :  Hébergement d'un site Web statique sur AWS

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
* Cloudformation

## Application : Gitbook-cli Toolchain

[Gitbook Toolchain](https://toolchain.gitbook.com/)

## Pipeline : Gitlab-ci

![Pipeline Gitlab-ci, Test, Build and Deploy](/images/pipeline-gitbook-gitlab.png)

### Approvisionnement du Gitlab-runner

* AWS EC2
