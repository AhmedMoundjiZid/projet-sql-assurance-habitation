-- Projet : analyse du marché de l'assurance habitation (SQLite)
-- Auteur : Zid Ahmed Moundji
-- Les 12 requêtes d'analyse. Résultats attendus indiqués en commentaire.

PRAGMA foreign_keys = ON;

-- 1. Contrats du code postal 92100 (98 lignes : ID et surface)
SELECT Contrat_ID, Surface
FROM Contrat
WHERE Code_postal = '92100';

-- 2. Régions du référentiel (19 régions)
SELECT DISTINCT reg_nom
FROM Region;

-- 3. Nombre de contrats « Residence principale » (25 620)
SELECT COUNT(*)
FROM Contrat
WHERE Type_contrat = 'Residence principale';

-- 4. Les 5 contrats avec la plus grande surface (104211 : 815 m², ...)
SELECT Contrat_ID, Surface
FROM Contrat
ORDER BY Surface DESC
LIMIT 5;

-- 5. Cotisation mensuelle moyenne (19,33 €)
SELECT AVG(Prix_cotisation_mensuel) AS Prix_moyen
FROM Contrat;

-- 6. Nombre de contrats par tranche de valeur déclarée
--    (0-25000 : 22 720 ; 25000-50000 : 6 815 ; 50000-100000 : 696 ; 100000+ : 104)
SELECT Valeur_declaree_biens, COUNT(*)
FROM Contrat
GROUP BY Valeur_declaree_biens;

-- 7. Contrats en formule Integral en Pays de la Loire (589)
SELECT COUNT(*)
FROM Contrat c
INNER JOIN Region r
ON c.Code_dep_code_commune = r.Code_dep_code_commune
WHERE r.reg_nom = 'Pays de la Loire'
AND c.Formule = 'Integral';

-- 8. Maisons du département 71 (4 contrats)
SELECT Contrat_ID, Type_contrat, Formule
FROM Contrat c
INNER JOIN Region r
ON c.Code_dep_code_commune = r.Code_dep_code_commune
WHERE c.Type_local = 'Maison'
AND r.dep_code = '71';

-- 9. Nombre de contrats et surface moyenne à Paris (4 821 contrats, 51,77 m²)
SELECT COUNT(*), AVG(Surface)
FROM Contrat c
INNER JOIN Region r
ON c.Code_dep_code_commune = r.Code_dep_code_commune
WHERE r.aca_nom = 'Paris' OR r.dep_code = '75';

-- 10. Top 10 des départements par cotisation moyenne (Paris : 36,40 €)
SELECT r.dep_nom_num, AVG(c.Prix_cotisation_mensuel) AS Prix_moyen
FROM Contrat c
INNER JOIN Region r
ON c.Code_dep_code_commune = r.Code_dep_code_commune
GROUP BY r.dep_nom_num
ORDER BY Prix_moyen DESC
LIMIT 10;

-- 11. Communes avec au moins 150 contrats (20 communes)
SELECT COUNT(Type_contrat), r.com_nom_maj_court
FROM Contrat c
INNER JOIN Region r
ON c.Code_dep_code_commune = r.Code_dep_code_commune
GROUP BY r.com_nom_maj_court
HAVING COUNT(Type_contrat) >= 150;

-- 12. Nombre de contrats par région (16 régions, Île-de-France : 14 177)
SELECT COUNT(Type_contrat), r.reg_nom
FROM Contrat c
INNER JOIN Region r
ON c.Code_dep_code_commune = r.Code_dep_code_commune
GROUP BY r.reg_nom;
