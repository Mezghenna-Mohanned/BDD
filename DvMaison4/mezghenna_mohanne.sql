------------------------------------------------------------
CREATE OR REPLACE PROCEDURE affiche_gymnases_par_sport IS
BEGIN
  FOR rec IN (
    SELECT s.nom_sport, COUNT(DISTINCT se.id_gymnase) AS nb_gymnases
    FROM seance se
    JOIN sport s ON se.id_sport = s.id_sport
    GROUP BY s.nom_sport
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Le sport "' || rec.nom_sport || '" est organisé par ' || rec.nb_gymnases || ' gymnases');
  END LOOP;
END;
/
BEGIN
  affiche_gymnases_par_sport;
END;
/

------------------------------------------------------------
CREATE OR REPLACE PROCEDURE augmenter_age_sportifs IS
  v_old_age NUMBER;
  v_new_age NUMBER;
BEGIN
  FOR rec IN (SELECT id_sportif, nom, prenom, age FROM sportif FOR UPDATE) LOOP
    v_old_age := rec.age;
    v_new_age := rec.age + 5;
    UPDATE sportif
      SET age = v_new_age
      WHERE CURRENT OF rec;
      
    DBMS_OUTPUT.PUT_LINE('Le sportif ' || rec.nom || ' ' || rec.prenom || 
                         ' son age a passé de ' || v_old_age || ' ans a ' || v_new_age || ' ans');
  END LOOP;
  COMMIT;
END;
/
BEGIN
  augmenter_age_sportifs;
END;
/

------------------------------------------------------------
CREATE OR REPLACE PROCEDURE afficher_horaires_gymnases IS
BEGIN
  FOR rec IN (
    SELECT g.id_gymnase, g.nom, g.jour_ouverture,
           MIN(s.horaire_debut) AS premiere_seance,
           MAX(s.horaire_fin)   AS derniere_seance
    FROM gymnase g
    JOIN seance s ON g.id_gymnase = s.id_gymnase
    WHERE g.superficie > 400
    GROUP BY g.id_gymnase, g.nom, g.jour_ouverture
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Gymnase ' || rec.nom || ' (ID: ' || rec.id_gymnase || 
                         '), ouvert le ' || rec.jour_ouverture ||
                         ' : première ance à ' || rec.premiere_seance ||
                         ' et dernière seance à ' || rec.derniere_seance);
  END LOOP;
END;
/
BEGIN
  afficher_horaires_gymnases;
END;
/

------------------------------------------------------------
CREATE OR REPLACE FUNCTION nombre_sports_entraine(p_id_sportif NUMBER) RETURN NUMBER IS
  v_count NUMBER;
BEGIN
  SELECT COUNT(DISTINCT id_sport)
    INTO v_count
  FROM entrainement
  WHERE id_sportif = p_id_sportif;
  RETURN v_count;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 0;
END;
/
  
------------------------------------------------------------
CREATE OR REPLACE PROCEDURE afficher_sports_par_sportif IS
  v_nb NUMBER;
BEGIN
  FOR rec IN (SELECT id_sportif, nom, prenom FROM sportif) LOOP
    v_nb := nombre_sports_entraine(rec.id_sportif);
    DBMS_OUTPUT.PUT_LINE('Le sportif ' || rec.nom || ' ' || rec.prenom || ' entraine ' || v_nb || ' sport');
  END LOOP;
END;
/
BEGIN
  afficher_sports_par_sportif;
END;
/
