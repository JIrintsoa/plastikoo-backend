CREATE SCHEMA plastikoo2;

CREATE  TABLE plastikoo2.administrateur ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	nom_utilisateur      VARCHAR(255)       ,
	email                VARCHAR(255)       ,
	mot_de_passe         VARCHAR(255)       
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE  TABLE plastikoo2.categorie ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	type_categorie       VARCHAR(255)       
 ) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE  TABLE plastikoo2.livraison ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	type_livraison       VARCHAR(255)       ,
	tarif                DECIMAL(10,2)       
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE  TABLE plastikoo2.role ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	designation          VARCHAR(255)    NOT NULL   
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE  TABLE plastikoo2.type_contact ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	intitule             VARCHAR(255)       
 ) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE  TABLE plastikoo2.type_plastique ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	p_type               VARCHAR(255)       
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE  TABLE plastikoo2.type_service ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	type_s               VARCHAR(255)       
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX idx_type_s ON plastikoo2.type_service ( type_s );

CREATE  TABLE plastikoo2.type_transaction ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	type_transaction     VARCHAR(255)       
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX idx_type_transaction ON plastikoo2.type_transaction ( type_transaction );

CREATE  TABLE plastikoo2.utilisateur ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	nom                  VARCHAR(255)       ,
	prenom               VARCHAR(255)       ,
	email                VARCHAR(255)       ,
	pseudo_utilisateur   VARCHAR(255)       ,
	mot_de_passe         VARCHAR(255)       ,
	date_naissance       DATE       ,
	solde                DECIMAL(10,2)  DEFAULT 0.00  NOT NULL   ,
	code_pin             VARCHAR(4)  DEFAULT 'XXXX'     ,
	cp_tentative         INT  DEFAULT 0  NOT NULL   ,
	cp_timestamp_exp     DATETIME       ,
	url_profil           VARCHAR(255)       ,
	id_google            INT       ,
	img_profil           VARCHAR(255)       
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX idx_utilisateur_email_mdp ON plastikoo2.utilisateur ( email, mot_de_passe );

CREATE INDEX idx_utilisateur_infos ON plastikoo2.utilisateur ( nom, prenom, date_naissance );

CREATE  TABLE plastikoo2.utilisateur_role ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	id_utilisateur       INT       ,
	id_role              INT       
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_utilisateur_role_role ON plastikoo2.utilisateur_role ( id_role );

CREATE INDEX fk_utilisateur_role_utilisateur ON plastikoo2.utilisateur_role ( id_utilisateur );

CREATE  TABLE plastikoo2.commande ( 
	id                   INT       ,
	reference_panier     VARCHAR(255)       ,
	num_mob_money        VARCHAR(50)       ,
	id_type_livraison    INT       ,
	total                INT       ,
	id_utilisateur       INT       ,
	addresse             VARCHAR(255)       ,
	sous_total           DECIMAL(10,2)       ,
	tarif_livraison      DECIMAL(10,2)       ,
	date_commande        DATE       ,
	id_produit           INT       ,
	CONSTRAINT unq_commande_id UNIQUE ( id ) 
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_commande_livraison ON plastikoo2.commande ( id_type_livraison );

CREATE INDEX fk_commande_utilisateur ON plastikoo2.commande ( id_utilisateur );

CREATE  TABLE plastikoo2.contact_forms ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	nom                  VARCHAR(255)       ,
	prenom               VARCHAR(255)       ,
	email                VARCHAR(255)       ,
	id_type_contact      INT       ,
	message              VARCHAR(255)       
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_contact_forms_type_contact ON plastikoo2.contact_forms ( id_type_contact );

CREATE  TABLE plastikoo2.machine_recolte ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	designation          VARCHAR(255)       ,
	id_type_plastique    INT       ,
	capacite_stockage    DOUBLE  DEFAULT '0'  NOT NULL   ,
	lieu                 VARCHAR(255)  DEFAULT 'Aucun'     
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_machine_recolte_type_plastique ON plastikoo2.machine_recolte ( id_type_plastique );

CREATE INDEX idx_mr_designation ON plastikoo2.machine_recolte ( designation );

CREATE  TABLE plastikoo2.produit ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	designation          VARCHAR(255)       ,
	description          TEXT       ,
	id_cat               INT       ,
	img                  VARCHAR(255)       ,
	prix_vente           DECIMAL(10,2)       ,
	qte_kg               DOUBLE       ,
	id_type_plastique    INT       
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_produit_categorie ON plastikoo2.produit ( id_cat );

CREATE INDEX fk_produit_type_plastique ON plastikoo2.produit ( id_type_plastique );

CREATE  TABLE plastikoo2.publication ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	titre                VARCHAR(255)       ,
	contenu              TEXT       ,
	id_utilisateur       INT       ,
	date_creation        DATETIME  DEFAULT (now())  NOT NULL   ,
	lien                 TEXT       
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_publication_utilisateur ON plastikoo2.publication ( id_utilisateur );

CREATE  TABLE plastikoo2.publication_valide ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	id_utilisateur       INT       ,
	id_publication       INT       ,
	date_validation      DATE  DEFAULT (curdate())     
 ) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_publication_valide_utilisateur ON plastikoo2.publication_valide ( id_utilisateur );

