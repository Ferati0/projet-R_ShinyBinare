# Convertisseur de bases et encodeur bibi-binaire en R

## Description

Ce projet consiste en la réalisation d’un convertisseur de systèmes de numération en langage R avec une interface web interactive développée à l’aide du framework Shiny.  
L’application permet de convertir un entier écrit dans une base comprise entre 2 et 36 vers :

  - une autre base comprise entre 2 et 36  
  - le système bibi-binaire, basé sur une représentation syllabique des chiffres hexadécimaux  

Ce projet vise à mettre en œuvre des algorithmes classiques de conversion de bases, à structurer un code modulaire et à concevoir une interface réactive pour la visualisation des résultats.

---

## Fonctionnalités

  - Conversion d’un nombre depuis une base quelconque (2 à 36) vers sa valeur décimale  
  - Conversion d’un entier décimal vers une base cible (2 à 36)  
  - Encodage d’un entier dans le système bibi-binaire  
  - Validation des entrées alphanumériques (chiffres 0–9 et lettres A–Z)  
  - Interface graphique interactive avec mise à jour dynamique des résultats  
  - Organisation modulaire des fonctions de conversion  

---

## Installation

Installer le package nécessaire :

  install.packages("shiny")

---

## Utilisation

### Lancer l’application

  app <- source("app-base-converter.R")  
  app$value  

L’application s’ouvre alors dans un navigateur web.

---

### Exemple d’utilisation des fonctions

# Décoder un nombre écrit en base 2  
  DecodeNumber("1010", 2)  

# Encoder un entier en base 16  
  EncodeNumber(60, 16)  

# Encoder un entier en bibi-binaire  
  EncodeBibi(2018)  

---

## Algorithmes utilisés

  - Méthode de Horner pour le décodage des nombres en base quelconque  
  - Divisions euclidiennes successives pour l’encodage dans une base cible  
  - Regroupement du binaire par blocs de 4 bits pour la représentation bibi-binaire  
  - Programmation réactive avec le modèle serveur de Shiny  

---

## Objectifs pédagogiques

  - Comprendre les systèmes de numération et les conversions de bases  
  - Concevoir et implémenter des algorithmes mathématiques en R  
  - Structurer un programme scientifique de manière modulaire  
  - Développer une application interactive simple  
