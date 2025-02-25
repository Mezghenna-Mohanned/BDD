ALTER TABLE SPORTS 
ADD CONSTRAINT ck_libelle 
CHECK (LIBELLE IN ('Basket ball', 'Volley ball', 'Hockey', 'Hand ball', 'Tennis', 'Badmington', 'Ping pong', 'Boxe', 'Football'));

-- Tmchi , no errors