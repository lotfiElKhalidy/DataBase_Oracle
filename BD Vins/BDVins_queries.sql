-- Q1-Créer les tables de la base de données :

CREATE TABLE VIN(
  VNUM NUMBER(2,0) CONSTRAINT PK_VIN PRIMARY KEY,
  VNOM VARCHAR2(30) CONSTRAINT VNOM_NOTNULL NOT NULL,
  CEPAGE VARCHAR2(30));

CREATE TABLE INSPECTEUR(
  INUM NUMBER(2,0) CONSTRAINT PK_INSPECTEUR PRIMARY KEY,
  INOM VARCHAR2(30) CONSTRAINT INOM_NOTNULL NOT NULL);

CREATE TABLE TEST(
  VNUM NUMBER(2,0),
  INUM NUMBER(2,0),
  NOTE NUMBER(2,0) CONSTRAINT NOTE_NOTNULL NOT NULL,
  TDATE DATE,
  CONSTRAINT PK_TEST PRIMARY KEY(VNUM, INUM),
  CONSTRAINT FKVNUM_TEST FOREIGN KEY(VNUM) REFERENCES VIN(VNUM),
  CONSTRAINT FKINUM_TEST FOREIGN KEY(INUM) REFERENCES INSPECTEUR(INUM));

-- Q2-Ajouter une contrainte dans la table TEST pour indiquer que la note doit être comprise entre 0 et 10.

ALTER TABLE TEST
ADD CONSTRAINT INTERVALLE_NOTE CHECK(NOTE < 10 AND NOTE > 0);

-- Q3-En utilisant les tables USER_CONSTRAINTS et USER_CONS_COLUMNS du catalogue Oracle,
-- retrouver toutes les contraintes qui ont été définies sur la table TEST.

COLUMN CONSTRAINT_NAME FORMAT A20
DESC USER_CONSTRAINTS
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE 
FROM USER_CONSTRAINTS
WHERE TABLE_NAME='TEST';

"C = CHECK, P = PRIMARY KEY .."
"COLUMN : changer le format du nom de la contrainte sur la table USER_CONSTRAINTS"

COLUMN CONSTRAINT_NAME FORMAT A20
DESC USER_CONS_COLUMNS
SELECT CONSTRAINT_NAME, COLUMN_NAME
FROM USER_CONS_COLUMNS
WHERE TABLE_NAME='TEST';

-- Q4-Insérer les données des tables VIN et INSPECTEUR :

INSERT INTO VIN VALUES(1,'Cave de Macon','Chardonnay');
INSERT INTO VIN VALUES(2,'Merlot','Cabernet Sauvignon');
INSERT INTO VIN VALUES(3,'Pinot Noir','Pinot Noir');

INSERT INTO INSPECTEUR VALUES(1,'Magouille');
INSERT INTO INSPECTEUR VALUES(2,'Intransigeant');
INSERT INTO INSPECTEUR VALUES(3,'Sympa');
INSERT INTO INSPECTEUR VALUES(4,'Cool');

-- Q5-Insérer les données de la table TEST en utilisant la fonction TO_DATE (valider votre transaction à la fin).

INSERT INTO TEST VALUES(1,1,7,TO_DATE('10042009','DD/MM/YYYY'));
INSERT INTO TEST VALUES(2,1,8,TO_DATE('15052009','DD/MM/YYYY'));
INSERT INTO TEST VALUES(2,2,4,TO_DATE('20052009','DD/MM/YYYY'));
INSERT INTO TEST VALUES(2,3,9,NULL);
COMMIT;

-- Q6-Vérifier le contenu des tables.
-- (Pour la table TEST, utiliser TO_CHAR pour afficher la date correctement.)

SELECT VNUM, INUM, NOTE, TO_CHAR(TDATE,'DD/MM/YYYY')
FROM TEST;

-- Q7-Insérer le tuple (2, Rigolo) dans la table INSPECTEUR.
-- Que se passe-t-il ? Pourquoi ?

INSERT INTO INSPECTEUR VALUES(2,'Rigolo');

" VIOLATION DE LA CONTRAINTE PK_INSPECTEUR, INUM EST UNE CLÉ PRIMAIRE ET 2 EXISTE DÉJA DANS LA BASE "

-- Q8-Insérer le tuple (5, 2, 8, 01/01/2010) dans la table TEST.
-- Que se passe-t-il ? Pourquoi ?

INSERT INTO TEST VALUES(5,2,8,TO_DATE('01012010','DD/MM/YYYY'));

 " VIOLATION DE LA CONTRAINTE FKNUM_TEST, VNUM EST UNE CLÉ ÉTRANGÈRE DANS TEST ET FAIT RÉFÉRENCE A LA CLÉ PRIMAIRE DE LA TABLE VIN, OR 5 N'EXISTE PAS DANS LA TABLE VIN "
 
-- Q9-Insérer un nouvel inspecteur dans la table INSPECTEUR,
-- à savoir l’inspecteur de numéro 5 et dont on a égaré le nom.
-- Que se passe-t-il ? Pourquoi ?

INSERT INTO INSPECTEUR VALUES(5,NULL);

