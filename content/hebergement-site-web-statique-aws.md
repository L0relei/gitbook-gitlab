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
