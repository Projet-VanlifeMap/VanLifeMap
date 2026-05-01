# MapLibre — Carte Communautaire

## Concept
Carte communautaire interactive pour vacanciers et touristes en France.
Les utilisateurs trouvent et partagent des services en libre-service 24h/24.

## Stack technique
- **Frontend** : HTML/CSS/JS vanilla (fichier unique index.html)
- **Carte** : Leaflet.js + OpenStreetMap + Esri satellite
- **Base de données** : Supabase (PostgreSQL)
- **Auth** : Supabase Auth
- **Hébergement** : Netlify

## Credentials Supabase
- URL : https://xssfehwbmvrxtxmocowc.supabase.co
- Clé publique : sb_publishable_lB89hOOAXUCIheGRbS2wEQ_L7uVajNV
- Projet ID : xssfehwbmvrxtxmocowc

## URL Netlify
- App : https://zesty-dango-9f2db0.netlify.app
- Import : https://zesty-dango-9f2db0.netlify.app/import.html

## Structure base de données

### Tables
- `main_categories` : 3 grandes catégories (sort_order, name, icon, color)
- `categories` : ~50 sous-catégories (main_category_id, name, icon, color)
- `places` : lieux (name, description, latitude, longitude, main_category_id, category_id, user_id, user_name, disponible_24h, votes_positifs, votes_negatifs, approved)
- `votes` : (place_id, user_id, vote boolean) UNIQUE(place_id, user_id)
- `comments` : (place_id, user_id, user_name, content)
- `profiles` : (user_id UNIQUE, preferences TEXT/JSON)

### Grandes catégories (sort_order)
1. Distributeurs & Casiers (🤖)
2. Spots Van & Camping (🚐)
3. Autre (📍)

### Sous-catégories Distributeurs
- Distributeur de pain & viennoiseries 🥖
- Distributeur de café / boissons chaudes ☕
- Distributeur de boissons froides / snacks 🥤
- Distributeur de pizzas 🍕
- Distributeur de glaçons 🧊
- Lavomatique automatique 🫧
- Borne de recharge électrique (voiture) 🔋
- Borne de recharge VAE / trottinette 🛴
- Casier fermier 🐔
- Distributeur d'huîtres 🦪
- Distributeur de fruits de mer 🐟
- Distributeur de fleurs 💐
- Photomaton 📸
- Distributeur de croquettes animaux 🐾
- Distributeur de livres 📚
- Distributeur de CBD 🌿
- Autre distributeur 📍

### Sous-catégories Spots Van & Camping
- Aire de camping-car officielle 🅿️
- Spot sauvage van / tente 🏕️
- Aire de vidange camping-car 🚿
- Borne eau potable 💧
- Douche publique 🚿
- Toilettes publiques 🚻
- Aire de pique-nique 🧺

### Sous-catégories Autre
- (vide, à remplir par la communauté)

## Fonctionnalités

### Carte
- OpenStreetMap via Leaflet.js
- Vue satellite hybride Esri (membres connectés uniquement)
- Préférence satellite sauvegardée en DB et restaurée à la reconnexion
- Clusters de marqueurs automatiques
- Géolocalisation

### Filtres & Recherche
- Cases à cocher par catégorie (clic sur texte OU sur case)
- Tout décoché par défaut
- Recherche textuelle
- Recherche par périmètre : 1/2/5/10/25/50/100km ou Toute la France
- Centre : position GPS ou clic sur carte
- Chargement géographique (zone visible uniquement, limit 2000)

### Compteur (coin haut droite)
- Mode normal : nombre de lieux affichés
- Mode périmètre : "83 / 5km"
- Mode France : "247 / France"
- 0 si rien de coché

### Utilisateurs
- Inscription/connexion email via Supabase Auth
- Ajout de lieux (clic sur carte)
- Votes 👍👎
- Commentaires
- Paramètres (toggle satellite)

### Mobile
- Barre navigation bas (iOS/Android style)
- Bottom sheets pour catégories, recherche, profil
- Responsive

## Fichiers
- `index.html` : application principale complète
- `import.html` : outil import OpenStreetMap (25 types)
- `import-pizza.html` : outil géocodage adresses manuelles

## Données importées
- ~47 000 toilettes publiques France (OpenStreetMap)
- Doublons possibles Nouvelle-Aquitaine (importée 2 fois)

## TODO / Prochaines fonctionnalités
- Photos pour chaque lieu
- Panel d'administration (modération)
- Notifications
- Nom de domaine personnalisé
- PWA (Progressive Web App)
- Signalement de lieux fermés/incorrects
