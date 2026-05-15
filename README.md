# ANY — Anything, Anywhere, Anytime

## Concept
Carte communautaire interactive des services en libre-service 24h/24.
Trouvez un lieu utile autour de vous, peu importe où vous êtes et quand — vanlifer, vacancier, citadin ou nomade.

## Stack technique
- **Frontend** : HTML/CSS/JS vanilla (fichier unique index.html)
- **Carte** : Leaflet.js + OpenStreetMap + Esri satellite
- **Base de données** : Supabase (PostgreSQL)
- **Auth** : Supabase Auth
- **Hébergement** : GitHub Pages

## Credentials Supabase
- URL : https://xssfehwbmvrxtxmocowc.supabase.co
- Clé publique : sb_publishable_lB89hOOAXUCIheGRbS2wEQ_L7uVajNV
- Projet ID : xssfehwbmvrxtxmocowc

## URL
- App : https://my-projet-app.github.io/ANY/
- Import : https://my-projet-app.github.io/ANY/import.html
- Admin : https://my-projet-app.github.io/ANY/admin.html

## Structure base de données

### Tables
- `main_categories` : grandes catégories (sort_order, name, icon, color)
- `categories` : sous-catégories (main_category_id, name, icon, color)
- `places` : lieux (name, description, latitude, longitude, category_id, user_id, user_name, disponible_24h, votes_positifs, votes_negatifs, status)
- `votes` : (place_id, user_id, vote boolean) UNIQUE(place_id, user_id)
- `comments` : (place_id, user_id, user_name, content)
- `profiles` : (user_id UNIQUE, username, avatar_url, registered_at)
- `trusted_users` : (user_id, role) — admin / moderator / trusted
- `reports` : signalements de lieux
- `report_history` : historique des actions de modération
- `place_photos` : photos des lieux
- `notifications` : notifications in-app
- `comment_reports` : signalements de commentaires

## Système XP
- Lieu ajouté : +10 XP
- Confirmation donnée : +3 XP
- Commentaire : +2 XP
- Vote : +1 XP
- Merci reçu : +5 XP

Niveaux : 🌱 Curieux → 🗺️ Explorateur → 📍 Contributeur → ⭐ Guide → 🏆 Ambassadeur

## Fonctionnalités
- Carte interactive avec clusters de marqueurs
- Vue satellite hybride (membres connectés)
- Filtres par catégorie + recherche textuelle + périmètre
- Ajout de lieux avec photo obligatoire
- Votes, commentaires, favoris
- Profil utilisateur avec progression XP
- Modération avancée (dashboard mods/admins)
- Notifications push (Web Push API)
- PWA installable (iOS + Android)
- 7 langues (fr, en, es, de, it, pt, nl)

## Fichiers
- `index.html` : application principale complète (~6500 lignes)
- `admin.html` : panneau d'administration
- `sw.js` : service worker (cache + notifications push)
- `manifest.json` : PWA manifest
- `import.html` : outil import OpenStreetMap
- `import-pizza.html` : outil géocodage adresses manuelles
