# Pipeline : Gitlab-ci

<!-- toc -->

## 1. Idée

![Pipeline Gitlab-ci, Test, Build and Deploy](/images/pipeline-gitbook-gitlab.png)

Dans ce point de départ, le concepteur du contenu soumet son code au SCM.

Cette action enclenche une alerte auprès d'un serveur/service d'intégration continue qui exécute un pipeline divisé en quelques stages classiques (Test, Build, Deploy) interdépendants. Chaque stage comprend des jobs (ensembles de tâches) parallèles dont une exécution réussie fait passer à un stage suivant.

Les jobs sont habituellement exécutés dans des noeuds d'exécution partagés (sur Gitlab-ci) ou dédiés (gitlab-runner dans ce cas) habituellement dans le nuage. Ces exécuteurs sont des instances de calcul capables d'exécuter des images Docker. Nécessairement dans ce cadre des images Docker doivent être accessibles à travers un service de "repository" de conteneur. On peut aussi envisager la construction à la demande des images Docker, mais cette perspective est plus coûteuse. Il sera d'ailleurs conseillé d'embarquer l'outil de construction des artefacts.

Cette étape de la solution nécessite de s'intéresser aux outils d'intégration continue, à des toolchains différents basés node ou python, aux procédures spécifiques de tests, de construction et de déploiement. Le choix de docker comme exécuteur est certainement un choix judicieux qui pose questions sur son implémentation pour des raisons de performance.

Enfin, les étapes d'intégration continue et de le livraison continue sont annoncées sur le canal dédié d'un espace de travail Slack.

## 2. Boîte à outil

Ce tableau représente la proposition de départ.

Outil | Fournisseur | Alternatives
--- | --- | ---
Source Control Management | **Git**, **Gitlab** | Github, Gitlab Hosted (AWS), AWS CodeCommit, ...
CI/CD Tool | **Gitlab-ci**, **Gitlab-runner** | Jenkins, AWS CodePipeline, AWS CodeDeploy, Bitbucket
Environnement CI/CD  |  **Docker** |  local
Container Repository | **Gitlab Hub** | Docker Hub,
Test | versions, markdown-lint, npm (gitbook), pip (aws-cli) | ...
Application Toolchain (build) | **Gitbook-cli** (_basé NPM_), calibre | ...
Deploy  | aws-cli s3  | Python API, aws-cli, openstack-cli, Ansible, ...
Monitoring  | **Slack**  | AWS SNS, ...

Il est demandé de justifier le choix des outils sur base de différents critères :

* Coûts
* Centralisation, homogénéité
* Infrastructure as Code
* L'inter-opérabilité
* ...

Le Pipeline de base proposé est le suivant :

* Phase de test des outils et du code (test) : test des images docker et du code
* Phase de construction : usage des outils
* Phase de déploiement : déploiement auprès d'une infrastucture codée (ici sur AWS S3 en HTTPS/CDN)

## 3. Le serveur d'intégration

Git, Gitlab, Gitlab-CI, Gitlab Runner

## 4. Application : Toolchains

### Le Stack

L'application choisie n'utilise pas un compilateur C ou un framework JEE ou encore un célèbre framework Web PHP, Python, Node ou Angular.

L'apllication choisie est un générateur statique de sites Web [StaticGen : A List of Static Site Generators for JAMstack Sites](https://www.staticgen.com/).

### Gitbook-cli Toolchain

