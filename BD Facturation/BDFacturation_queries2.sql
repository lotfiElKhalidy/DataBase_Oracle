-- Vérifier bien le résultat obtenu.

-- 1-Donner les pays dans lesquels se trouvent des clients de catégorie 1 ou 2.
-- Trier-les par ordre alphabétique.
-- 11 lignes
--

SELECT DISTINCT PAYS
FROM CLIENTS
WHERE CATEGORIE = 1 OR CATEGORIE = 2 
ORDER BY PAYS;

SELECT DISTINCT PAYS
FROM CLIENTS
WHERE CATEGORIE IN (1,2)
ORDER BY PAYS;

" ATTRIBUT IN (valeur1,valeur2) "

-- 2-Donner la référence des produits qui ont été commandés en quantité 15 ou en quantité 20.
-- Trier-les par ordre décroissant.
-- 53 lignes
--

SELECT DISTINCT REF_PRODUIT 
FROM DETAILS_COMMANDES
WHERE QUANTITE IN (15,20)
ORDER BY REF_PRODUIT DESC;

" Fallait pas faire une jointure dumbass !!!! "

SELECT DISTINCT C.REF_PRODUIT 
FROM PRODUITS P JOIN DETAILS_COMMANDES C ON P.REF_PRODUIT = C.REF_PRODUIT
WHERE QUANTITE IN (15,20)
ORDER BY C.REF_PRODUIT DESC;

SELECT DISTINCT C.REF_PRODUIT 
FROM PRODUITS P, DETAILS_COMMANDES C
WHERE P.REF_PRODUIT = C.REF_PRODUIT
AND QUANTITE IN (15,20)
ORDER BY C.REF_PRODUIT DESC;

"JOINTURE : SELECT .. "
            "FROM ATTR1, ATTR2 "
            "WHERE ATTR1.X = ATTR2.Y "

-- 3-Donner la référence des produits qui ont été commandés en quantité 15 et en quantité 20.
-- Donner 2 écritures.
-- 21 lignes
--

SELECT DISTINCT REF_PRODUIT 
FROM DETAILS_COMMANDES
WHERE QUANTITE = 15
INTERSECT
SELECT DISTINCT REF_PRODUIT 
FROM DETAILS_COMMANDES
WHERE QUANTITE = 20;

SELECT DISTINCT REF_PRODUIT 
FROM DETAILS_COMMANDES
WHERE QUANTITE = 15
AND REF_PRODUIT IN (SELECT DISTINCT REF_PRODUIT 
                    FROM DETAILS_COMMANDES
                    WHERE QUANTITE = 20);

" Fallait pas faire une jointure dumbass !!!! "
                    
SELECT DISTINCT P.REF_PRODUIT 
FROM PRODUITS P JOIN DETAILS_COMMANDES C ON P.REF_PRODUIT = C.REF_PRODUIT
WHERE QUANTITE = 15
INTERSECT 
SELECT DISTINCT P.REF_PRODUIT 
FROM PRODUITS P JOIN DETAILS_COMMANDES C ON P.REF_PRODUIT = C.REF_PRODUIT
WHERE QUANTITE = 20;

"SELECT P.REF et SELECT C.REF donnent le meme résultat"

SELECT DISTINCT C.REF_PRODUIT 
FROM PRODUITS P JOIN DETAILS_COMMANDES C ON P.REF_PRODUIT = C.REF_PRODUIT
WHERE QUANTITE = 15 
AND C.REF_PRODUIT IN (SELECT DISTINCT C.REF_PRODUIT 
                        FROM PRODUITS P JOIN DETAILS_COMMANDES C ON P.REF_PRODUIT = C.REF_PRODUIT
                        WHERE QUANTITE = 20);
                        
"INTERSECT -> IN (SELECT ...)"

-- 4-Donner le code des clients espagnols qui n'ont pas commandé.
-- Donner 2 écritures.
-- 1 ligne : FISSA
--