CREATE INDEX fk_publication_valide_publication ON plastikoo2.publication_valide ( id_publication );

CREATE  TABLE plastikoo2.reaction_pub ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	est_reagi            ENUM('oui','non')  DEFAULT 'non'     ,
	date_creation        DATETIME  DEFAULT (now())  NOT NULL   ,
	id_publication       INT       ,
	id_utilisateur       INT       
 ) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_reaction_publication_utilisateur ON plastikoo2.reaction_pub ( id_utilisateur );

CREATE INDEX fk_reaction_to_publication ON plastikoo2.reaction_pub ( id_publication );

CREATE  TABLE plastikoo2.service ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	libelle              VARCHAR(255)       ,
	commission_plastikoo DOUBLE  DEFAULT (0)     ,
	commission_service   DOUBLE  DEFAULT (0)     ,
	min_som_requis       DECIMAL(10,2)  DEFAULT (0)  NOT NULL   ,
	max_som_requis       DECIMAL(10,2)  DEFAULT (0)     ,
	duree_jour_valide    INT  DEFAULT (0)  NOT NULL   ,
	id_type_service      INT       ,
	url_logo             VARCHAR(255)       
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_service_type_service ON plastikoo2.service ( id_type_service );

CREATE INDEX idx_libelle ON plastikoo2.service ( libelle );

CREATE  TABLE plastikoo2.signet_pub ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	id_publication       INT       ,
	id_utilisateur       INT       ,
	date_creation        DATE  DEFAULT (curdate())  NOT NULL   
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_signet_to_publication ON plastikoo2.signet_pub ( id_publication );

CREATE INDEX fk_signet_publication_utilisateur ON plastikoo2.signet_pub ( id_utilisateur );

CREATE  TABLE plastikoo2.stock ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	qte_kg_entrant       DOUBLE       ,
	qte_kg_sortant       DOUBLE       ,
	date_mouvement       DATE       ,
	id_machine_recolte   INT       ,
	reference            VARCHAR(255)       ,
	nbr_utilisateur      INT  DEFAULT (0)  NOT NULL   
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_stock_machine_recolte ON plastikoo2.stock ( id_machine_recolte );

CREATE  TABLE plastikoo2.ticket ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	montant              DECIMAL(10,2)  DEFAULT (0)  NOT NULL   ,
	code_recolte         VARCHAR(6)       ,
	date_creation        TIMESTAMP  DEFAULT (now())  NOT NULL   ,
	date_utilisation     TIMESTAMP       ,
	id_machine_recolte   INT    NOT NULL   ,
	est_utilise          BOOLEAN  DEFAULT (false)  NOT NULL   
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_ticket_machine_recolte ON plastikoo2.ticket ( id_machine_recolte );

