CREATE PROCEDURE recolte_ticket (IN montant DECIMAL(10,2), IN id_user INT, IN ref_trans VARCHAR(255))
BEGIN
    SELECT id INTO @ref_tk FROM compte where reference_transaction LIKE '%TCK-31072024%';
    IF @ref_tk > 0 AND @ref_tk IS NOT NULL THEN
        INSERT INTO compte (montant_entrant,reference_transaction,id_type_transaction,id_utilisateur,id_condition_generale)
        VALUES (montant,ref_trans,(SELECT id from type_transaction where t_type LIKE '%recolte%'),id_user,(SELECT id FROM condition_generale where mode like '%Aucun%'));
    END IF;
END;
/*
    * ity procedure ity dia procedure rehefa mi-scan ilay ticket a partir
    ny app mobile (utilisateur connecte dans le plateforme)
    dia tokony mirecompenser ilay utilisateur d'un certains somme
    tany amin'ny certaine machine de recolte manan informations (
    -montant,
    -id_utilisateur,
    -reference_transaction,
    -id_opt_transaction
    ))
*/
-- v1
CREATE  PROCEDURE `recolte_ticket`(IN montant DECIMAL(10,2), IN id_user INT, IN ref_trans VARCHAR(255), IN id_opt_transaction INT, IN id_machine_recolte INT)
BEGIN
    DECLARE ref_tk INT;

    START TRANSACTION;

    SELECT COUNT(id) INTO ref_tk
    FROM transaction_gains
    where reference_transaction LIKE CONCAT('%',ref_trans,'%');

    IF ref_tk > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ce ticket est deja expire';
    END IF;

    IF id_opt_transaction IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Aucun service attribue';
    END IF;

    INSERT INTO transaction_gains (montant_entrant, reference_transaction, id_opt_transaction, id_utilisateur,id_machine_recolte)
    VALUES (montant, ref_trans, id_opt_transaction, id_user,id_machine_recolte);

    COMMIT;
END

-- v2
CREATE  PROCEDURE `recolte_ticket`(IN montant DECIMAL(10,2), IN id_user INT, in id_machine_recolte INT, IN code_rclt varchar(6))
BEGIN
    DECLARE ref_tk INT;
    DECLARE service_id INT;
    DECLARE id_type_transaction INT;
    DECLARE id_ba INT;

    START TRANSACTION;

    SELECT COUNT(id) INTO ref_tk
    FROM transaction
    where code_recolte = code_rclt;

    select id INTO service_id
    FROM service where libelle = 'recolte';

    select id INTO id_type_transaction
    from type_transaction where type_transaction ='Recolte';

    select id INTO id_ba
    from bon_achat where code_barre LIKE '%XXX%' or entreprise_partenaire = 'Aucun';

    IF ref_tk > 0 or ref_tk is null THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ce ticket est deja expire';
    END IF;


    INSERT INTO transaction (montant, reference, id_type_transaction, id_utilisateur,id_machine_recolte, id_service, id_bon_achat)
    VALUES (montant, generate_reference_recolte(), id_type_transaction, id_user,id_machine_recolte,service_id,id_ba);

    COMMIT;
END

-- v3
CREATE PROCEDURE `recolte_ticket`(IN montant DECIMAL(10,2), IN id_user INT, in id_machine_recolte INT, IN code_rclt varchar(6))
BEGIN
    DECLARE ref_tk INT;
    DECLARE service_id INT;
    DECLARE id_type_transaction INT;
    DECLARE v_ref_rclt VARCHAR(255);
    DECLARE solde_init DECIMAL(10,2);
    DECLARE solde_final DECIMAL(10,2);
  
    START TRANSACTION;
  
    SELECT COUNT(t.id) INTO ref_tk
    FROM transaction t
    WHERE t.code_recolte = code_rclt;
  
    IF ref_tk > 0 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ce ticket est deja expire';
    END IF;

    SELECT s.id, tt.id,u.solde
    FROM utilisateur u
    INNER JOIN type_transaction tt ON tt.type_transaction = 'Recolte'
    INNER JOIN service s on s.libelle = 'Recolte'
    where u.id_utilisateur = id_user;
  
    SET v_ref_rclt = generate_reference_recolte();

    SET solde_final = solde_init + montant;

    UPDATE utilisateur set solde = solde_final where id = id_user;
  
    INSERT INTO transaction (montant, reference, id_type_transaction, id_utilisateur, id_machine_recolte, id_service)
    VALUES (montant, v_ref_rclt, id_type_transaction, id_user, id_machine_recolte, service_id);
  
    COMMIT;
END;