SELECT CODE_CLIENT 
FROM CLIENTS
WHERE PAYS LIKE 'Espagne'
MINUS
SELECT C.CODE_CLIENT
FROM CLIENTS C JOIN COMMANDES CO ON C.CODE_CLIENT = CO.CODE_CLIENT
WHERE PAYS LIKE 'Espagne';

SELECT CODE_CLIENT 
FROM CLIENTS
WHERE PAYS LIKE 'Espagne'
AND CODE_CLIENT NOT IN (SELECT C.CODE_CLIENT
                    FROM CLIENTS C JOIN COMMANDES CO ON C.CODE_CLIENT = CO.CODE_CLIENT
                    WHERE PAYS LIKE 'Espagne');

"MINUS -> NOT IN (SELECT ..)"
                    
-- 5-Donner le numéro des commandes de aout 2008 des clients
-- habitant au Royaume-Uni ou à Toulouse.
-- Afficher le jour de la commande.
-- 3 lignes
--
 
SELECT NO_COMMANDE, TO_CHAR(DATE_COMMANDE, 'DD')
FROM CLIENTS C JOIN COMMANDES CO ON C.CODE_CLIENT = CO.CODE_CLIENT
WHERE (PAYS = 'Royaume-Uni' OR VILLE = 'Toulouse')
AND TO_CHAR(DATE_COMMANDE, 'YYYY-MM-DD') LIKE '2008-08%';

-- 6-Donner le code et le pays des clients ayant commandé le produit n°31.
-- Afficher le pays sous cette forme : Aut. (3 premières lettres + point).
-- 14 lignes
--

SELECT DISTINCT C.CODE_CLIENT "Client", SUBSTR(PAYS,1,3)||'.' "Pays"
FROM CLIENTS C JOIN (COMMANDES CO JOIN DETAILS_COMMANDES DCO ON CO.NO_COMMANDE = DCO.NO_COMMANDE)
ON C.CODE_CLIENT = CO.CODE_CLIENT 
WHERE REF_PRODUIT = 31;

" 'char1'||'char2' -> CONCAT( char1, char2) "

