SELECT S.IDSPORTIF, S.NOM, S.PRENOM
FROM SPORTIFS S
WHERE S.IDSPORTIF IN (
    SELECT E.IDSPORTIFENTRAINEUR
    FROM ENTRAINER E
    JOIN SPORTS SP ON E.IDSPORT = SP.IDSPORT
    GROUP BY E.IDSPORTIFENTRAINEUR
    HAVING COUNT(DISTINCT SP.LIBELLE) = 2 
           AND SUM(CASE WHEN SP.LIBELLE NOT IN ('Hand ball', 'Basket ball') THEN 1 ELSE 0 END) = 0
);