CREATE  TABLE plastikoo2.transaction ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	montant              DECIMAL(10,2)       ,
	reference            VARCHAR(255)       ,
	id_utilisateur       INT       ,
	id_machine_recolte   INT       ,
	date_transaction     DATETIME  DEFAULT (now())  NOT NULL   ,
	numero_beneficiaire  VARCHAR(13)       ,
	numero_expediteur    VARCHAR(13)       ,
	id_service           INT       ,
	id_type_transaction  INT       ,
	commission_service   DOUBLE  DEFAULT (0)  NOT NULL   ,
	commission_plastikoo DOUBLE  DEFAULT (0)  NOT NULL   
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_transaction_utilisateur ON plastikoo2.transaction ( id_utilisateur );

CREATE INDEX fk_transaction_machine_recolte ON plastikoo2.transaction ( id_machine_recolte );

CREATE INDEX fk_transaction_type_transaction ON plastikoo2.transaction ( id_type_transaction );

CREATE INDEX fk_transaction_service ON plastikoo2.transaction ( id_service );

CREATE INDEX idx_date_transaction ON plastikoo2.transaction ( date_transaction );

CREATE INDEX idx_num_benificiaire ON plastikoo2.transaction ( numero_beneficiaire );

CREATE INDEX idx_num_expediteur ON plastikoo2.transaction ( numero_expediteur );

CREATE INDEX idx_transaction_reference ON plastikoo2.transaction ( reference );

CREATE  TABLE plastikoo2.bon_achat ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	code_barre           VARCHAR(255)  DEFAULT 'XXXXXXXXXXXXX'  NOT NULL   ,
	date_exp             DATE    NOT NULL   ,
	date_creation        DATE  DEFAULT (curdate())  NOT NULL   ,
	id_transaction       INT       ,
	etat                 ENUM('cree','en cours','utilise')  DEFAULT 'cree'     
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_bon_achat_transaction ON plastikoo2.bon_achat ( id_transaction );

CREATE INDEX idx_bon_achat_etat ON plastikoo2.bon_achat ( etat );

CREATE  TABLE plastikoo2.commentaire_pub ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	contenu              TEXT       ,
	id_utilisateur       INT       ,
	id_publication       INT       ,
	date_creation        DATE  DEFAULT (curdate())  NOT NULL   ,
	id_main_commentaire  INT       
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_commentaire_to_publication ON plastikoo2.commentaire_pub ( id_publication );

CREATE INDEX fk_commentaire_publication_utilisateur ON plastikoo2.commentaire_pub ( id_utilisateur );

CREATE INDEX fk_main_child_commentaire ON plastikoo2.commentaire_pub ( id_main_commentaire );

CREATE  TABLE plastikoo2.details_commande ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	id_commande          INT       ,
	id_produit           INT       ,
	qte                  INT       ,
	prix_vente           DECIMAL(10,2)       
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_details_commande_commande ON plastikoo2.details_commande ( id_commande );

CREATE INDEX fk_details_commande_produit ON plastikoo2.details_commande ( id_produit );

CREATE  TABLE plastikoo2.details_produit ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	id_produit           INT       ,
	id_produit_comp      INT       ,
	nbr                  INT       
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_details_produit_produit ON plastikoo2.details_produit ( id_produit );

CREATE INDEX fk_produit_composant ON plastikoo2.details_produit ( id_produit_comp );

CREATE  TABLE plastikoo2.paiement ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	id_commande          INT       ,
	montant_paye         DECIMAL(10,2)       ,
	date_paiement        DATE       ,
	id_service           INT       
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_paiement_commande ON plastikoo2.paiement ( id_commande );

CREATE INDEX fk_paiement_service ON plastikoo2.paiement ( id_service );

CREATE  TABLE plastikoo2.panier ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	reference            VARCHAR(255)       ,
	id_utilisateur       INT       ,
	id_produit           INT       ,
	qte                  INT       
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_panier_utilisateur ON plastikoo2.panier ( id_utilisateur );