-- 7-Donner le code et la société des clients de catégorie 1 avec le numéro de leurs commandes
-- (on veut afficher tous les clients même ceux qui n'ont pas encore de commande).
-- Trier les lignes par numéro de commande.
-- 97 lignes
--

SELECT C.CODE_CLIENT, SOCIETE, NO_COMMANDE
FROM CLIENTS C LEFT JOIN COMMANDES CO ON C.CODE_CLIENT = CO.CODE_CLIENT
WHERE CATEGORIE=1
ORDER BY NO_COMMANDE;

-- 8-Requête 4 avec une jointure externe (anti-jointure).
-- 1 ligne : FISSA
--

SELECT C.CODE_CLIENT
FROM CLIENTS C LEFT JOIN COMMANDES CO ON C.CODE_CLIENT = CO.CODE_CLIENT
WHERE PAYS LIKE 'Espagne'
GROUP BY C.CODE_CLIENT
HAVING COUNT(NO_COMMANDE) = 0;

"MINUS SELECT CODE_CLIENT FROM COMMANDES; "

-- 9-Requête 4 avec un NOT EXISTS.
-- 1 ligne : FISSA
--

SELECT CODE_CLIENT 
FROM CLIENTS C
WHERE PAYS = 'Espagne'
AND NOT EXISTS (SELECT CODE_CLIENT
                FROM COMMANDES CO
                WHERE C.CODE_CLIENT = CO.CODE_CLIENT);

-- 10-Donner la référence des produits dont le nom contient 'Sauce'
-- ou qui ont été commandé avec une quantité comprise entre 50 et 60.
-- 3 lignes
--

SELECT REF_PRODUIT
FROM PRODUITS
WHERE NOM_PRODUIT LIKE '%Sauce%'
UNION
SELECT REF_PRODUIT
FROM DETAILS_COMMANDES
WHERE QUANTITE > 50 AND quantite < 60;

" Don't do a JOIN when it's not needed "

-- 11-Donner les produits commandés en même quantité dans une même commande
-- (uniquement si la quantité est supérieure à 45).
-- 4 lignes
--

SELECT DCO1.REF_PRODUIT 
FROM DETAILS_COMMANDES DCO1 JOIN DETAILS_COMMANDES DCO2 ON DCO1.NO_COMMANDE = DCO2.NO_COMMANDE
WHERE DCO1.QUANTITE = DCO2.QUANTITE
AND DCO1.REF_PRODUIT > DCO2.REF_PRODUIT " pour 2 produits différents ; > pour supprimer les doublons "
AND DCO1.QUANTITE > 45;

-- 12-Donner pour chaque produit, les produits qui coutent 10€ de plus.
-- Afficher les références et les prix des produits
-- Trier par produit.
-- 30 lignes
--

SELECT P1.REF_PRODUIT, P1.PRIX_UNITAIRE, P2.REF_PRODUIT, P2.PRIX_UNITAIRE
FROM PRODUITS P1 JOIN PRODUITS P2 ON P1.PRIX_UNITAIRE = P2.PRIX_UNITAIRE + 10
ORDER BY P2.REF_PRODUIT;

-- 13-Donner le nombre de clients qui ont commandé le produit n° 31.
-- 1 ligne : 14
--

SELECT COUNT(DISTINCT C.CODE_CLIENT)
FROM CLIENTS C JOIN (COMMANDES CO JOIN DETAILS_COMMANDES DCO ON CO.NO_COMMANDE = DCO.NO_COMMANDE)
ON C.CODE_CLIENT = CO.CODE_CLIENT 
WHERE REF_PRODUIT = 31;

-- 14-Donner la référence et le nom du ou des produits les plus chers.
-- 1 ligne : 9
--

SELECT REF_PRODUIT, NOM_PRODUIT
FROM PRODUITS
WHERE PRIX_UNITAIRE = (SELECT MAX(PRIX_UNITAIRE)
                        FROM PRODUITS); 

-- 15-Donner le nombre de clients de catégorie 0 ou 1 par pays (sauf la France).
-- Trier par nombre décroissant.
-- 9 lignes
--

SELECT DISTINCT PAYS, COUNT(CODE_CLIENT)
FROM CLIENTS
WHERE CATEGORIE IN (0,1)
AND CODE_CLIENT NOT IN (SELECT CODE_CLIENT FROM CLIENTS 
                        WHERE PAYS = 'France')
GROUP BY PAYS
ORDER BY PAYS DESC;

" Version + ou - simple "

SELECT DISTINCT PAYS, COUNT(CODE_CLIENT)
FROM CLIENTS
WHERE CATEGORIE IN (0,1)
AND PAYS != 'France'
GROUP BY PAYS
ORDER BY PAYS DESC;

-- 16-Donner le nombre de clients par pays et par catégorie.
-- Trier par pays, catégorie.
-- 24 lignes
--

SELECT DISTINCT PAYS, CATEGORIE, COUNT(CODE_CLIENT)
FROM CLIENTS
GROUP BY PAYS, CATEGORIE
ORDER BY PAYS, CATEGORIE;

-- 17-Donner les pays ayant des sociétés d'au moins 2 catégories différentes.
-- 6 lignes
--

SELECT DISTINCT PAYS
FROM CLIENTS
GROUP BY PAYS
HAVING COUNT(DISTINCT CATEGORIE) >= 2
ORDER BY PAYS;

-- 18-Donner le nombre de produits total par commande (uniquement si au moins 4 références différentes).
-- 22 lignes
--

SELECT NO_COMMANDE, SUM(QUANTITE)
FROM DETAILS_COMMANDES
GROUP BY NO_COMMANDE
HAVING COUNT(DISTINCT REF_PRODUIT) >= 4;

-- 19-Donner la référence des commandes dont le montant est supérieur à 20000
-- (afficher le montant total de la facture).
-- Vérifier le résultat pour une facture.
-- 9 lignes
--

SELECT NO_COMMANDE
FROM PRODUITS PR JOIN DETAILS_COMMANDES DCO ON PR.REF_PRODUIT = DCO.REF_PRODUIT
GROUP BY NO_COMMANDE
HAVING SUM(QUANTITE*PRIX_UNITAIRE) > 20000;

-- 20-Donner le numéro et la date des commandes avec au moins 4 références différentes.
-- 22 lignes
--

SELECT CO.NO_COMMANDE, DATE_COMMANDE
FROM DETAILS_COMMANDES DCO JOIN (CLIENTS C JOIN COMMANDES CO ON C.CODE_CLIENT = CO.CODE_CLIENT)
ON DCO.NO_COMMANDE = CO.NO_COMMANDE
GROUP BY CO.NO_COMMANDE, DATE_COMMANDE
HAVING COUNT(DISTINCT REF_PRODUIT) >= 4; 

-- 21-Donner le numéro des commandes contenant tous les produits qui coutent 105€.
-- 1 ligne : 10698
--

SELECT CO.NO_COMMANDE
FROM PRODUITS PR JOIN (DETAILS_COMMANDES DCO JOIN COMMANDES CO ON CO.NO_COMMANDE = DCO.NO_COMMANDE)
ON DCO.REF_PRODUIT = PR.REF_PRODUIT
WHERE PRIX_UNITAIRE = 105
GROUP BY CO.NO_COMMANDE
HAVING COUNT(PR.REF_PRODUIT) = (SELECT COUNT(*)
                                FROM PRODUITS
                                WHERE PRIX_UNITAIRE = 105);

-- 22-Donner la référence des produits qui sont dans toutes les commandes de ERNSH.

-- aucune ligne
--

SELECT PR.REF_PRODUIT
FROM PRODUITS PR JOIN (DETAILS_COMMANDES DCO JOIN COMMANDES CO ON CO.NO_COMMANDE = DCO.NO_COMMANDE)
ON DCO.REF_PRODUIT = PR.REF_PRODUIT
WHERE CODE_CLIENT = 'ERNSH'
GROUP BY PR.REF_PRODUIT
HAVING COUNT(CO.NO_COMMANDE) = (SELECT COUNT(*)
                                FROM COMMANDES
                                WHERE CODE_CLIENT = 'ERNSH');
                                
-- 23-Donner la référence du produit qui a été le plus commandé.
-- 1 ligne : 31

SELECT REF_PRODUIT, COUNT(NO_COMMANDE)
FROM DETAILS_COMMANDES
GROUP BY REF_PRODUIT
HAVING COUNT(NO_COMMANDE) = (SELECT MAX(COUNT(NO_COMMANDE))
                             FROM DETAILS_COMMANDES
                             GROUP BY REF_PRODUIT);

-- 24-Donner le numéro des commandes de 2010 (avec le code des clients) contenant tous les produits les plus chers.
-- 1 ligne : 10848

SELECT CO.NO_COMMANDE
FROM PRODUITS PR JOIN (COMMANDES CO JOIN DETAILS_COMMANDES DCO ON CO.NO_COMMANDE = DCO.NO_COMMANDE)
ON PR.REF_PRODUIT = DCO.REF_PRODUIT
WHERE TO_CHAR(DATE_COMMANDE, 'YYYY') = '2010'
AND PRIX_UNITAIRE = (SELECT MAX(PRIX_UNITAIRE)
                        FROM PRODUITS
                        WHERE REF_PRODUIT IN (SELECT REF_PRODUIT
                                              FROM DETAILS_COMMANDES));
