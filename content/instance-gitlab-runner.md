# Serveur de génération sur AWS

<!-- toc -->

Scénarios de montée en charge

## Gitlab-ci sur AWS EC2

### AWS Marketplace

Installation de [GitLab Community Edition AMI sur l'AWS Marketplace](https://aws.amazon.com/marketplace/pp/B071RFCJZK) :

![GitLab Community Edition AMI sur l'AWS Marketplace](/images/AWS-Marketplace-GitLab-Community-Edition.jpg)

L'image est gratuite et une instance t2.medium (2 vCPUs et 4G RAM) est recommandé selon un modèle de coût pour une seule instance :

* 0,054 $ /heure
* 1,3 $ /jour
* 40,18 $ /mois

### Installation manuelle

* [https://about.gitlab.com/install/#ubuntu](https://about.gitlab.com/install/#ubuntu)

### HA (Highly Available) configuration for GitLab on AWS

[Installing GitLab on Amazon Web Services (AWS)](https://docs.gitlab.com/ee/install/aws/)

![AWS Architecture for Gitlab](https://docs.gitlab.com/ee/install/aws/img/aws_diagram.png)

## Alternative : Jenkins sur AWS EC2

[Configuration d'un serveur de génération Jenkins](https://aws.amazon.com/fr/getting-started/projects/setup-jenkins-build-server/)

![Configuration d'un serveur de génération Jenkins](https://d1.awsstatic.com/Projects/P5505030/arch-diagram_jenkins.7677f587a3727562ec4e6c7e69ed594729cab171.png)

## Architecture Gitlab sur AWS

[Autoscaling GitLab Runner on AWS](https://docs.gitlab.com/runner/configuration/runner_autoscale_aws/)

## Installation et configuration de Gitlab Runner

...

## Scénario de vie / Orchestration

...
