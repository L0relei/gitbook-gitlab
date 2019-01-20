# Ops vers Dev en IaC

<!-- toc -->

## 1. Ops vers Dev

![Ops vers Dev](https://www.lucidchart.com/publicSegments/view/0fb88f39-3133-4d6d-9112-118e73fe485d/image.png)

## 2. AWS

AWS Amazon Web Services est le leader mondial des technologies en nuage (voir plus loin).

### 2.1. Hébergement S3

* Découverte du service AWS S3
* Hébergement d'un site Web
* Domaine, HTTPS, distribution Cloudfront

### 2.2. Instances d'exécution EC2

* Automatisation d'instances EC2.
* Instances de conteneur [Amazon Elastic Container Service (ECS)](https://aws.amazon.com/fr/ecs/) / [Amazon Elastic Container Registry (ECR)](https://aws.amazon.com/fr/ecr/)

## 3. Infrastructure as Code

Comparaison des outils IaC : Cloudformation | Ansible | Terraform

* [Comparing CloudFormation, Terraform and Ansible - Simple example](https://technodrone.blogspot.com/2018/06/comparing-cloudformation-terraform-and.html)
* [Comparing CloudFormation, Terraform and Ansible - Part #2](https://technodrone.blogspot.com/2018/07/comparing-cloudformation-terraform-and.html)
* [Pourquoi ansible n’est pas un bon choix pour créer son infra AWS ?](https://blog.xebia.fr/2017/03/14/pourquoi-ansible-nest-pas-un-bon-choix-pour-creer-son-infra-aws/)

### 3.1. Ansible

[Amazon Web Services Guide](https://docs.ansible.com/ansible/latest/scenario_guides/guide_aws.html)

### 3.2. Cloudformation

...

## 4. Alternatives

### 4.1. Google Cloud Platform (GCP)

...

### 4.2. Microsoft Azure

...

### 4.3. API OpenStack

OVH, par exemple.

### 4.4. API Tierce

Scaleway pour ses offres "Compute" mais utilise l'API de S3 pour son offre "Bucket".

## 5. Introduction à AWS DevOps

### 5.1. Fondamentaux

* [https://aws.amazon.com/fr/training/course-descriptions/cloud-practitioner-essentials/](https://aws.amazon.com/fr/training/course-descriptions/cloud-practitioner-essentials/)
* [https://aws.amazon.com/fr/devops/](https://aws.amazon.com/fr/devops/)

### 5.2. Technologie Cloud

* [The NIST Definition of Cloud Computing](https://nvlpubs.nist.gov/nistpubs/legacy/sp/nistspecialpublication800-145.pdf)
* [NIST Cloud Computing Standards Roadmap](https://www.nist.gov/sites/default/files/documents/itl/cloud/NIST_SP-500-291_Version-2_2013_June18_FINAL.pdf)

### 5.3. Philosophie et outils DevOps

* [https://aws.amazon.com/fr/devops/what-is-devops/](https://aws.amazon.com/fr/devops/what-is-devops/)

![DevOps Feedback](https://d1.awsstatic.com/product-marketing/DevOps/DevOps_feedback-diagram.ff668bfc299abada00b2dcbdc9ce2389bd3dce3f.png)

Illustration :

* [Netlify](https://jamstatic.fr/2018/01/07/netlify-en-10-fonctionnalites/)

Formation : [Apprendre le développement continu avec des générateurs de site statique](https://ci-cd.goffinet.org/)

### 5.4. La philosophie culturelle de DevOps

La transition vers le DevOps implique un changement de culture et d'état d'esprit.

Pour simplifier, le DevOps consiste à éliminer les obstacles entre deux équipes traditionnellement isolées l'une de l'autre : l'équipe de développement et l'équipe d'exploitation. Certaines entreprises vont même jusqu'à ne pas avoir d'équipes de développement et d'exploitation séparées, mais des ingénieurs assurant les deux rôles à la fois.

* Avec le DevOps, les deux équipes travaillent en collaboration pour optimiser la productivité des développeurs et la fiabilité des opérations.
* Elles cherchent à communiquer fréquemment, à gagner en efficacité et à améliorer la qualité des services offerts aux clients.
* Elles assument l'entière responsabilité de leurs services, et vont généralement au-delà des rôles ou postes traditionnellement définis en pensant aux besoins de l'utilisateur final et à comment les satisfaire.
* Les équipes d'assurance qualité et de sécurité peuvent également s'intégrer davantage à ces équipes.

Les organisations adoptant un modèle axé sur le DevOps, quelle que soit leur structure organisationnelle, rassemblent des équipes qui considèrent tout le cycle de développement et d'infrastructure comme faisant partie de leurs responsabilités.

### 5.5. Explications à propos des bonnes pratiques concernant DevOps

Il existe quelques pratiques clés pouvant aider les organisations à innover plus rapidement, par le biais de l'automatisation et de la simplification des processus de développement de logiciel et de gestion d'infrastructure. La plupart de ces pratiques sont rendues possibles par l'utilisation des outils appropriés.

Une pratique fondamentale consiste à réaliser des **mises à jour très fréquentes, mais de petite taille**. Ainsi, les entreprises innovent plus rapidement pour leurs clients. Ces mises à jour sont généralement de nature plus incrémentielle que les mises à jour occasionnelles associées aux pratiques de publication traditionnelles. Le recours à des mises à jour petites, mais fréquentes, limite les risques associés à chaque déploiement. Les équipes ont plus de facilité à détecter les bogues, car il est possible d'identifier le dernier déploiement ayant provoqué l'erreur. Bien que la cadence et la taille des mises à jour soient variables, les entreprises utilisant un modèle de DevOps déploient des mises à jour beaucoup plus fréquemment que les entreprises utilisant des pratiques de développement de logiciel traditionnelles.

Les organisations peuvent également utiliser **une architecture de microservices** pour rendre leurs applications plus flexibles et favoriser des innovations plus rapides. L'architecture de microservices réduit de grands systèmes complexes pour obtenir des projets simples et indépendants. Les applications sont divisées en plusieurs composants (services) individuels, chaque service étant associé à une mission ou fonction spécifique et exploité indépendamment des autres services et de l'application dans son ensemble. Cette architecture réduit les coûts de coordination liés aux mises à jour d'applications, et quand chaque service est tenu par de petites équipes agiles, les entreprises avancent plus rapidement.

Cependant, l'alliance des microservices et d'une fréquence de publication plus élevée entraîne une augmentation considérable du nombre de déploiements, ce qui peut poser des problèmes opérationnels. Les pratiques de DevOps comme **l'intégration continue et la livraison continue** résolvent donc ces problèmes et permettent aux entreprises de livrer rapidement de manière fiable et sûre. Les pratiques d'automatisation de l'infrastructure, comme l'infrastructure en tant que code et la gestion de configuration, aident à préserver la souplesse et la réactivité des ressources informatiques face aux modifications fréquentes. En outre, le recours à la supervision et à la journalisation aide les ingénieurs à suivre les performances des applications et de l'infrastructure de manière à réagir rapidement en cas de problème.

Ensemble, ces pratiques aident les entreprises à livrer rapidement des mises à jour plus fiables à leurs clients. Voici une vue d'ensemble des pratiques de DevOps les plus importantes.

### 5.6. Explications à propos de l'intégration continue

L'intégration continue est une méthode de développement de logiciel DevOps avec laquelle les développeurs intègrent régulièrement leurs modifications de code à un référentiel centralisé, suite à quoi des opérations de création et de test sont automatiquement menées. L'intégration continue désigne souvent l'étape de création ou d'intégration du processus de publication de logiciel, et implique un aspect automatisé (un service d'IC ou de création) et un aspect culturel (apprendre à intégrer fréquemment). Les principaux objectifs de l'intégration continue sont de trouver et de corriger plus rapidement les bogues, d'améliorer la qualité des logiciels et de réduire le temps nécessaire pour valider et publier de nouvelles mises à jour de logiciels.

#### Pourquoi l'intégration continue est-elle nécessaire

Autrefois, les développeurs au sein d'une même équipe avaient tendance à travailler séparément pendant de longues périodes et à n'intégrer leurs modifications au référentiel centralisé qu'après avoir fini de travailler. Cela a rendu la fusion de changement de codes difficile et chronophage, et a également entraîné des bogues pendant une longue période, sans correction. La combinaison de ces différents facteurs empêchait de livrer rapidement des mises à jour aux clients.

### 5.7. Comment fonctionne l'intégration continue

Avec l'intégration continue, les développeurs appliquent régulièrement leurs modifications sur un référentiel partagé, avec un système de contrôle des versions comme Git. Avant d'envoyer leur code, les développeurs peuvent choisir d'exécuter des tests sur des unités locales pour le vérifier davantage avant son l'intégration. Un service d'intégration continue crée et exécute automatiquement des tests unitaires sur les nouveaux changements de codes pour détecter immédiatement n'importe quelle erreur.

![CI](https://d1.awsstatic.com/product-marketing/DevOps/continuous_integration.4f4cddb8556e2b1a0ca0872ace4d5fe2f68bbc58.png)

L'intégration continue désigne les étapes de création et de test d'unité du processus de publication de logiciel. Chaque révision appliquée déclenche un processus de création et de test automatisé.

Avec la livraison continue, les modifications de code sont automatiquement appliquées, testées et préparées à la production. La livraison continue étend le principe de l'intégration continue en déployant tous les changements de code dans un environnement de test et/ou un environnement de production après l'étape de création.

### 5.8. Avantages de l'intégration continue

#### Améliorer la productivité des développeurs

![Améliorer la productivité des développeurs](https://d1.awsstatic.com/product-marketing/DevOps/CICD_improve-productivity.c73191c7af7e9f0a859c9ec8af8b1bd4e4eae5be.png)

L'intégration continue aide votre équipe à gagner en productivité, en limitant de nombre de tâches manuelles devant être accomplies par les développeurs et en encourageant les comportements qui contribuent à réduire le nombre d'erreurs et de bogues dans les versions publiées auprès des clients.

#### Trouver et corriger plus rapidement les bogues

![Trouver et corriger plus rapidement les bogues](https://d1.awsstatic.com/product-marketing/DevOps/CICD_find-bugs.a60937d9bd1ba25ac3781db46758ebe92c5c889a.png)

Avec des tests plus fréquents, votre équipe peut découvrir et corriger plus rapidement les bogues avant qu'ils ne prennent de l'ampleur.

#### Livrer plus rapidement des mises à jour

![Livrer plus rapidement des mises à jour](https://d1.awsstatic.com/product-marketing/DevOps/CICD_deliver-updates.1d175ba80e02e998a0bcb5f4918bac95338820b2.png)

L'intégration continue aide votre équipe à livrer plus rapidement et plus fréquemment des mises à jour après des clients.

### 5.9. Explications à propos de la livraison continue

La livraison continue est une méthode de développement de logiciels DevOps avec laquelle les changements de code sont automatiquement générés, testés et préparés pour une publication dans un environnement de production. Cette pratique étend le principe de l'intégration continue en déployant tous les changements de code dans un environnement de test et/ou un environnement de production après l'étape de création. Une bonne livraison continue permet aux développeurs de toujours disposer d'un artéfact prêt au déploiement après avoir suivi un processus de test normalisé.

La livraison continue permet aux développeurs d'automatiser les tests au-delà des simples tests d'unité, afin de vérifier différents aspects d'une mise à jour d'application avant de la déployer auprès des clients. Il peut s'agir de tests d'interface, de charge, d'intégration, de fiabilité de l'API, etc. De cette manière, les développeurs peuvent vérifier de façon plus complète les mises à jour et détecter les éventuels problèmes à corriger avant le déploiement. Avec le cloud, l'automatisation de la création et de la réplication de plusieurs environnements de test est facile et économique, alors qu'une telle opération serait difficile à mettre en œuvre avec une infrastructure sur site.

#### Livraison continue vs. déploiement continu

Grâce à la livraison continue, chaque modification de code est appliquée, testée puis envoyée vers un environnement de test ou de préparation hors production. Plusieurs procédures de test peuvent avoir lieu en parallèle avant un déploiement de production. La différence entre la livraison continue et le déploiement continu réside dans la présence d'une approbation manuelle pour mettre à jour et produire. Avec le déploiement continu, la production se fait automatiquement, sans approbation explicite.

#### Avantages de la livraison continue

En plus des avantages l'intégration continue, la livraison continue a pour avantage :

* **Automatiser le processus de publication de logiciel**

![Automatiser le processus de publication de logiciel](https://d1.awsstatic.com/product-marketing/DevOps/CICD_automate-release.06a38e2a6d9e866ffb50ddb3168e6d9976c2ddf5.png)

La livraison continue permet à votre équipe de créer, tester et préparer automatiquement les modifications de code en vue d'une mise en production, afin d'améliorer la rapidité et l'efficacité de vos projets de livraison de logiciel.

## 6. Produits AWS CI/CD

Dans une solution Amazon AWS, on configure un flux de travail d'intégration continue avec [AWS CodePipeline](https://aws.amazon.com/fr/codepipeline/), qui vous permet de créer un flux de travail qui produit du code dans [AWS CodeBuild](https://aws.amazon.com/fr/codebuild/) à chaque fois que vous validez un changement.

### 6.1. Microservices

L'architecture de microservices est une approche de conception qui consiste à diviser une application en un ensemble de petits services. Chaque service est exécuté par son propre processus et communique avec les autres services par le biais d'une interface bien définie et à l'aide d'un mécanisme léger, typiquement une interface de programmation d'application (API) HTTP. Les microservices sont conçus autour de capacités métier. Chaque service est dédié à une seule fonction. Vous pouvez utiliser différents frameworks ou langages de programmation pour écrire des microservices et les déployer indépendamment, en tant que service unique ou en tant que groupe de services.

#### Produits AWS microservices

* [Amazon Container Service (ECS)](https://aws.amazon.com/fr/ecs/) : Service de conteneurs logiciels.
* [AWS Lambda](https://aws.amazon.com/fr/lambda/) : exécution de code à la demande.

### 6.2. Infrastructure en tant que code

L'infrastructure en tant que code est une pratique qui implique la mise en service et la gestion de l'infrastructure à l'aide de code et de techniques de développement de logiciel, notamment le contrôle des versions et l'intégration continue. Le modèle axé sur les API du cloud permet aux développeurs et aux administrateurs système d'interagir avec l'infrastructure de manière programmatique et à n'importe quelle échelle, au lieu de devoir installer et configurer manuellement chaque ressource. Ainsi, les ingénieurs peuvent créer une interface avec l'infrastructure à l'aide d'outils de code et traiter l'infrastructure de la même manière qu'un code d'application. Puisqu'ils sont définis par du code, l'infrastructure et les serveurs peuvent être rapidement déployés à l'aide de modèles standardisés, mis à jour avec les derniers patchs et les dernières versions, ou dupliqués de manière répétable.

Le produit [AWS CloudFormation](https://aws.amazon.com/fr/cloudformation/) est un outil qui permet de gérer une infrastructure en tant que code.

#### Gestion de configuration

Les développeurs et les administrateurs système utilisent du code pour automatiser la configuration du système d'exploitation et de l'hôte, les tâches opérationnelles et bien plus encore. Le recours au code permet de rendre les changements de configuration répétables et standardisés. Les développeurs et les administrateurs système ne sont plus tenus de configurer manuellement les systèmes d'exploitation, les applications système ou les logiciels de serveur.

Le produit Amazon [EC2 Systems Manager](https://aws.amazon.com/fr/ec2/systems-manager/) permet de configurer et de gérer des systèmes Amazon EC2.

Le produit [AWS OpsWorks](https://aws.amazon.com/fr/opsworks/) offre des fonctions de gestion des configuration.

### 6.3. Consignation et supervision

Les entreprises suivent les métriques et les journaux pour découvrir l'impact des performances de l'application et de l'infrastructure sur l'expérience de l'utilisateur final du produit.

En capturant, catégorisant et analysant les données et les journaux générés par les applications et l'infrastructure, les organisations comprennent l'effet des modifications ou des mises à jour sur les utilisateurs, afin d'identifier les véritables causes de problèmes ou de changements imprévus.

La supervision active est de plus en plus importante, car les services doivent aujourd'hui être disponibles 24 heures sur 24 et la fréquence des mises à jour d'infrastructure augmente sans cesse. La création d'alerte et l'analyse en temps réel de ces données aident également les entreprises à suivre leurs services de manière plus proactive.

Le produit [Amazon CloudWatch](https://aws.amazon.com/fr/cloudwatch/) permet de surveiller les métriques et journaux d'une infrastructure.

Le produit [AWS CloudTrail](https://aws.amazon.com/fr/cloudtrail/) permet d'enregistrer et de journaliser les appels d'API AWS.

### 6.4. Communication et collaboration

L'instauration d'une meilleure collaboration et communication au sein de l'entreprise est un des principaux aspects culturels du DevOps. Le recours aux outils de DevOps et l'automatisation du processus de livraison de logiciel établit la collaboration en rapprochant physiquement les workflows et les responsabilités des équipes de développement et d'exploitation.

Partant de cela, ces équipes instaurent des normes culturelles importantes autour du partager des informations et de la facilitation des communications par le biais d'applications de **messagerie**, de **systèmes de suivi des problèmes** ou des projets et de **wikis**. Cela permet d'accélérer les communications entre les équipes de développement et d'exploitation et même d'autres services comme le marketing et les ventes, afin d'aligner chaque composant de l'entreprise sur des objectifs et des projets communs.

### 6.5. Exemple de configuration d'un pipeline de CI/CD sur AWS

[https://aws.amazon.com/fr/getting-started/projects/set-up-ci-cd-pipeline/](https://aws.amazon.com/fr/getting-started/projects/set-up-ci-cd-pipeline/)

Dans ce projet, on découvre comment configurer un pipeline d'intégration et de livraison continues (CI/CD) sur AWS. Un pipeline aide à automatiser les étapes du processus de publication de logiciel, comme lancer les versions automatiques et les déployer ensuite sur les instances Amazon EC2.

On utilisera AWS CodePipeline pour créer, tester et déployer le code chaque fois que celui-ci est modifié, en fonction des modèles de processus de publication que l'on a définis.

![Mise en place d'un pipeline CI/CD sur AWS](https://d1.awsstatic.com/Projects/CICD%20Pipeline/setup-cicd-pipeline2.5cefde1406fa6787d9d3c38ae6ba3a53e8df3be8.png)
