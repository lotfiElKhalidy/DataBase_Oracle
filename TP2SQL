-- 1-Donner le code des pays pour lesquels nous avons une information sur les langues.

SELECT Code 
FROM Country C,Language L 
WHERE Country=Code 
AND L.name IS NOT NULL;

-- 2-Donner le nom des pays dont le nom se termine par un a.

SELECT Name 
FROM Country 
WHERE Name LIKE '%a';

-- 3-Donner le nom des pays pour lesquels nous avons une information sur les langues.
-- Trier-les par ordre alphabétique

SELECT DISTINCT C.Name
FROM Country C,Language L 
WHERE Country=Code 
AND L.name IS NOT NULL
ORDER BY C.Name;

-- 4-Donner le nombre de pays en Europe

SELECT COUNT(DISTINCT Name)
FROM Country C,encompasses E
WHERE Code=Country
AND Continent='Europe';

-- 5-Donner le code et le nom du pays avec le plus d'habitants.

SELECT Name,Code 
FROM Country 
WHERE Population=(SELECT MAX(population) FROM Country);

-- 6-Donner le code des pays pour lesquels nous n'avons pas d'information sur les langues.
*
SELECT Code 
FROM Country C,Language L 
WHERE Country=Code 
AND L.Name IS NULL;

-- 7-Donner le code des pays dont la population est inférieure à 15000000
-- ou occupant une partie du contient Australia/Oceania.

SELECT Code 
FROM Country 
WHERE Population<15000000
UNION 
SELECT Code 
FROM Country C,encompasses E
WHERE E.Country=C.Code
AND Continent='Australia/Oceania';

-- 8-Donner le code des pays dont la population est inférieure à 15000000
-- et occupant une partie du contient Australia/Oceania.

SELECT Code 
FROM Country 
WHERE Population<15000000
INTERSECT
SELECT Code 
FROM Country C,encompasses E
WHERE E.Country=C.Code
AND Continent='Australia/Oceania';

-- 9-Donner le code et le nom des différents pays et le pourcentage qu'ils occupent dans chaque continent.

SELECT Country,Name,Continent,Percentage
FROM Country,encompasses
WHERE Code=Country
ORDER  BY Continent;

-- 10-Donner les continents occupés par le Kazakhstan.

SELECT Continent
FROM encompasses E,Country C 
WHERE Country=Code
AND Name='Kazakhstan';

-- 11-Donner le code des pays avec leurs continents.
-- Vous afficherez aussi l'aire de chaque continent.

SELECT Code,Co.nAME
FROM Country,encompasses 
WHERE Country=Code
AND 

-- 12-Donner le code et le nom des différents pays et les langues parlées avec leur pourcentage.

SELECT C.Name,Code,L.Name,Percentage 
FROM Country C, Language L 
WHERE Country=Code;

-- 13-Donner les langues parlées en Australia, de la moins parlée à la plus parlée.

SELECT L.Name 
FROM Language L, Country C
WHERE Code=Country 
AND C.Name='Australia'
ORDER BY Percentage;

-- 14-Donner le code et les continents occupés par la France et l'Indonesia.
-- Vous afficherez aussi l'aire de chaque continent.

*
SELECT Country, Continent
FROM Country C, encompasses E
WHERE Code=Country
AND Name='France' OR Name='Indonesia';

-- 15-Donner le code et la surface totale des différents pays ainsi que le pourcentage et la surface occupée dans chaque continent.
-- Vous afficherez aussi le pourcentage qu'occupe le pays dans chaque continent.
-- (ex : La Russie occupe ~29% du continent asiatique)
*
SELECT DISTINCT Name,Area
FROM Country 
UNION 
SELECT DISTINCT Continent,Percentage
FROM encompasses;
