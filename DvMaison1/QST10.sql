ALTER TABLE SPORTS 
DISABLE CONSTRAINT ck_libelle;

INSERT INTO SPORTS (IDSPORT, LIBELLE) VALUES (10, 'Natation');
INSERT INTO SPORTS (IDSPORT, LIBELLE) VALUES (11, 'Golf');


ALTER TABLE SPORTS 
ENABLE CONSTRAINT ck_libelle;

ALTER TABLE SPORTS 
DROP CONSTRAINT ck_libelle;

ALTER TABLE SPORTS 
ADD CONSTRAINT ck_libelle 
CHECK (LIBELLE IN ('Basket ball', 'Volley ball', 'Hockey', 'Hand ball', 
                   'Tennis', 'Badmington', 'Ping pong', 'Boxe', 'Football', 
                   'Natation', 'Golf'));

-- Tmchi , no errors