--1
ALTER TABLE PRODUIT 
  ADD QteStock NUMBER(10);

UPDATE PRODUIT SET QteStock = 7000 WHERE ID_PRODUIT = 1;
UPDATE PRODUIT SET QteStock = 700  WHERE ID_PRODUIT = 2;
UPDATE PRODUIT SET QteStock = 300  WHERE ID_PRODUIT = 3;
UPDATE PRODUIT SET QteStock = 100  WHERE ID_PRODUIT = 4;
UPDATE PRODUIT SET QteStock = 200  WHERE ID_PRODUIT = 5;
COMMIT;

--2
CREATE OR REPLACE PROCEDURE calculerQteRestante(
  p_idProduit IN PRODUIT.ID_PRODUIT%TYPE
) IS
  v_qteStock   PRODUIT.QteStock%TYPE;
  v_qteLivrees NUMBER;
  v_restant    NUMBER;
BEGIN
  SELECT QteStock
  INTO v_qteStock
  FROM PRODUIT
  WHERE ID_PRODUIT = p_idProduit;

  SELECT NVL(SUM(QTE_LIVREE), 0)
  INTO v_qteLivrees
  FROM LIVRAISON
  WHERE ID_PRODUIT = p_idProduit;

  v_restant := v_qteStock - v_qteLivrees;

  DBMS_OUTPUT.PUT_LINE('Quantite restante en stock pour le produit ' 
                       || p_idProduit || ' : ' || v_restant);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Aucun produit trouve avec l''ID : ' || p_idProduit);
END;
/

--3
CREATE OR REPLACE TRIGGER trg_update_stock
AFTER INSERT OR UPDATE ON LIVRAISON
FOR EACH ROW
DECLARE
BEGIN
  UPDATE PRODUIT
     SET QteStock = QteStock - :NEW.QTE_LIVREE
   WHERE ID_PRODUIT = :NEW.ID_PRODUIT;
END;
/

--4
CREATE OR REPLACE TRIGGER trg_check_stock
BEFORE INSERT OR UPDATE ON LIVRAISON
FOR EACH ROW
DECLARE
  v_stock DISPONIBLE%TYPE;
BEGIN
  SELECT QteStock
  INTO v_stock
  FROM PRODUIT
  WHERE ID_PRODUIT = :NEW.ID_PRODUIT;

  IF :NEW.QTE_LIVREE > v_stock THEN
    RAISE_APPLICATION_ERROR(-20001, 'Stock insuffisant pour ce produit.');
  END IF;
END;
/

--5
CREATE TABLE subscription_per_day (
  datee         DATE CONSTRAINT pk_subs_per_day PRIMARY KEY,
  total_per_day NUMBER
);

CREATE OR REPLACE TRIGGER trg_subscription_per_day
AFTER INSERT ON LIVRAISON
FOR EACH ROW
DECLARE
  v_count    NUMBER := 0;
BEGIN
  SELECT COUNT(*)
    INTO v_count
    FROM subscription_per_day
   WHERE datee = TRUNC(:NEW.DATE_LIVRAISON);

  IF v_count = 0 THEN
    INSERT INTO subscription_per_day(datee, total_per_day)
    VALUES(TRUNC(:NEW.DATE_LIVRAISON), 1);
  ELSE
    UPDATE subscription_per_day
       SET total_per_day = total_per_day + 1
     WHERE datee = TRUNC(:NEW.DATE_LIVRAISON);
  END IF;
END;
/

--6
CREATE OR REPLACE TRIGGER trg_prevent_usine_delete
BEFORE DELETE ON USINE
FOR EACH ROW
DECLARE
  v_count NUMBER := 0;
BEGIN
  SELECT COUNT(*)
    INTO v_count
    FROM LIVRAISON
   WHERE ID_USINE = :OLD.ID_USINE;

  IF v_count > 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'Impossible de supprimer cette usine : des livraisons sont associees.');
  END IF;
END;
/

--7
ALTER TABLE PRODUIT
  ADD prix NUMBER(10);

UPDATE PRODUIT SET prix = 2000  WHERE ID_PRODUIT = 1;
UPDATE PRODUIT SET prix = 3000  WHERE ID_PRODUIT = 2;
UPDATE PRODUIT SET prix = 3500  WHERE ID_PRODUIT = 3;
UPDATE PRODUIT SET prix = 10000 WHERE ID_PRODUIT = 4;
UPDATE PRODUIT SET prix = 5000  WHERE ID_PRODUIT = 5;
COMMIT;

--8
ALTER TABLE FOURNISSEUR
  ADD chiffre_affaire NUMBER(15,2);

CREATE OR REPLACE PROCEDURE calculerChiffreAffaireFournisseur(
  p_idFournisseur IN FOURNISSEUR.ID_FOURNISSEUR%TYPE
) IS
  v_chiffre_affaire NUMBER(15,2) := 0;
BEGIN
  SELECT NVL(SUM(L.QTE_LIVREE * P.PRIX), 0)
    INTO v_chiffre_affaire
    FROM LIVRAISON L
    JOIN PRODUIT P ON (L.ID_PRODUIT = P.ID_PRODUIT)
    WHERE P.ID_FOURNISSEUR = p_idFournisseur;

  UPDATE FOURNISSEUR
     SET chiffre_affaire = v_chiffre_affaire
   WHERE ID_FOURNISSEUR = p_idFournisseur;

  DBMS_OUTPUT.PUT_LINE('chiffre affaire pour le fournisseur ' 
                       || p_idFournisseur || ' = ' || v_chiffre_affaire);
END;
/

--9
BEGIN
  FOR rec IN (SELECT ID_FOURNISSEUR FROM FOURNISSEUR) 
  LOOP
    calculerChiffreAffaireFournisseur(rec.ID_FOURNISSEUR);
  END LOOP;
END;
/

--10
CREATE OR REPLACE TRIGGER trg_update_chiffre_affaire
AFTER INSERT OR UPDATE ON LIVRAISON
FOR EACH ROW
DECLARE
  v_idFournisseur FOURNISSEUR.ID_FOURNISSEUR%TYPE;
BEGIN
  SELECT ID_FOURNISSEUR
    INTO v_idFournisseur
    FROM PRODUIT
   WHERE ID_PRODUIT = :NEW.ID_PRODUIT;

  calculerChiffreAffaireFournisseur(v_idFournisseur);
END;
/
