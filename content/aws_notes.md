# Notes

<!-- toc -->

## AWS CloudFormation

AWS CloudFormation fournit un langage commun pour décrire et provisionner toutes les ressources d'infrastructure dans votre environnement cloud. CloudFormation vous permet d'utiliser un simple fichier texte (JSON ou YAML) pour modéliser et approvisionner de manière automatisée et sécurisée toutes les ressources nécessaires pour des applications à travers toutes les régions et tous les comptes. Ce fichier sert de source unique de vérité pour un environnement cloud.

### Fonctionnement AWS CloudFormation

![Fonctionnement AWS CloudFormation](https://d1.awsstatic.com/CloudFormation%20Assets/howitworks.c316d3856638c6c9786e49011bad660d57687259.png)

### Notes

[https://console.aws.amazon.com/cloudformation/designer](https://console.aws.amazon.com/cloudformation/designer)

[https://templates.cloudonaut.io/en/stable/](https://templates.cloudonaut.io/en/stable/)

[https://github.com/widdix/learn-cloudformation/](https://github.com/widdix/learn-cloudformation/)

[https://medium.com/boltops/a-simple-introduction-to-aws-cloudformation-part-1-1694a41ae59d](https://medium.com/boltops/a-simple-introduction-to-aws-cloudformation-part-1-1694a41ae59d)

[https://github.com/tongueroo/cloudformation-examples/blob/master/templates/single-instance.yml](https://github.com/tongueroo/cloudformation-examples/blob/master/templates/single-instance.yml)

## Template Cloudformation de création d'un site web statique

* [Cloudformation template for creating static website](https://github.com/sjevs/cloudformation-s3-static-website-with-cloudfront-and-route-53)

![Cloudformation template for creating static website](/images/WebsiteBucket-designer.png)

## Certification AWS

### Avis

* Programme / prix / conditions / type
* Contenu
* Practice
* Examen

## Json

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

Un objet est "embarqué" entre les accolades (_curly braces_). Un tableau (_array_) d'objets est embarqué dans des crochets (_square brackets_). Les données sont représentées dans des paires nom/valeur séparées par des virgules.

Deux types de structures d'objet sont reconnues en JSON :

* Une collection de paires nom/valeur
* Des listes ordonnées de valeurs : tableau, liste, vecteurs, séquences, etc.

Ici un tableau "book" qui comprend deux objets avec quatre lignes.

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
