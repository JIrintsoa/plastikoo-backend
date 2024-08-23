-- Bon d'achat v1
CREATE  PROCEDURE `creer_ba`(IN id_utilisateur int, IN id_serv int)
BEGIN
    select generate_reference_ba() INTO @ref_ba;
    select id,solde INTO @id_user,@solde_init FROM utilisateur where id = id_utilisateur;
    select id into @id_type_trans from type_transaction where type_transaction = 'Bon d''achat';
    select duree_jour_valide, commission_plastikoo into @duree_exp, @com_pla from service where id = id_serv; 
    select DATE_ADD(CURDATE(), INTERVAL @duree_exp DAY) into @date_exp;
    select id into @id_mr from machine_recolte where designation = 'No machine';

    INSERT INTO transaction (id_utilisateur,montant,reference, id_service, id_type_transaction,id_machine_recolte)
    values (@id_user,@solde_init,@ref_ba,id_serv,@id_type_trans,@id_mr);

    select id INTO @id_transaction
    from transaction where reference = @ref_ba;

    INSERT INTO bon_achat (id_transaction, commission, date_exp)
    values (@id_transaction, @com_pla, @date_exp);

END

-- v2
CREATE  PROCEDURE `creer_ba`(IN id_utilisateur int, IN id_serv int,IN montant DECIMAL(10,2), IN commission_plastikoo DOUBLE, IN duree_exp int)
BEGIN
    DECLARE ref_ba VARCHAR(255);
    DECLARE id_user INT;
    DECLARE id_type_trans INT;
    DECLARE date_exp DATE;
    DECLARE id_mr INT;
    DECLARE id_transaction INT;
    DECLARE id_type_transaction INT;

    SELECT u.id, s.id, mr.id,tt.id
    INTO id_user, id_serv, id_mr,id_type_transaction
    FROM utilisateur u
    INNER JOIN service s ON s.id = id_serv
    INNER JOIN machine_recolte mr ON mr.designation = 'No machine'
    INNER JOIN type_transaction tt on tt.type_transaction = 'Bon d''achat'
    WHERE u.id = id_utilisateur;

    SET ref_ba = generate_reference_ba();
    SET date_exp = DATE_ADD(CURDATE(), INTERVAL duree_exp DAY);

    START TRANSACTION;

    INSERT INTO transaction (id_utilisateur, montant, reference, id_service, id_type_transaction, id_machine_recolte)
    VALUES (id_user, montant,ref_ba, id_serv, id_type_transaction, id_mr);

    SELECT id INTO id_transaction FROM transaction WHERE reference = ref_ba;

    INSERT INTO bon_achat (id_transaction, commission, date_exp)
    VALUES (id_transaction, commission_plastikoo, date_exp);

    COMMIT;
    select id_transaction;

END



-- details bon achat 
-- v1
select
t.id as id_transaction,
ba.id as id_bon_achat,
t.montant as montant_init,
(t.montant - (t.montant * ba.commission)) as montant_final,
ba.commission
from bon_achat ba
inner join transaction t on ba.id_transaction = t.id
inner join t
where t.id_utilisateur = 1 and ba.etat = 'cree' and date_transaction = (select CURDATE());

-- v2
select
t.id as id_transaction,
ba.id as id_bon_achat,
ba.code_barre,
t.montant,
s.libelle as partenaire,
ba.date_exp
FROM bon_achat ba
INNER JOIN transaction t on ba.id_transaction = t.id
INNER JOIN service s on s.id = t.id_service
where id = 1;