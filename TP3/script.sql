-- connect ing/psw;

-- create table TableError(
--   adresse ROWID,
--   utilisateur VARCHAR(30),
--   nomTable VARCHAR(30),
--   nomContrainte VARCHAR(30)
-- );


-- create table fournisseur1 (nf integer,
--                           nomf varchar (25),
--                           statut varchar (25),
--                           ville varchar (15),
--                           email varchar (50),
-- CONSTRAINT pk_fournisseur PRIMARY KEY (nf),
-- CONSTRAINT uk_fournisseur UNIQUE (email),
-- CONSTRAINT ck_fournisseur check (email like '%@%' ));

-- alter table fournisseur1 disable constraint ck_fournisseur;
-- select constraint_name, constraint_type, status from user_constraints where table_name = 'FOURNISSEUR1';

-- insert into fournisseur1 values (2, 'au bon siege ', 'sous traitant', 'limoges', 'au_bon_siegemail.com');


-- select * from TableError;
-- alter table fournisseur1 enable constraint ck_fournisseur;

-- select * from TableError;


-- DELETE FROM fournisseur1 WHERE email NOT LIKE '%@%';

-- ALTER TABLE fournisseur1 ENABLE CONSTRAINT ck_fournisseur;

-- DELETE FROM fournisseur1 WHERE nf = 2;

-- INSERT INTO fournisseur1 VALUES (2, 'au bon siege ', 'sous traitant', 'limoges', 'au_bon_siege@email.com');


-- Connect as ing/psw




-- CONNECT ing/psw;

-- CREATE USER USERFOUR IDENTIFIED BY psw
-- DEFAULT TABLESPACE users
-- TEMPORARY TABLESPACE temp;

-- GRANT CONNECT, RESOURCE TO USERFOUR;


-- ALTER USER USERFOUR QUOTA UNLIMITED ON users;



-- connect system/131004;

-- desc dba_users;

-- select username, created from dba_users where username =upper('USERFOUR');