" IMPOSSIBLE D'INSÉRER NULL DANS INOM (CONSTRAINT NOT NULL) "

-- Q10-Supprimer le vin n°2. Que se passe-t-il ?  Pourquoi ?  

DELETE FROM VIN WHERE VNUM=2; 

" VIOLATION DE LA CONTRAINTE FKVNUM_TEST : LA LIGNE EXISTE DANS UNE AUTRE TABLE (REFERENCES) " 

-- Q11-Modifier les contraintes d’intégrité définies sur la table TEST pour
-- obtenir la suppression des tests d’un vin lorsque celui-ci est supprimé de la table VIN.
-- (Pour modifier une contrainte, il faut la supprimer puis la recréer).

ALTER TABLE TEST DROP CONSTRAINT FKVNUM_TEST;
ALTER TABLE TEST ADD CONSTRAINT FKVNUM_TEST FOREIGN KEY(VNUM) REFERENCES VIN(VNUM) ON DELETE CASCADE;

-- Q12-Supprimer à nouveau le vin n°2 et vérifier la suppression de ses tests.

DELETE FROM VIN WHERE VNUM=2; 

" 1 LIGNE SUPPRIMÉE -_- "

-- Q13-Réinsérer le vin 2 ainsi que ses tests dans les tables associées.

INSERT INTO VIN VALUES(2,'Merlot','Cabernet Sauvignon');

INSERT INTO TEST VALUES(2,1,8,TO_DATE('15052009','DD/MM/YYYY'));
INSERT INTO TEST VALUES(2,2,4,TO_DATE('20052009','DD/MM/YYYY'));
INSERT INTO TEST VALUES(2,3,9,NULL);

-- Q14-Faire les modifications de structure pour permettre l’insertion du numéro
-- de téléphone ’03-85-44-12-09’ pour l’inspecteur n°3.
-- Que se passe t-il pour les autres inspecteurs ?

ALTER TABLE INSPECTEUR 
ADD (ITEL VARCHAR(15) DEFAULT NULL);

UPDATE INSPECTEUR SET ITEL='03-85-44-12-09' WHERE INUM=3;

" ITEL PREND DES VALEURS NULL POUR LES AUTRES INSPECTEURS "

-- Q15-Faire les modifications de structure pour réduire la longueur de INOM à 6 caractères.
-- Prévoir la récupération des valeurs de cette colonne en les tronquant à 6 caractères.

UPDATE INSPECTEUR SET INOM=SUBSTR(INOM,1,6);
SELECT * FROM INSPECTEUR;
ALTER TABLE INSPECTEUR MODIFY INOM VARCHAR(6);

-- Q16-Créer la vue SYNTHESE09 regroupant les attributs CEPAGE, VNUM, VNOM, INOM, NOTE et TDATE pour tous les tests effectués en 2009.
-- Vérifier que la vue a bien été créée.
-- Afficher le contenu de cette vue.
-- Donner la note moyenne de chaque vin en 2009. On précisera le nom du vin.

CREATE VIEW SYNTHESE09 AS
SELECT CEPAGE, V.VNUM, VNOM, INOM, NOTE, TDATE
FROM VIN V JOIN (INSPECTEUR I JOIN TEST T ON I.INUM = T.INUM)
        ON V.VNUM = T.VNUM
WHERE TO_CHAR(TDATE,'YYYY') = '2009';

SELECT * FROM SYNTHESE09;

SELECT VNOM, AVG(NOTE) INSPECTEUR;
SELECT * FROM TEST;
FROM SYNTHESE09
GROUP BY VNOM;

DROP VIEW SYNTHESE09;

-- Q17-Afin d’optimiser les temps de réponse, indexer les cépages dans la table VIN.

CREATE UNIQUE INDEX Vindex ON VIN (CEPAGE);

DROP INDEX Vindex;

-- Q18-Afin d’optimiser les temps de réponse, indexer également les cépages dans la vue SYNTHESE09.
-- Que se passe t’il ? Pourquoi ?

CREATE UNIQUE INDEX Cind ON SYNTHESE09 (CEPAGE);

" Vous ne pouvez pas utiliser de vue ici !!! "
" On ne peut pas créer un index sur une vue (table virtuelle) "

-- Q19-Insérer les trois tuples (10, Relax), (11, Pointu) et (12, Odieux) dans la table INSPECTEUR.
-- Vérifier que tout s’est bien passé.
-- Annuler la dernière transaction et vérifier à nouveau le contenu de la table INSPECTEUR.

INSERT INTO INSPECTEUR VALUES(10,'Relax',NULL);
INSERT INTO INSPECTEUR VALUES(11,'Pointu',NULL);
INSERT INTO INSPECTEUR VALUES(12,'Odieux',NULL);

SELECT * FROM INSPECTEUR;
ROLLBACK;
SELECT * FROM INSPECTEUR;

" ROLLBACK annule les trois dernières insertions et pas juste la dernière "

-- Q20-Modifier les instructions de Q19 de manière à ce que la table INSPECTEUR
-- contienne les inspecteurs Pointu et Relax suite à l’annulation de la dernière transaction.
-- Vous devez conserver les 3 ordres insert. 

