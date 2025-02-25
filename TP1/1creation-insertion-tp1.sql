--table usine
CREATE TABLE usine (NU int,                                           
                   NomU varchar(15),                                           
                   Ville varchar(15),    
CONSTRAINT pk_usine PRIMARY KEY (NU));

--table produit
create table produit ( np integer,
                       nomp varchar (20),
                       couleur varchar (10) ,
                       poids real ,
CONSTRAINT pk_produit PRIMARY KEY (np),
CONSTRAINT ck_produit check (poids>0) 
) ;

--table fournisseur
create table fournisseur (nf integer,
                          nomf varchar (25),
                          statut varchar (25),
                          ville varchar (15),
                          email varchar (50),
CONSTRAINT pk_fournisseur PRIMARY KEY (nf),
CONSTRAINT uk_fournisseur UNIQUE (email),
CONSTRAINT ck_fournisseur check (email like '%@%' )
) ;

--table fourisseur1

create table fournisseur1 (nf integer primary key,
                           nomf varchar (25),
                           statut varchar (25),
                           ville varchar (15),
                           email varchar (50) unique);

--table livraison
create table livraison (np integer ,
                        nu integer ,
                        nf integer ,
                        quantite integer,
Constraint pk_livraison primary key (np,nu ,nf),
Constraint fk_livraison_prod foreign key (np) references produit (np) on delete cascade,
Constraint fk_livraison_usin foreign key (nu) references usine (nu) on delete cascade,
Constraint fk_livraison_four foreign key (nf) references fournisseur (nf) on delete cascade,
Constraint ck_livraison check (quantite>0) 
); 


--Insertion

insert into usine values ( 1 ,'Citroen','Paris') ;
insert into usine values ( 2 ,'Peugeot','Sochaux') ;
insert into usine values ( 3 ,'Citroen','Sochaux') ;
insert into usine values ( 4 ,'Renault','Paris') ;
insert into usine values ( 5 ,'Toyota','Lyon') ;

insert into produit values ( 1 ,'Plaquette','Noir', 0.257 ) ;
insert into produit values ( 2 ,'Siege','Rouge', 15.230 ) ;
insert into produit values ( 3 ,'Siege','Vert', 15.230 ) ;
insert into produit values ( 4 ,'Parebrise', null , 11.900 ) ;
insert into produit values ( 5 ,'Retroviseur','Vert', 1.020 ) ;

insert into fournisseur values
( 1 ,'Monroe','Producteur','Lyon','monroe@gmail.com') ;
insert into fournisseur values
( 2 ,'Au bon siege','Sous traitant','Limoges','au_bon_siege@gmail.com') ;
insert into fournisseur values
( 3 ,'Saint Gobain','Producteur','Paris','saint_goubain@gmail.com') ;

insert into livraison values ( 3 , 1 , 2 ,60 ) ;
insert into livraison values ( 1 , 2 , 3 , 2500 ) ;
insert into livraison values ( 1 , 3 , 3 , 3000 ) ;
insert into livraison values ( 2 , 2 , 3 , 120 ) ;
insert into livraison values ( 3 , 1 , 1 , 49 ) ;
insert into livraison values ( 3 , 2 , 1 , 45 ) ;
insert into livraison values ( 3 , 3 , 1 , 78 ) ;
insert into livraison values ( 2 , 4 , 2 , 52 ) ;
insert into livraison values ( 2 , 1 , 1 , 250 ) ;
insert into livraison values ( 2 , 1 , 3 , 250 ) ;