[Gitbook Toolchain](https://toolchain.gitbook.com/)

Il est recommandé de s'exercer sur le Toolchain gitbook-cli en suivant et en comprenant de manière approfondie le document [GitBook Toolchain Documentation](https://toolchain.gitbook.com/).

En bref au préalable,

* le toochain gitbook-cli est écrit en nodejs (utilitaire npm)
* la commande `gitbook` transforme un dossier de contenu écrit en Markdown en différent formats via le logiciel
* des plugins doivent être installés à titre de dépendances

### Toolchains dans une image Docker

L'avantage d'une exécution par Docker est de disposer d'un environnement identique pour un développement local et automatique.

Il est demandé d'exécuter les opérations à partir d'une image Docker comme par exemple "goffinet/gitbook".

```docker
# Base image, default node image
FROM node:10-slim

# Environment configuration
ENV GITBOOK_VERSION="3.2.3"

# Install gitbook
RUN npm install --global gitbook-cli \
  && gitbook fetch ${GITBOOK_VERSION} \
  && npm install --global markdownlint-cli \
  && npm cache clear --force \
        && apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
             #wget \
             #curl \
             #vim \
             #openssh-client \
             calibre \
             ttf-freefont \
             ttf-liberation fonts-liberation \
  && mkdir -p /root/.ssh \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/*
```

### Autres générateurs et toolchains

Le projet pourrait prendre de la plus-value à partir d'un contenu écrit en Markdown pour **Jekyll** ou plus simplement pour **MkDocs-Material** qui au passage d'une moulinette fabriquerait le modèle "gitbook" pour générer le différents artefacts.

## 5. Paramètres du pipeline

Le pipeline comporte trois stages : Test, Build, Deploy.

```yaml
# This pipeline run three stages Test, Build and Deploy
stages:
  - test
  - build
  - deploy
```

### Variables du pipeline

```yaml
# Open variables for S3
# AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY are protected variables
# added in the gitlab interface : Project | Settings | CI / CD | Variables
variables:
  AWS_DEFAULT_REGION: eu-west-3 # The region of our S3 bucket
  BUCKET_NAME: gitbook-gitlab.aws-fr.com  # gitbook-gitlab.aws-fr.com Your bucket name
  CDN_DISTRIBUTION_ID: E1956KV4Y1NHX7
```

## 6. Test

Ce stage "Test" a pour objectif de tester le stack et le code qui servira à l'étape suivante "Build". Il comporte deux jobs parallèles "gitbook" et "lint".

Le job "gitbook" utilise l'image docker privée `registry.gitlab.com/goffinet/gitbook-gitlab:latest` qui comprend tous les outils qui seront utilisés pour la fabrication des documents. Il teste la présence de nodejs et de gitbook-cli.

```yaml
# the 'gitbook' job will test the gitbook tools
gitbook:
  stage: test
  image: registry.gitlab.com/goffinet/gitbook-gitlab:latest
  script:
    - 'echo "node version: $(node -v)"'
    - gitbook -V
  allow_failure: false
```

Le job "Lint" teste nodejs, markdownlint-cli et teste la qualité des documents Markdown `README.md` et du sous-dossier `content` de manière non contraignante (`allow_failure: true`).

```yaml
# the 'lint' job will test the markdown syntax
lint:
  stage: test
  image: registry.gitlab.com/goffinet/gitbook-gitlab:latest
  script:
    - 'echo "node version: $(node -v)"'
    - echo "markdownlint version:" $(markdownlint -V)
    - markdownlint --config ./markdownlint.json README.md
    - markdownlint --config ./markdownlint.json ./content/*.md
  allow_failure: true
```

## 7. Build

On trouvera quatre tâches parallèles de construction dans le stage "Build". Dans cette proposition la prochaine étape "Deploy" s'enclenchera après la fin réussie de tous ces jobs de construction. Il est fort probable que la tâche de déploiement ne soit jamais enclenchée en cas d'erreur ou de délais dans une des tâches de construction.

```yaml
# the 'html' job will build your document in html format
html:
  stage: build
  dependencies:
    - gitbook
    - lint
  image: registry.gitlab.com/goffinet/gitbook-gitlab:latest
  script:
    - gitbook install # add any requested plugins in book.json
    - gitbook build . book # html build
  artifacts:
    paths:
      - book
    expire_in: 1 day
  only:
    - master # this job will affect only the 'master' branch the 'html' job will build your document in pdf format
  allow_failure: false

# the 'pdf' job will build your document in pdf format
pdf:
  stage: build
  dependencies:
    - gitbook
    - lint
  image: registry.gitlab.com/goffinet/gitbook-gitlab:latest
  before_script:
    - mkdir ebooks
  script:
    - gitbook install # add any requested plugins in book.json
    - gitbook pdf . ebooks/${CI_PROJECT_NAME}.pdf # pdf build
  artifacts:
    paths:
      - ebooks/${CI_PROJECT_NAME}.pdf
    expire_in: 1 day
  only:
    - master # this job will affect only the 'master' branch the 'pdf' job will build your document in pdf format

# the 'epub' job will build your document in epub format
epub:
  stage: build
  dependencies:
    - gitbook
    - lint
  image: registry.gitlab.com/goffinet/gitbook-gitlab:latest
  before_script:
    - mkdir ebooks
  script:
    - gitbook install # add any requested plugins in book.json
    - gitbook epub . ebooks/${CI_PROJECT_NAME}.epub # epub build
  artifacts:
    paths:
      - ebooks/${CI_PROJECT_NAME}.epub
    expire_in: 1 day
  only:
    - master # this job will affect only the 'master' branch

# the 'mobi' job will build your document in mobi format
mobi:
  stage: build
  dependencies:
    - gitbook
    - lint
  image: registry.gitlab.com/goffinet/gitbook-gitlab:latest
  before_script:
    - mkdir ebooks
  script:
    - gitbook install # add any requested plugins in book.json
    - gitbook mobi . ebooks/${CI_PROJECT_NAME}.mobi # mobi build
  artifacts:
    paths:
      - ebooks/${CI_PROJECT_NAME}.mobi
    expire_in: 1 day
  only:
    - master # this job will affect only the 'master' branch

```

## 8. Deploy

La phase "Deploy" utilise une autre image

```yaml
deploys3:
  image: "python:latest"  # We use python because there is a well-working AWS Sdk
  stage: deploy
  dependencies:
    - html
    - pdf
    - mobi
    - epub # We want to specify dependencies in an explicit way, to avoid confusion if there are different build jobs
  before_script:
    - pip install awscli # Install the SDK
  script:
    - aws s3 sync book s3://${BUCKET_NAME} --acl public-read --delete
    - aws s3 sync ebooks s3://${BUCKET_NAME}/ebooks --acl public-read --delete
    - aws cloudfront create-invalidation --distribution-id ${CDN_DISTRIBUTION_ID} --paths "/*" # The next time a viewer requests the file, CloudFront returns to the origin to fetch the latest version of the file.
  environment:
    name: production

```

## 9. Noeud d'exécution Docker

On remarquera qu'une implémentation DevOps en intégration continue demande des ressources locales ou dans le nuage.

Si ces instances d'exécution sont situées dans le nuage elle sont soit partagées (offertes dans les limites d'une offre payante ou gratuite), soit dédiée mais surtout à la charge du client.

Gitlab-ci offre des noeuds d'exécution partagé gratuit et offre la possibilité d'intégrer facilement des noeuds externes à un serveur Gitlab.

La mise à disposition des noeuds d'exécution Docker doit être intégrée à la partie Ops sous forme IaC (Infrastructure as Code) Cloudformation, Ansible ou Terraform.

## 10. Améliorations à proposer

* Choix du service SCM.
* Choix et emplacement du serveur d'intégration.
* Choix et emplacement des noeuds d'éxécution.
* Choix du registry Docker
* Fabrication automatique des images "container" sur un registry (docker hub, gitlab hub ou encore AWS).
* Fabrication d'une seule image intégrée (gitbook et aws-cli) en couches ou unique.
* Mieux intégrer npm et calibre, voire pandoc dans le stage "build".
* Découpler la phase "deploy" et ses dépendances pour chaque build.
* Ajouter un stage post-test sur les artefacts.
* Convertir en livre de jeu Ansible.
* Partir d'un contenu jekyll en sortie HTML et markdown sans frontmatter pour traitement ultérieur en PDF, MOBI, EPUB, Kindle.