CREATE INDEX fk_panier_produit ON plastikoo2.panier ( id_produit );

CREATE  TABLE plastikoo2.photo_publication ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	img_url              VARCHAR(255)       ,
	img_alt              VARCHAR(255)       ,
	id_publication       INT       
 ) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_photo_publication_publication ON plastikoo2.photo_publication ( id_publication );

ALTER TABLE plastikoo2.bon_achat ADD CONSTRAINT fk_bon_achat_transaction FOREIGN KEY ( id_transaction ) REFERENCES plastikoo2.transaction( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.commande ADD CONSTRAINT fk_commande_livraison FOREIGN KEY ( id_type_livraison ) REFERENCES plastikoo2.livraison( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.commande ADD CONSTRAINT fk_commande_utilisateur FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.commentaire_pub ADD CONSTRAINT fk_commentaire_publication_utilisateur FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.commentaire_pub ADD CONSTRAINT fk_commentaire_to_publication FOREIGN KEY ( id_publication ) REFERENCES plastikoo2.publication( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.commentaire_pub ADD CONSTRAINT fk_main_child_commentaire FOREIGN KEY ( id_main_commentaire ) REFERENCES plastikoo2.commentaire_pub( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.contact_forms ADD CONSTRAINT fk_contact_forms_type_contact FOREIGN KEY ( id_type_contact ) REFERENCES plastikoo2.type_contact( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.details_commande ADD CONSTRAINT fk_details_commande_commande FOREIGN KEY ( id_commande ) REFERENCES plastikoo2.commande( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.details_commande ADD CONSTRAINT fk_details_commande_produit FOREIGN KEY ( id_produit ) REFERENCES plastikoo2.produit( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.details_produit ADD CONSTRAINT fk_details_produit_produit FOREIGN KEY ( id_produit ) REFERENCES plastikoo2.produit( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.details_produit ADD CONSTRAINT fk_produit_composant FOREIGN KEY ( id_produit_comp ) REFERENCES plastikoo2.produit( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.machine_recolte ADD CONSTRAINT fk_machine_recolte_type_plastique FOREIGN KEY ( id_type_plastique ) REFERENCES plastikoo2.type_plastique( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.paiement ADD CONSTRAINT fk_paiement_commande FOREIGN KEY ( id_commande ) REFERENCES plastikoo2.commande( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.paiement ADD CONSTRAINT fk_paiement_service FOREIGN KEY ( id_service ) REFERENCES plastikoo2.service( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.panier ADD CONSTRAINT fk_panier_produit FOREIGN KEY ( id_produit ) REFERENCES plastikoo2.produit( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.panier ADD CONSTRAINT fk_panier_utilisateur FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.photo_publication ADD CONSTRAINT fk_photo_publication_publication FOREIGN KEY ( id_publication ) REFERENCES plastikoo2.publication( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.produit ADD CONSTRAINT fk_produit_categorie FOREIGN KEY ( id_cat ) REFERENCES plastikoo2.categorie( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.produit ADD CONSTRAINT fk_produit_type_plastique FOREIGN KEY ( id_type_plastique ) REFERENCES plastikoo2.type_plastique( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.publication ADD CONSTRAINT fk_publication_utilisateur FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.publication_valide ADD CONSTRAINT fk_publication_valide_publication FOREIGN KEY ( id_publication ) REFERENCES plastikoo2.publication( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.publication_valide ADD CONSTRAINT fk_publication_valide_utilisateur FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.reaction_pub ADD CONSTRAINT fk_reaction_publication_utilisateur FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.reaction_pub ADD CONSTRAINT fk_reaction_to_publication FOREIGN KEY ( id_publication ) REFERENCES plastikoo2.publication( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.service ADD CONSTRAINT fk_service_type_service FOREIGN KEY ( id_type_service ) REFERENCES plastikoo2.type_service( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.signet_pub ADD CONSTRAINT fk_signet_publication_utilisateur FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.signet_pub ADD CONSTRAINT fk_signet_to_publication FOREIGN KEY ( id_publication ) REFERENCES plastikoo2.publication( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.stock ADD CONSTRAINT fk_stock_machine_recolte FOREIGN KEY ( id_machine_recolte ) REFERENCES plastikoo2.machine_recolte( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.ticket ADD CONSTRAINT fk_ticket_machine_recolte FOREIGN KEY ( id_machine_recolte ) REFERENCES plastikoo2.machine_recolte( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.transaction ADD CONSTRAINT fk_transaction_machine_recolte FOREIGN KEY ( id_machine_recolte ) REFERENCES plastikoo2.machine_recolte( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.transaction ADD CONSTRAINT fk_transaction_service FOREIGN KEY ( id_service ) REFERENCES plastikoo2.service( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.transaction ADD CONSTRAINT fk_transaction_type_transaction FOREIGN KEY ( id_type_transaction ) REFERENCES plastikoo2.type_transaction( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.transaction ADD CONSTRAINT fk_transaction_utilisateur FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.utilisateur_role ADD CONSTRAINT fk_utilisateur_role_role FOREIGN KEY ( id_role ) REFERENCES plastikoo2.role( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE plastikoo2.utilisateur_role ADD CONSTRAINT fk_utilisateur_role_utilisateur FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

DELIMITER // 
CREATE  FUNCTION `generate_code_barre`() RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    RETURN CONCAT('', FLOOR(RAND() * 9000000000000) + 1000000000000, '');
END;
// DELIMITER

DELIMITER // 
CREATE  FUNCTION `generate_code_recolte`() RETURNS varchar(6) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE random_code VARCHAR(6);
    DECLARE is_unique BOOLEAN DEFAULT FALSE;

    -- Loop until a unique code is found
    WHILE is_unique = FALSE DO
        -- Generate a random 6-digit code
        SET random_code = LPAD(FLOOR(RAND() * 1000000), 6, '0');

        -- Check if the code already exists in the table
        IF NOT EXISTS (SELECT 1 FROM ticket WHERE code_recolte = random_code) THEN
            SET is_unique = TRUE;
        END IF;
    END WHILE;

    RETURN random_code;
END;
// DELIMITER

DELIMITER// 
CREATE  FUNCTION `generate_reference_ba`() RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    RETURN CONCAT('BA', FLOOR(RAND() * 900000000) + 100000000, '', DATE_FORMAT(NOW(), '%y%m%d%h%m%s'));
END;
// DELIMITER


DELIMITER //
CREATE  FUNCTION `generate_reference_recolte`() RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    RETURN CONCAT('RCLT', FLOOR(RAND() * 900000000) + 100000000, '', DATE_FORMAT(NOW(), '%y%m%d%h%m%s'));
END;
// DELIMITER



CREATE  FUNCTION `generate_reference_retrait`() RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
  RETURN CONCAT('RTT', FLOOR(RAND() * 900000000) + 100000000, '', DATE_FORMAT(NOW(), '%y%m%d%h%m%s'));
END;

CREATE  PROCEDURE `creerTicket`(IN p_montant DECIMAL(10,2), in p_id_machine_recolte INT)
BEGIN
    DECLARE id_ticket INT;

    START TRANSACTION;

    INSERT INTO ticket (montant, code_recolte, id_machine_recolte) VALUES (p_montant, (select generate_code_recolte()), p_id_machine_recolte);
    set id_ticket = LAST_INSERT_ID();
    
    COMMIT;
    select id_ticket;

END;

CREATE  PROCEDURE `creer_ba`(IN id_utilisateur int, IN id_serv int,IN montant DECIMAL(10,2), IN com_plastikoo DOUBLE, IN duree_exp int)
BEGIN
    DECLARE ref_ba VARCHAR(255);
    DECLARE id_user INT;
    DECLARE id_type_trans INT;
    DECLARE date_exp DATE;
    DECLARE id_mr INT;
    DECLARE id_transaction INT;
    DECLARE id_type_transaction INT;
    DECLARE solde_init DECIMAL(10,2);
    DECLARE solde_final DECIMAL(10,2);

    SELECT u.id, s.id, mr.id,tt.id,u.solde
    INTO id_user, id_serv, id_mr,id_type_transaction, solde_init
    FROM utilisateur u
    INNER JOIN service s ON s.id = id_serv
    INNER JOIN machine_recolte mr ON mr.designation = 'No machine'
    INNER JOIN type_transaction tt on tt.type_transaction = 'Bon d''achat'
    WHERE u.id = id_utilisateur;

    call verifier_solde(id_utilisateur,montant);

    SET ref_ba = generate_reference_ba();
    SET date_exp = DATE_ADD(CURDATE(), INTERVAL duree_exp DAY);

    START TRANSACTION;

    INSERT INTO transaction (id_utilisateur, montant, reference, id_service, id_type_transaction, id_machine_recolte, commission_plastikoo)
    VALUES (id_user, montant,ref_ba, id_serv, id_type_transaction, id_mr, com_plastikoo);

    SELECT id INTO id_transaction FROM transaction WHERE reference = ref_ba;

    INSERT INTO bon_achat (id_transaction,code_barre, date_exp)
    VALUES (id_transaction, generate_code_barre(),date_exp);

    set solde_final = (solde_init - montant);
    update utilisateur set solde = solde_final where id = id_utilisateur;
    
    COMMIT;
    select id_transaction;

END;

CREATE  PROCEDURE `inscrireUtilisateur`(
    IN p_nom VARCHAR(255),
    IN p_prenom VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_mot_de_passe VARCHAR(255),
    IN p_date_naissance DATE
)
BEGIN
    call verifierEmailMdp (p_email, p_mot_de_passe);  
   
    INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, date_naissance) 
    VALUES (p_nom, p_prenom, p_email, p_mot_de_passe, p_date_naissance);

    SELECT u.id 
    INTO @id_utilisateur
    FROM utilisateur u  
    WHERE u.email = p_email 
    AND u.mot_de_passe = p_mot_de_passe
    AND u.nom = p_nom 
    AND u.prenom = p_prenom 
    AND u.date_naissance = p_date_naissance 
    LIMIT 1;
    
    select r.id into @id_role from role r where r.designation = 'utilisateur' limit 1;

    INSERT INTO utilisateur_role (id_utilisateur, id_role) VALUES 
    (@id_utilisateur, @id_role);

    select @id_utilisateur as id;
END;

CREATE  PROCEDURE `reagirPublication`(
    IN p_id_publication INT,
    IN p_id_utilisateur INT
)
BEGIN
    -- Check if the user has already reacted to the publication
    IF EXISTS (
        SELECT 1
        FROM reaction_pub
        WHERE id_publication = p_id_publication
        AND id_utilisateur = p_id_utilisateur
    ) THEN
        -- If the user has reacted, delete the reaction
        DELETE FROM reaction_pub
        WHERE id_publication = p_id_publication
        AND id_utilisateur = p_id_utilisateur;
        select -1 est_utilise;
    ELSE
        -- If the user has not reacted, insert the reaction
        INSERT INTO reaction_pub (est_reagi, id_publication, id_utilisateur)
        VALUES ('oui', p_id_publication, p_id_utilisateur);
        select 1 est_utilise;
    END IF;
END;

CREATE  PROCEDURE `recolte_ticket`(IN id_ticket INT, IN id_user INT)
BEGIN
    DECLARE ticket_montant DECIMAL(10,2);
    DECLARE machine_recolte_id INT;
    DECLARE service_id INT;
    DECLARE transaction_type_id INT;
    DECLARE v_ref_rclt VARCHAR(255);
    DECLARE initial_balance DECIMAL(10,2);
    DECLARE final_balance DECIMAL(10,2);
    DECLARE ticket_used_count INT;

    -- Start the transaction
    START TRANSACTION;

    -- Check if the ticket has already been used
    SELECT COUNT(id) INTO ticket_used_count 
    FROM ticket 
    WHERE id = id_ticket AND est_utilise = TRUE;

    IF ticket_used_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ce ticket est déjà expiré';
    ELSE
        -- Fetch ticket details (amount and machine ID)
        SELECT montant, id_machine_recolte 
        INTO ticket_montant, machine_recolte_id
        FROM ticket 
        WHERE id = id_ticket;

        -- Fetch user and transaction details (service ID, transaction type, initial balance)
        SELECT s.id, tt.id, u.solde
        INTO service_id, transaction_type_id, initial_balance
        FROM utilisateur u
        INNER JOIN type_transaction tt ON tt.type_transaction = 'Recolte'
        INNER JOIN service s ON s.libelle = 'Aucun'
        WHERE u.id = id_user;

        -- Generate the reference code for the transaction
        SET v_ref_rclt = generate_reference_recolte();

        -- Calculate final balance
        SET final_balance = initial_balance + ticket_montant;

        -- Update user's balance
        UPDATE utilisateur 
        SET solde = final_balance 
        WHERE id = id_user;

        -- Insert transaction record
        INSERT INTO transaction (montant, reference, id_type_transaction, id_utilisateur, id_machine_recolte, id_service)
        VALUES (ticket_montant, v_ref_rclt, transaction_type_id, id_user, machine_recolte_id, service_id);

        UPDATE ticket SET est_utilise = true, date_utilisation = (select current_timestamp) where id = id_ticket;
 
    END IF;

    -- Commit the transaction
    COMMIT;
    select ticket_montant as gains;
END;

CREATE  PROCEDURE `recolte_ticket_v1`(IN montant DECIMAL(10,2), IN id_user INT, in id_machine_recolte INT, IN code_rclt varchar(6))
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
    INTO service_id, id_type_transaction, solde_init
    FROM utilisateur u
    INNER JOIN type_transaction tt ON tt.type_transaction = 'Recolte'
    INNER JOIN service s on s.libelle = 'Aucun'
    where u.id = id_user;
  
    SET v_ref_rclt = generate_reference_recolte();
    SET solde_final = solde_init + montant;

    UPDATE utilisateur set solde = solde_final where id = id_user;

    INSERT INTO transaction (code_recolte,montant, reference, id_type_transaction, id_utilisateur, id_machine_recolte, id_service)
    VALUES (code_rclt,montant, v_ref_rclt, id_type_transaction, id_user, id_machine_recolte, service_id);
      
    COMMIT;
END;

CREATE  PROCEDURE `retrait_gains`(IN id_user INT,IN id_serv INT, IN somme DECIMAL(10,2), IN num_benif VARCHAR(13), IN num_exp VARCHAR(13), IN com_serv double)
BEGIN 
   
   select u.solde, tt.id, mr.id into @solde_init, @id_tt, @id_mr 
   from utilisateur u 
   INNER JOIN type_transaction tt on tt.type_transaction = 'Retrait' 
   INNER JOIN machine_recolte mr on mr.designation = 'No machine'
   WHERE u.id = id_user ;

   call verifier_solde(id_user, somme);

   set @ref_retr = generate_reference_retrait();

   INSERT INTO transaction (reference,montant, numero_beneficiaire, numero_expediteur,id_service, id_utilisateur,id_type_transaction,id_machine_recolte,commission_service) 
   VALUES (@ref_retr,somme, num_benif, num_exp, id_serv,id_user, @id_tt,@id_mr, com_serv); 
  
   set @solde_final = @solde_init - somme; 
   UPDATE utilisateur set solde = @solde_final where id = id_user; 

   select t.reference ,t.montant, t.numero_beneficiaire from transaction t where t.reference = @ref_retr; 
END;

CREATE  PROCEDURE `storePublicationPhoto`(
    IN p_titre VARCHAR(255),
    IN p_contenu TEXT,
    IN p_id_utilisateur INT,
    IN p_img_url VARCHAR(255)
)
BEGIN
    
    set @img_alt = LOWER(p_titre);
    -- Start transaction
    START TRANSACTION;
    
    -- Step 1: Insert into the publication table
    INSERT INTO publication (titre, contenu, id_utilisateur, date_creation)
    VALUES (p_titre, p_contenu, p_id_utilisateur, NOW());

    -- Step 2: Get the last inserted ID from the publication table (id of the newly created publication)
    SET @id_publication = LAST_INSERT_ID();

    -- Step 3: Insert into the photo_publication table using the id from the publication
    INSERT INTO photo_publication (img_url, img_alt, id_publication)
    VALUES (p_img_url, @img_alt, @id_publication);

    -- Commit the transaction if everything succeeds
    COMMIT;
END;

CREATE  PROCEDURE `verifierEmailMdp`(
    IN p_email VARCHAR(50),
    IN p_mdp VARCHAR(255)
)
BEGIN
    -- Check if email exists
    IF EXISTS (SELECT 1 FROM utilisateur u WHERE u.email = p_email) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'L''adresse e-mail est déjà utilisée.';
    END IF;

    -- Check if password exists
    IF EXISTS (SELECT 1 FROM utilisateur u WHERE u.mot_de_passe = p_mdp) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Le mot de passe est déjà utilisé.';
    END IF;
END;

CREATE  PROCEDURE `verifier_code_pin`(IN id_utilisateur int, IN cp varchar(4), IN cp_tente_max int, IN cp_tente_delais int)
BEGIN
    DECLARE cp_tente_init INT;
    DECLARE cp_tente_final INT;
    DECLARE cp_timestamp_expire DATETIME;

    SELECT id INTO @user_verify
    FROM utilisateur
    WHERE id = id_utilisateur AND code_pin = cp;

    SELECT cp_tentative, cp_timestamp_exp INTO cp_tente_init, cp_timestamp_expire
    FROM utilisateur
    WHERE id = id_utilisateur;

    SET cp_tente_final = cp_tente_init + 1;
    set @cp_tente_reste = (cp_tente_max - cp_tente_init);
    SET @cpttexp = DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL cp_tente_delais HOUR);

    START TRANSACTION;
    
    IF cp_timestamp_expire > CURRENT_TIMESTAMP() THEN
        set @error_msg = CONCAT('Veuillez patientez jusqu''à ', cp_timestamp_expire);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_msg; 
    ELSEIF @cp_tente_reste < 0 THEN
        UPDATE utilisateur set cp_timestamp_exp = @cpttexp, cp_tentative = 0 where id = id_utilisateur;
        set @error_msg = CONCAT('Vous avez atteint la limite de votre tentative. Veuillez patientez jusqu''à ', @cpttexp);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_msg;
    ELSE
        select @user_verify,@cp_tente_reste, cp_tente_final,cp_tente_init, @cpttexp;
    END IF;

    IF @user_verify IS NULL THEN
        UPDATE utilisateur set cp_tentative = cp_tente_final where id = id_utilisateur;
        set @error_msg = CONCAT( 'Vous avez saisissez un faux code pin. Tentative restante: ', @cp_tente_reste);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_msg;
    END IF;

    COMMIT;
END;

CREATE  PROCEDURE `verifier_solde`(IN id_utilisateur INT, IN montant DECIMAL(10,2))
BEGIN
    DECLARE solde_final DECIMAL(10,2); 
    select solde into @solde_init from utilisateur where id = id_utilisateur; 
    set solde_final = (@solde_init - montant);
    IF solde_final < 0 THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Votre solde est insuffisant pour cette transaction'; 
    END IF; 
END;

ALTER TABLE plastikoo2.transaction MODIFY numero_beneficiaire VARCHAR(13)     COMMENT 's''applique avec le retrait, achat plastikoo';

ALTER TABLE plastikoo2.transaction MODIFY numero_expediteur VARCHAR(13)     COMMENT 's''applique avec le retrait, achat plastikoo';
