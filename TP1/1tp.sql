--partie 1

-- first
ALTER TABLE Fournisseur
ADD Adresse VARCHAR(255);

--2
ALTER TABLE Fournisseur
DROP COLUMN Adresse;

--3
-- pour verifier la structure de la table
desc Fournisseur;
-- les insertions
SELECT * FROM Fournisseur;
SELECT * FROM Produit;







-- 2eme partie

--1
select * from usine;

--2
select NU , NomU from usine where Ville LIKE 'Sochaux';

--3
select nomf from
fournisseur where nf in 
(select nf from livraison where nu = 1 AND np = 3);

--4
SELECT NP, NomProd
FROM Produit
WHERE Couleur IS NULL;

--5
SELECT DISTINCT NomU
FROM Usine
ORDER BY NomU ASC;

--6
SELECT NU
FROM Usine
WHERE NomU LIKE 'C%';

--7
SELECT NP
FROM Produit
WHERE NomProd LIKE '%S%';

--8 
SELECT DISTINCT Fournisseur.NomFourn
FROM Livraison
JOIN Fournisseur ON Livraison.NumFourn = Fournisseur.NumFourn
WHERE Livraison.NU = 1 AND Livraison.NP = 3;

--9
SELECT DISTINCT Produit.NomProd, Produit.Couleur
FROM Livraison
JOIN Produit ON Livraison.NP = Produit.NP
WHERE Livraison.NumFourn = 2;

--10
SELECT DISTINCT Livraison.NumFourn
FROM Livraison
JOIN Produit ON Livraison.NP = Produit.NP
WHERE Livraison.NU = 1 AND Produit.Couleur = 'rouge';

--11
SELECT DISTINCT Fournisseur.NomFourn
FROM Livraison
JOIN Produit ON Livraison.NP = Produit.NP
JOIN Usine ON Livraison.NU = Usine.NU
WHERE (Usine.Ville = 'Schaux' OR Usine.Ville = 'Paris') AND Produit.Couleur = 'rouge';

--12
SELECT DISTINCT Livraison.NP
FROM Livraison
JOIN Usine ON Livraison.NU = Usine.NU
JOIN Fournisseur ON Livraison.NumFourn = Fournisseur.NumFourn
WHERE Usine.Ville = Fournisseur.Ville;

--13
SELECT DISTINCT Livraison.NU
FROM Livraison
JOIN Usine ON Livraison.NU = Usine.NU
JOIN Fournisseur ON Livraison.NumFourn = Fournisseur.NumFourn
WHERE Usine.Ville != Fournisseur.Ville;

--14
SELECT Numf
FROM Livraison
WHERE NU = 1
INTERSECT
SELECT nf
FROM Livraison
WHERE NU = 2;

--15
SELECT DISTINCT Livraison.NU
FROM Livraison
WHERE Livraison.NP IN (
    SELECT NP
    FROM Livraison
    WHERE NumFourn = 3
);

--16
SELECT NU
FROM Livraison
GROUP BY NU
HAVING COUNT(DISTINCT NumFourn) = 1 AND MIN(NumFourn) = 3;

--17
SELECT Usine.NomU
FROM Usine
WHERE Usine.NU NOT IN (
    SELECT Livraison.NU
    FROM Livraison
    JOIN Produit ON Livraison.NP = Produit.NP
    JOIN Fournisseur ON Livraison.NumFourn = Fournisseur.NumFourn
    WHERE Produit.Couleur = 'rouge' AND Fournisseur.Ville = 'Paris'
);

--18
SELECT COUNT(*) AS TotalFournisseurs
FROM Fournisseur;

--19
SELECT COUNT(*) AS ProduitsAvecCouleur
FROM Produit
WHERE Couleur IS NOT NULL;

--20
SELECT AVG(Poids) AS MoyennePoids
FROM Produit;

--21
SELECT SUM(Poids) AS SommePoidsVerts
FROM Produit
WHERE Couleur = 'vert';

--22
SELECT MIN(Poids) AS PoidsMin
FROM Produit
WHERE Couleur IS NOT NULL;

--23
SELECT NumFourn, COUNT(NP) AS NbProduitsLivres
FROM Livraison
GROUP BY NumFourn;

--24
SELECT Couleur, AVG(Poids) AS PoidsMoyen
FROM Produit
GROUP BY Couleur;

--25
SELECT Couleur
FROM Produit
GROUP BY Couleur
HAVING AVG(Poids) > 10;

--26
SELECT COUNT(DISTINCT Livraison.NP) AS NbProduits
FROM Livraison
JOIN Fournisseur ON Livraison.NumFourn = Fournisseur.NumFourn
WHERE Fournisseur.Ville = 'Paris';

--27
SELECT NP
FROM Produit
WHERE Poids = (SELECT MIN(Poids) FROM Produit);

--28
SELECT Fournisseur.NomFourn, COUNT(Livraison.NP) AS NbProduitsLivres
FROM Livraison
JOIN Fournisseur ON Livraison.NumFourn = Fournisseur.NumFourn
GROUP BY Fournisseur.NomFourn;