INSERT INTO INSPECTEUR VALUES(10,'Relax',NULL);
INSERT INTO INSPECTEUR VALUES(11,'Pointu',NULL);
COMMIT;
INSERT INTO INSPECTEUR VALUES(12,'Odieux',NULL);
SELECT * FROM INSPECTEUR;
ROLLBACK;
SELECT * FROM INSPECTEUR;

" ON VALIDE D'ABORD LES DEUX PREMIÈRES INSERTIONS ET PUIS ON RÉALISE LA TROISIEME SUIVI 
" DE ROLLBACK "

-- Q21-Executer le trigger suivant :

CREATE OR REPLACE TRIGGER VerifCepage
BEFORE INSERT OR UPDATE OF CEPAGE ON VIN FOR EACH ROW
BEGIN
  IF :NEW.CEPAGE = 'Pinot' THEN :NEW.CEPAGE := 'Pinot Noir';
  END IF;
END VerifCepage;
/

-- Q22-Insérer le tuple (5, 'Cotes de la Charité', 'Pinot') dans la table VIN.
-- Que se passe-t-il ? Pourquoi ?

INSERT INTO VIN  VALUES(5, 'Cotes de la Charite', 'Pinot');

" violation de la contrainte d'index unique : Pinot Noir existe déjà dans la table CEPAGE "

SELECT * FROM VIN;

-- Q23-Modifier le tuple pour mettre Pinot.

INSERT INTO VIN  VALUES(5, 'Cotes de la Charite', 'Pinot ');

-- Q24-Executer le trigger suivant :

CREATE OR REPLACE TRIGGER VerifChardonnay
BEFORE INSERT OR UPDATE ON TEST FOR EACH ROW
DECLARE
      V_CEPAGE VARCHAR2(30);
      V_INOM VARCHAR2(30);
BEGIN
  SELECT CEPAGE INTO V_CEPAGE
  FROM VIN
  WHERE VNUM=:NEW.VNUM;
  IF V_CEPAGE='Chardonnay' THEN
    SELECT INOM INTO V_INOM
    FROM INSPECTEUR
    WHERE INUM=:NEW.INUM;
    IF (V_INOM!='Cool' AND V_INOM!='Sympa') THEN
      RAISE_APPLICATION_ERROR(-20000,'Seuls les inspecteurs Cool et Sympa peuvent attribuer une note aux vins Chardonnay.');
    END IF;
  END IF;
END VerifChardonnay;
/
-- si erreur : SHOW ERRORS

-- Q25-Insérer le tuple (1, 2, 6, 10/04/2009) dans la table TEST.
-- Que se passe-t-il ? Pourquoi ?

INSERT INTO TEST VALUES(1, 2, 6, TO_DATE('10042009','DD/MM/YYYY'));

" Le trigger exige que ce soit Sympa et Cool qui évaluent le vin, alors qu'ici on avait Intransigeant "

-- Q26-Insérer le tuple (3, 3, 8, 15/04/2009) dans la table TEST.
-- Que se passe-t-il ? Pourquoi ?

INSERT INTO TEST VALUES(3, 3, 8, TO_DATE('15042009','DD/MM/YYYY'));

" La ligne a été crée -- (C'est du pinot Noir et pas Chardonnay) "

-- Q27-Insérer le tuple (1, 3, 6, 20/04/2009) dans la table TEST.
-- Que se passe-t-il ? Pourquoi ?

INSERT INTO TEST VALUES(1, 3, 6, TO_DATE('20042009','DD/MM/YYYY'));

" Ligne crée : Sympa donne une note au Chardonnay "

-- Q28-Nous avons fait une erreur, en fait c'était l'inspecteur 2 qui avait mis la note.
-- Corriger. Que se passe-t-il ? Pourquoi ?

UPDATE TEST SET VNUM=2;

" violation de la contraitnte unique : Le couple (2,3) existe déjà dans la table TEST "

-- Q29-Observer les tables que vous avez créez dans USER_CATALOG ou CAT (synonyme).

SELECT TABLE_NAME, TABLE_TYPE FROM CAT;

-- Q30-Supprimer la table INSPECTEUR. Que se passe-t'il ? Pourquoi ?

DROP TABLE INSPECTEUR;

" On ne peut supprimer la table INSPECTEUR ni VIN avant TEST (contient des clés étrangères des deux tables) "

-- Q31-Supprimer la table TEST puis interroger la vue SYNTHESE09.
-- Que se passe-t'il ?

DROP TABLE TEST;

SELECT * FROM SYNTHESE09;

" La vue interroge la table TEST qui est supprimée "

-- Q32-Vider la table VIN. Vérifier que tout s’est bien passé.

DELETE FROM VIN;

SELECT * FROM VIN;
SELECT * FROM INSPECTEUR;
SELECT * FROM TEST;

" aucune ligne séléctionnée dans VIN "

-- Q33-Supprimer les tables VIN et INSPECTEUR. Vérifier que tout s’est bien passé.

DROP TABLE VIN;
DROP TABLE INSPECTEUR;
DROP VIEW SYNTHESE09;

SELECT * FROM CAT;
