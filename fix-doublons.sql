-- ÉTAPE 1 : Voir combien de doublons existent
-- (même lat/lng arrondis à 5 décimales = ~1m de précision)
SELECT
  ROUND(latitude::numeric, 5) AS lat,
  ROUND(longitude::numeric, 5) AS lng,
  COUNT(*) AS nb
FROM places
GROUP BY ROUND(latitude::numeric, 5), ROUND(longitude::numeric, 5)
HAVING COUNT(*) > 1
ORDER BY nb DESC
LIMIT 50;

-- ÉTAPE 2 : Supprimer les doublons (garde le plus ancien = id le plus petit)
-- ATTENTION : faire d'abord une sauvegarde ou tester avec SELECT
DELETE FROM places
WHERE id IN (
  SELECT id FROM (
    SELECT id,
      ROW_NUMBER() OVER (
        PARTITION BY ROUND(latitude::numeric, 5), ROUND(longitude::numeric, 5)
        ORDER BY id ASC
      ) AS rn
    FROM places
  ) sub
  WHERE rn > 1
);

-- ÉTAPE 3 : Vérifier le résultat
SELECT COUNT(*) AS total_apres_nettoyage FROM places;
