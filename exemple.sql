-- mettre en place table

CREATE TEMP TABLE temp_personnes (
    identifier INT,
    full_name VARCHAR(100),
    age INT
);

\COPY temp_personnes (identifier, full_name, age)
FROM 'chemin/vers/personnes.csv'
DELIMITER ','
CSV HEADER;

ALTER TABLE personnes
RENAME COLUMN identifier TO id,
RENAME COLUMN full_name TO nom;



SELECT c.nom AS client, p.nom AS produit, cp.quantite
FROM schema2.commande_produits cp
JOIN schema2.commandes co ON cp.commande_id = co.id
JOIN schema1.clients c ON co.client_id = c.id
JOIN schema2.produits p ON cp.produit_id = p.id;


CREATE TEMP TABLE tmp_notes (
    id INT,
    nom TEXT,
    maths NUMERIC,
    français NUMERIC,
    histoire NUMERIC
);

\copy tmp_notes FROM 'notes.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE notes (
    id_eleve INT,
    nom TEXT,
    matiere TEXT,
    note NUMERIC
);

-- Insertion "unpivotée"
INSERT INTO notes(id_eleve, nom, matiere, note)
SELECT id, nom, 'maths', maths FROM tmp_notes
UNION ALL
SELECT id, nom, 'français', français FROM tmp_notes
UNION ALL
SELECT id, nom, 'histoire', histoire FROM tmp_notes;


INSERT INTO Country(idCountry, Country, ISO2, ISO3)
SELECT 
    ROW_NUMBER() OVER (),
    p.nom,
    p.age,
    a.produit
FROM tmp_achats a
JOIN tmp_personnes p ON a.id_personne = p.id_personne;
