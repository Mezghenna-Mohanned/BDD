-- 1ere question
CREATE OR REPLACE FUNCTION nombre_usines(p_ville VARCHAR2) RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count 
  FROM usine 
  WHERE ville = p_ville;
  RETURN v_count;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0;
END;
/
DECLARE
  CURSOR c_villes IS
    SELECT DISTINCT ville FROM usine;
  v_nb NUMBER;
BEGIN
  FOR rec IN c_villes LOOP
    v_nb := nombre_usines(rec.ville);
    DBMS_OUTPUT.PUT_LINE('La ville ' || rec.ville || ' a ' || v_nb || ' usine(s).');
  END LOOP;
END;
/
-- 2eme question
CREATE OR REPLACE PROCEDURE poids_total_fournisseur(p_nf NUMBER) IS
  v_total NUMBER;
BEGIN
  SELECT NVL(SUM(poids), 0) INTO v_total
  FROM livraison
  WHERE nf = p_nf;
  
  DBMS_OUTPUT.PUT_LINE('Le fournisseur ' || p_nf || ' a livré des produits totalisant un poids de ' || v_total);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Erreur lors du calcul pour le fournisseur ' || p_nf);
END;
/
DECLARE
  CURSOR c_fourn IS
    SELECT nf FROM fournisseur;
BEGIN
  FOR rec IN c_fourn LOOP
    poids_total_fournisseur(rec.nf);
  END LOOP;
END;
/
-- 3eme question
CREATE OR REPLACE PROCEDURE poids_total_globale IS
BEGIN
  FOR rec IN (SELECT nf, NVL(SUM(poids), 0) AS total_poids 
              FROM livraison 
              GROUP BY nf) LOOP
    DBMS_OUTPUT.PUT_LINE('Le fournisseur ' || rec.nf || ' a livré un poids total de ' || rec.total_poids);
  END LOOP;
END;
/
BEGIN
  poids_total_globale;
END;
/
-- 4eme question
CREATE OR REPLACE PROCEDURE fournisseur_max_produits(p_ville VARCHAR2) IS
  v_nf fournisseur.nf%TYPE;
  v_nom fournisseur.nomf%TYPE;
  v_max NUMBER;
BEGIN
  SELECT l.nf, f.nomf, COUNT(*) AS nb
  INTO v_nf, v_nom, v_max
  FROM livraison l
  JOIN fournisseur f ON l.nf = f.nf
  WHERE l.ville = p_ville
  GROUP BY l.nf, f.nomf
  ORDER BY COUNT(*) DESC
  FETCH FIRST 1 ROWS ONLY;
  
  DBMS_OUTPUT.PUT_LINE('Dans la ville ' || p_ville || ', le fournisseur ' 
       || v_nom || ' (N° ' || v_nf || ') a livré le plus de produits avec ' || v_max || ' livraisons.');
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Aucun fournisseur trouvé pour la ville ' || p_ville);
END;
/
DECLARE
  CURSOR c_ville IS
    SELECT DISTINCT ville FROM livraison;
BEGIN
  FOR rec IN c_ville LOOP
    fournisseur_max_produits(rec.ville);
  END LOOP;
END;
/
-- 5eme question
CREATE OR REPLACE PROCEDURE fournisseur_max_quantite(p_np NUMBER) IS
  v_nf fournisseur.nf%TYPE;
  v_nom fournisseur.nomf%TYPE;
  v_total NUMBER;
BEGIN
  SELECT l.nf, f.nomf, SUM(l.quantite) AS total_qte
  INTO v_nf, v_nom, v_total
  FROM livraison l
  JOIN fournisseur f ON l.nf = f.nf
  WHERE l.np = p_np
  GROUP BY l.nf, f.nomf
  ORDER BY SUM(l.quantite) DESC
  FETCH FIRST 1 ROWS ONLY;
  
  DBMS_OUTPUT.PUT_LINE('Pour le produit ' || p_np || ', le fournisseur ' 
       || v_nom || ' (N° ' || v_nf || ') a livré la plus grande quantité totale de ' || v_total);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Aucun fournisseur n''a livré le produit ' || p_np);
END;
/
DECLARE
  CURSOR c_prod IS
    SELECT DISTINCT np FROM livraison;
BEGIN
  FOR rec IN c_prod LOOP
    fournisseur_max_quantite(rec.np);
  END LOOP;
END;
/
-- 6eme question
ALTER TABLE livraison ADD (date_livraison DATE);
/
DECLARE
    v_date_debut DATE := TO_DATE('01/02/2025', 'DD/MM/YYYY');
    v_date_fin   DATE := TO_DATE('30/04/2025', 'DD/MM/YYYY');
BEGIN
    FOR r IN (SELECT np FROM livraison) LOOP
        UPDATE livraison
        SET date_livraison = v_date_debut + FLOOR(DBMS_RANDOM.VALUE(0, (v_date_fin - v_date_debut)))
        WHERE np = r.np;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Mise à jour');
END;
/
-- 7eme question
DECLARE
  CURSOR c_mois IS
    SELECT TO_CHAR(date_livraison, 'MM/YYYY') AS mois, COUNT(*) AS nb
    FROM livraison
    GROUP BY TO_CHAR(date_livraison, 'MM/YYYY')
    ORDER BY TO_DATE(TO_CHAR(date_livraison, 'MM/YYYY'), 'MM/YYYY');
BEGIN
  FOR rec IN c_mois LOOP
    DBMS_OUTPUT.PUT_LINE('Pour le mois ' || rec.mois || ', le nombre total de livraisons est : ' || rec.nb);
  END LOOP;
END;
/