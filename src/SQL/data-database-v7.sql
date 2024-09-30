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
 ) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE  TABLE plastikoo2.livraison ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	type_livraison       VARCHAR(255)       ,
	tarif                DECIMAL(10,2)       
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE  TABLE plastikoo2.role ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	designation          VARCHAR(255)    NOT NULL   
 ) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE  TABLE plastikoo2.type_contact ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	intitule             VARCHAR(255)       
 ) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE  TABLE plastikoo2.type_plastique ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	p_type               VARCHAR(255)       
 ) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE  TABLE plastikoo2.type_service ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	type_s               VARCHAR(255)       
 ) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX idx_type_s ON plastikoo2.type_service ( type_s );

CREATE  TABLE plastikoo2.type_transaction ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	type_transaction     VARCHAR(255)       
 ) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX idx_type_transaction ON plastikoo2.type_transaction ( type_transaction );

CREATE  TABLE plastikoo2.utilisateur ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	nom                  VARCHAR(255)       ,
	prenom               VARCHAR(255)       ,
	email                VARCHAR(255)       ,
	pseudo_utilisateur   VARCHAR(255)       ,
	mot_de_passe         VARCHAR(255)       ,
	date_naissance       DATE       ,
	solde                DECIMAL(10,2)  DEFAULT ('0.00')  NOT NULL   ,
	code_pin             VARCHAR(4)  DEFAULT ('_utf8mb4'XXXX'')     ,
	cp_tentative         INT  DEFAULT ('0')  NOT NULL   ,
	cp_timestamp_exp     DATETIME       ,
	url_profil           VARCHAR(255)       ,
	id_google            INT       ,
	img_profil           VARCHAR(255)       ,
	reset_mdp_code       VARCHAR(6)       ,
	reset_mdp_expire     TIMESTAMP       
 ) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX idx_utilisateur_email_mdp ON plastikoo2.utilisateur ( email, mot_de_passe );

CREATE INDEX idx_utilisateur_infos ON plastikoo2.utilisateur ( nom, prenom, date_naissance );

CREATE  TABLE plastikoo2.utilisateur_role ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	id_utilisateur       INT       ,
	id_role              INT       ,
	CONSTRAINT fk_utilisateur_role_role FOREIGN KEY ( id_role ) REFERENCES plastikoo2.role( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_utilisateur_role_utilisateur FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE CASCADE ON UPDATE NO ACTION
 ) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
	CONSTRAINT unq_commande_id UNIQUE ( id ) ,
	CONSTRAINT fk_commande_livraison FOREIGN KEY ( id_type_livraison ) REFERENCES plastikoo2.livraison( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_commande_utilisateur FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_commande_livraison ON plastikoo2.commande ( id_type_livraison );

CREATE INDEX fk_commande_utilisateur ON plastikoo2.commande ( id_utilisateur );

CREATE  TABLE plastikoo2.contact_forms ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	nom                  VARCHAR(255)       ,
	prenom               VARCHAR(255)       ,
	email                VARCHAR(255)       ,
	id_type_contact      INT       ,
	message              VARCHAR(255)       ,
	CONSTRAINT fk_contact_forms_type_contact FOREIGN KEY ( id_type_contact ) REFERENCES plastikoo2.type_contact( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_contact_forms_type_contact ON plastikoo2.contact_forms ( id_type_contact );

CREATE  TABLE plastikoo2.machine_recolte ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	designation          VARCHAR(255)       ,
	id_type_plastique    INT       ,
	capacite_stockage    DOUBLE  DEFAULT ('0')  NOT NULL   ,
	lieu                 VARCHAR(255)  DEFAULT ('Aucun')     ,
	CONSTRAINT fk_machine_recolte_type_plastique FOREIGN KEY ( id_type_plastique ) REFERENCES plastikoo2.type_plastique( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
	id_type_plastique    INT       ,
	CONSTRAINT fk_produit_categorie FOREIGN KEY ( id_cat ) REFERENCES plastikoo2.categorie( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_produit_type_plastique FOREIGN KEY ( id_type_plastique ) REFERENCES plastikoo2.type_plastique( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_produit_categorie ON plastikoo2.produit ( id_cat );

CREATE INDEX fk_produit_type_plastique ON plastikoo2.produit ( id_type_plastique );

CREATE  TABLE plastikoo2.publication ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	titre                VARCHAR(255)       ,
	contenu              TEXT       ,
	id_utilisateur       INT       ,
	date_creation        DATETIME  DEFAULT (now())  NOT NULL   ,
	lien                 TEXT       ,
	CONSTRAINT fk_publication_utilisateur FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_publication_utilisateur ON plastikoo2.publication ( id_utilisateur );

CREATE  TABLE plastikoo2.publication_valide ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	id_utilisateur       INT       ,
	id_publication       INT       ,
	date_validation      DATE  DEFAULT (curdate())     ,
	CONSTRAINT fk_publication_valide_publication FOREIGN KEY ( id_publication ) REFERENCES plastikoo2.publication( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_publication_valide_utilisateur FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_publication_valide_utilisateur ON plastikoo2.publication_valide ( id_utilisateur );

CREATE INDEX fk_publication_valide_publication ON plastikoo2.publication_valide ( id_publication );

CREATE  TABLE plastikoo2.reaction_pub ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	est_reagi            ENUM('oui','non')  DEFAULT ('non')     ,
	date_creation        DATETIME  DEFAULT (now())  NOT NULL   ,
	id_publication       INT       ,
	id_utilisateur       INT       ,
	CONSTRAINT fk_reaction_publication_utilisateur FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_reaction_to_publication FOREIGN KEY ( id_publication ) REFERENCES plastikoo2.publication( id ) ON DELETE CASCADE ON UPDATE NO ACTION
 ) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
	url_logo             VARCHAR(255)       ,
	CONSTRAINT fk_service_type_service FOREIGN KEY ( id_type_service ) REFERENCES plastikoo2.type_service( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_service_type_service ON plastikoo2.service ( id_type_service );

CREATE INDEX idx_libelle ON plastikoo2.service ( libelle );

CREATE  TABLE plastikoo2.signet_pub ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	id_publication       INT       ,
	id_utilisateur       INT       ,
	date_creation        DATE  DEFAULT (curdate())  NOT NULL   ,
	CONSTRAINT fk_signet_publication_utilisateur FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_signet_to_publication FOREIGN KEY ( id_publication ) REFERENCES plastikoo2.publication( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
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
	nbr_utilisateur      INT  DEFAULT (0)  NOT NULL   ,
	CONSTRAINT fk_stock_machine_recolte FOREIGN KEY ( id_machine_recolte ) REFERENCES plastikoo2.machine_recolte( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_stock_machine_recolte ON plastikoo2.stock ( id_machine_recolte );

CREATE  TABLE plastikoo2.ticket ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	montant              DECIMAL(10,2)  DEFAULT (0)  NOT NULL   ,
	code_recolte         VARCHAR(6)       ,
	date_creation        TIMESTAMP  DEFAULT (now())  NOT NULL   ,
	date_utilisation     TIMESTAMP       ,
	id_machine_recolte   INT    NOT NULL   ,
	est_utilise          BOOLEAN  DEFAULT (false)  NOT NULL   ,
	CONSTRAINT fk_ticket_machine_recolte FOREIGN KEY ( id_machine_recolte ) REFERENCES plastikoo2.machine_recolte( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
	commission_plastikoo DOUBLE  DEFAULT (0)  NOT NULL   ,
	CONSTRAINT fk_transaction_machine_recolte FOREIGN KEY ( id_machine_recolte ) REFERENCES plastikoo2.machine_recolte( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_transaction_service FOREIGN KEY ( id_service ) REFERENCES plastikoo2.service( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_transaction_type_transaction FOREIGN KEY ( id_type_transaction ) REFERENCES plastikoo2.type_transaction( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_transaction_utilisateur FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
	code_barre           VARCHAR(255)  DEFAULT ('XXXXXXXXXXXXX')  NOT NULL   ,
	date_exp             DATE    NOT NULL   ,
	date_creation        DATE  DEFAULT (curdate())  NOT NULL   ,
	id_transaction       INT       ,
	etat                 ENUM('cree','en cours','utilise')  DEFAULT ('_utf8mb4'cree'')     ,
	CONSTRAINT fk_bon_achat_transaction FOREIGN KEY ( id_transaction ) REFERENCES plastikoo2.transaction( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_bon_achat_transaction ON plastikoo2.bon_achat ( id_transaction );

CREATE INDEX idx_bon_achat_etat ON plastikoo2.bon_achat ( etat );

CREATE  TABLE plastikoo2.commentaire_pub ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	contenu              TEXT       ,
	id_utilisateur       INT       ,
	id_publication       INT       ,
	date_creation        DATE  DEFAULT (curdate())  NOT NULL   ,
	id_main_commentaire  INT       ,
	CONSTRAINT fk_commentaire_publication_utilisateur FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_commentaire_to_publication FOREIGN KEY ( id_publication ) REFERENCES plastikoo2.publication( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_main_child_commentaire FOREIGN KEY ( id_main_commentaire ) REFERENCES plastikoo2.commentaire_pub( id ) ON DELETE CASCADE ON UPDATE NO ACTION
 ) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_commentaire_to_publication ON plastikoo2.commentaire_pub ( id_publication );

CREATE INDEX fk_commentaire_publication_utilisateur ON plastikoo2.commentaire_pub ( id_utilisateur );

CREATE INDEX fk_main_child_commentaire ON plastikoo2.commentaire_pub ( id_main_commentaire );

CREATE  TABLE plastikoo2.details_commande ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	id_commande          INT       ,
	id_produit           INT       ,
	qte                  INT       ,
	prix_vente           DECIMAL(10,2)       ,
	CONSTRAINT fk_details_commande_commande FOREIGN KEY ( id_commande ) REFERENCES plastikoo2.commande( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_details_commande_produit FOREIGN KEY ( id_produit ) REFERENCES plastikoo2.produit( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_details_commande_commande ON plastikoo2.details_commande ( id_commande );

CREATE INDEX fk_details_commande_produit ON plastikoo2.details_commande ( id_produit );

CREATE  TABLE plastikoo2.details_produit ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	id_produit           INT       ,
	id_produit_comp      INT       ,
	nbr                  INT       ,
	CONSTRAINT fk_details_produit_produit FOREIGN KEY ( id_produit ) REFERENCES plastikoo2.produit( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_produit_composant FOREIGN KEY ( id_produit_comp ) REFERENCES plastikoo2.produit( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_details_produit_produit ON plastikoo2.details_produit ( id_produit );

CREATE INDEX fk_produit_composant ON plastikoo2.details_produit ( id_produit_comp );

CREATE  TABLE plastikoo2.paiement ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	id_commande          INT       ,
	montant_paye         DECIMAL(10,2)       ,
	date_paiement        DATE       ,
	id_service           INT       ,
	CONSTRAINT fk_paiement_commande FOREIGN KEY ( id_commande ) REFERENCES plastikoo2.commande( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_paiement_service FOREIGN KEY ( id_service ) REFERENCES plastikoo2.service( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_paiement_commande ON plastikoo2.paiement ( id_commande );

CREATE INDEX fk_paiement_service ON plastikoo2.paiement ( id_service );

CREATE  TABLE plastikoo2.panier ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	reference            VARCHAR(255)       ,
	id_utilisateur       INT       ,
	id_produit           INT       ,
	qte                  INT       ,
	CONSTRAINT fk_panier_produit FOREIGN KEY ( id_produit ) REFERENCES plastikoo2.produit( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_panier_utilisateur FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_panier_utilisateur ON plastikoo2.panier ( id_utilisateur );

CREATE INDEX fk_panier_produit ON plastikoo2.panier ( id_produit );

CREATE  TABLE plastikoo2.photo_publication ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	img_url              VARCHAR(255)       ,
	img_alt              VARCHAR(255)       ,
	id_publication       INT       ,
	CONSTRAINT fk_photo_publication_publication FOREIGN KEY ( id_publication ) REFERENCES plastikoo2.publication( id ) ON DELETE CASCADE ON UPDATE NO ACTION
 ) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_photo_publication_publication ON plastikoo2.photo_publication ( id_publication );

CREATE  FUNCTION `generate_code_barre`() RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    RETURN CONCAT('', FLOOR(RAND() * 9000000000000) + 1000000000000, '');
END;

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

CREATE  FUNCTION `generate_reference_ba`() RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    RETURN CONCAT('BA', FLOOR(RAND() * 900000000) + 100000000, '', DATE_FORMAT(NOW(), '%y%m%d%h%m%s'));
END;

CREATE  FUNCTION `generate_reference_recolte`() RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    RETURN CONCAT('RCLT', FLOOR(RAND() * 900000000) + 100000000, '', DATE_FORMAT(NOW(), '%y%m%d%h%m%s'));
END;

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

CREATE  PROCEDURE `creer_ba`(IN id_utilisateur int, IN id_serv int)
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
    DECLARE duree_exp INT;
    DECLARE montant DECIMAL(10,2);
    DECLARE com_plastikoo DOUBLE;

    SELECT u.id, s.id, mr.id,tt.id,u.solde, u.solde, s.commission_plastikoo, s.duree_jour_valide
    INTO id_user, id_serv, id_mr,id_type_transaction, solde_init, montant,com_plastikoo, duree_exp
    FROM utilisateur u
    INNER JOIN service s ON s.id = id_serv
    INNER JOIN machine_recolte mr ON mr.designation = 'No machine'
    INNER JOIN type_transaction tt on tt.type_transaction = 'Bon d''achat'
    WHERE u.id = id_utilisateur;

    call verifier_solde(id_utilisateur,id_serv,montant);

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

    select @id_utilisateur as id_utilisateur;

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

   call verifier_solde(id_user, id_serv,somme);

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
        select 1 est_verfie;
    END IF;

    IF @user_verify IS NULL THEN
        UPDATE utilisateur set cp_tentative = cp_tente_final where id = id_utilisateur;
        set @error_msg = CONCAT( 'Vous avez saisissez un faux code pin. Tentative restante: ', @cp_tente_reste);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_msg;
    END IF;

    COMMIT;
END;

CREATE  PROCEDURE `verifier_solde`(IN id_utilisateur INT, IN id_service INT, IN montant DECIMAL(10,2))
BEGIN
    DECLARE solde_final DECIMAL(10,2);
 
    select u.solde , s.min_som_requis, s.max_som_requis into @solde_init, @min_requis, @max_requis 
    from utilisateur u 
    inner join service s on s.id = id_service 
    where u.id = id_utilisateur;
  
    set solde_final = (@solde_init - montant);
    IF solde_final < 0 THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Votre solde est insuffisant pour cette transaction'; 
    END IF; 

    IF @solde_init <= @min_requis THEN
        set @error_msg = CONCAT('Le solde requis devrait etre supérieur ou égale ', @min_requis,'Ar');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @error_msg;
    END IF;
END;

ALTER TABLE plastikoo2.transaction MODIFY numero_beneficiaire VARCHAR(13)     COMMENT 's''applique avec le retrait, achat plastikoo';

ALTER TABLE plastikoo2.transaction MODIFY numero_expediteur VARCHAR(13)     COMMENT 's''applique avec le retrait, achat plastikoo';

INSERT INTO plastikoo2.categorie( id, type_categorie ) VALUES ( 1, 'Recyclable');
INSERT INTO plastikoo2.categorie( id, type_categorie ) VALUES ( 2, 'Non Recyclable');
INSERT INTO plastikoo2.categorie( id, type_categorie ) VALUES ( 3, 'Bioplastique');
INSERT INTO plastikoo2.role( id, designation ) VALUES ( 1, 'administrateur');
INSERT INTO plastikoo2.role( id, designation ) VALUES ( 2, 'moderateur');
INSERT INTO plastikoo2.role( id, designation ) VALUES ( 3, 'utilisateur');
INSERT INTO plastikoo2.type_contact( id, intitule ) VALUES ( 4, 'Nos partenaire');
INSERT INTO plastikoo2.type_contact( id, intitule ) VALUES ( 5, 'Nos clients');
INSERT INTO plastikoo2.type_contact( id, intitule ) VALUES ( 6, 'Nos collaborateur');
INSERT INTO plastikoo2.type_plastique( id, p_type ) VALUES ( 1, 'LDPE');
INSERT INTO plastikoo2.type_plastique( id, p_type ) VALUES ( 2, 'HDPE');
INSERT INTO plastikoo2.type_plastique( id, p_type ) VALUES ( 3, 'PP');
INSERT INTO plastikoo2.type_plastique( id, p_type ) VALUES ( 4, 'PET');
INSERT INTO plastikoo2.type_plastique( id, p_type ) VALUES ( 9, 'No plastique');
INSERT INTO plastikoo2.type_service( id, type_s ) VALUES ( 2, 'Operateur');
INSERT INTO plastikoo2.type_service( id, type_s ) VALUES ( 1, 'Partenariat');
INSERT INTO plastikoo2.type_service( id, type_s ) VALUES ( 3, 'socio-environnemental');
INSERT INTO plastikoo2.type_transaction( id, type_transaction ) VALUES ( 4, 'Achat Plastikoo');
INSERT INTO plastikoo2.type_transaction( id, type_transaction ) VALUES ( 3, 'Bon d''achat');
INSERT INTO plastikoo2.type_transaction( id, type_transaction ) VALUES ( 2, 'Recolte');
INSERT INTO plastikoo2.type_transaction( id, type_transaction ) VALUES ( 1, 'Retrait');
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil, id_google, img_profil, reset_mdp_code, reset_mdp_expire ) VALUES ( 1, 'RANDRIANARISON', 'Johns Irintsoa', 'johnsirintsoa18@gmail.com', 'JIrintsoa', '1234Jo', '2002-09-18', 400, '1234', 4, '2024-08-08 04.16.49 PM', null, null, null, null, null);
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil, id_google, img_profil, reset_mdp_code, reset_mdp_expire ) VALUES ( 2, 'Jane', 'Doe', 'jane.doe@example.com', 'janedoe', 'password2', '1991-02-01', 100, '5678', 0, '2025-01-01 02.59.59 AM', null, null, null, null, null);
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil, id_google, img_profil, reset_mdp_code, reset_mdp_expire ) VALUES ( 3, 'Alice', 'Smith', 'alice.smith@example.com', 'alicesmith', 'password3', '1992-03-01', 100, '9101', 0, '2025-01-01 02.59.59 AM', null, null, null, null, null);
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil, id_google, img_profil, reset_mdp_code, reset_mdp_expire ) VALUES ( 4, 'Bob', 'Johnson', 'bob.johnson@example.com', 'bobjohnson', 'password4', '1993-04-01', 100, '1121', 0, '2025-01-01 02.59.59 AM', null, null, null, null, null);
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil, id_google, img_profil, reset_mdp_code, reset_mdp_expire ) VALUES ( 5, 'Charlie', 'Brown', 'charlie.brown@example.com', 'charlieb', 'password5', '1994-05-01', 100, '3141', 0, '2025-01-01 02.59.59 AM', null, null, null, null, null);
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil, id_google, img_profil, reset_mdp_code, reset_mdp_expire ) VALUES ( 6, 'David', 'Davis', 'david.davis@example.com', 'davidd', 'password6', '1995-06-01', 100, '5161', 0, '2025-01-01 02.59.59 AM', null, null, null, null, null);
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil, id_google, img_profil, reset_mdp_code, reset_mdp_expire ) VALUES ( 7, 'Eva', 'Martinez', 'eva.martinez@example.com', 'evam', 'password7', '1996-07-01', 100, '7181', 0, '2025-01-01 02.59.59 AM', null, null, null, null, null);
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil, id_google, img_profil, reset_mdp_code, reset_mdp_expire ) VALUES ( 8, 'Frank', 'Garcia', 'frank.garcia@example.com', 'frankg', 'password8', '1997-08-01', 100, '9201', 0, '2025-01-01 02.59.59 AM', null, null, null, null, null);
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil, id_google, img_profil, reset_mdp_code, reset_mdp_expire ) VALUES ( 9, 'Grace', 'Hernandez', 'grace.hernandez@example.com', 'graceh', 'password9', '1998-09-01', 100, '1223', 0, '2025-01-01 02.59.59 AM', null, null, null, null, null);
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil, id_google, img_profil, reset_mdp_code, reset_mdp_expire ) VALUES ( 10, 'Hank', 'Wilson', 'hank.wilson@example.com', 'hankw', 'password10', '1999-10-01', 100, '3245', 0, '2025-01-01 02.59.59 AM', null, null, null, null, null);
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil, id_google, img_profil, reset_mdp_code, reset_mdp_expire ) VALUES ( 13, 'RAKOTORISON', 'Landry', 'george@gmail.com', 'LAND09', '$2b$10$1MN2QPtoKjsCzJxHyltfPOzpGQ5JbPVwGw/FRLfrE./fdyeSv5Eki', '2000-01-01', 0, '1234', 0, null, null, null, null, null, null);
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil, id_google, img_profil, reset_mdp_code, reset_mdp_expire ) VALUES ( 14, 'RAKOTORISON', 'Landry', 'johns.irintsoa@gmail.com', 'JIrintsoa18', '$2b$10$/AN3G7iWcIFhKiwXqvz8reBB1I38l5LWR1klqV06Xu.465rBhx5UC', '2000-01-01', 50, '7874', 1, null, null, null, 'pseudo-832947425.png', null, null);
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil, id_google, img_profil, reset_mdp_code, reset_mdp_expire ) VALUES ( 23, 'SOA', 'Nirina', 'nirina@gmail.com', null, '$2b$10$ftSCbBFnYS3t21JhDIUlweSS8xMz99ncfftLbTBGqPS22/j9zyYaS', '2002-08-26', 0, 'XXXX', 0, null, null, null, null, null, null);
INSERT INTO plastikoo2.utilisateur_role( id, id_utilisateur, id_role ) VALUES ( 1, 1, 1);
INSERT INTO plastikoo2.utilisateur_role( id, id_utilisateur, id_role ) VALUES ( 2, 1, 3);
INSERT INTO plastikoo2.utilisateur_role( id, id_utilisateur, id_role ) VALUES ( 3, 2, 1);
INSERT INTO plastikoo2.utilisateur_role( id, id_utilisateur, id_role ) VALUES ( 4, 2, 2);
INSERT INTO plastikoo2.utilisateur_role( id, id_utilisateur, id_role ) VALUES ( 5, 3, 3);
INSERT INTO plastikoo2.utilisateur_role( id, id_utilisateur, id_role ) VALUES ( 6, 13, 1);
INSERT INTO plastikoo2.utilisateur_role( id, id_utilisateur, id_role ) VALUES ( 7, 13, 3);
INSERT INTO plastikoo2.utilisateur_role( id, id_utilisateur, id_role ) VALUES ( 8, 14, 3);
INSERT INTO plastikoo2.utilisateur_role( id, id_utilisateur, id_role ) VALUES ( 10, 14, 1);
INSERT INTO plastikoo2.utilisateur_role( id, id_utilisateur, id_role ) VALUES ( 18, 23, 3);
INSERT INTO plastikoo2.contact_forms( id, nom, prenom, email, id_type_contact, message ) VALUES ( 55, 'RAKOTO', 'jean', 'rakoto.nirina@gmail.com', 4, 'Hello world');
INSERT INTO plastikoo2.machine_recolte( id, designation, id_type_plastique, capacite_stockage, lieu ) VALUES ( 1, 'Akoor digue PL001', 3, 200.0, 'Akoor digue');
INSERT INTO plastikoo2.machine_recolte( id, designation, id_type_plastique, capacite_stockage, lieu ) VALUES ( 2, 'Akoor digue PL002', 3, 200.0, 'Akoor digue');
INSERT INTO plastikoo2.machine_recolte( id, designation, id_type_plastique, capacite_stockage, lieu ) VALUES ( 3, 'Jumbo Score PL001', 1, 200.0, 'Jumbo score');
INSERT INTO plastikoo2.machine_recolte( id, designation, id_type_plastique, capacite_stockage, lieu ) VALUES ( 4, 'Jumbo Score PL002', 1, 200.0, 'Jumbo score');
INSERT INTO plastikoo2.machine_recolte( id, designation, id_type_plastique, capacite_stockage, lieu ) VALUES ( 5, 'Stade de Barea PL001', 1, 200.0, 'Stade de Barea');
INSERT INTO plastikoo2.machine_recolte( id, designation, id_type_plastique, capacite_stockage, lieu ) VALUES ( 6, 'Stade de Barea PL002', 1, 200.0, 'Stade de Barea');
INSERT INTO plastikoo2.machine_recolte( id, designation, id_type_plastique, capacite_stockage, lieu ) VALUES ( 7, 'No machine', 9, 0.0, 'Aucun');
INSERT INTO plastikoo2.produit( id, designation, description, id_cat, img, prix_vente, qte_kg, id_type_plastique ) VALUES ( 1, 'Produit B', 'Description du produit B.', 2, 'https://exemple.com/images/produitB.jpg', 29.99, 5.0, 2);
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 1, 'Sustainable Living Tips', 'Content about living sustainably with small changes.', 1, '2024-08-13 12.11.25 PM', 'http://example.com/sustainable-living-tips');
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 2, 'Top 10 Travel Destinations', 'A guide to the top 10 travel destinations for 2024.', 2, '2024-08-13 12.11.25 PM', 'http://example.com/top-10-travel-destinations');
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 3, 'Healthy Eating Habits', 'How to develop healthy eating habits in your daily life.', 3, '2024-08-13 12.11.25 PM', 'http://example.com/healthy-eating-habits');
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 4, 'The Future of Technology', 'Exploring the future trends in technology.', 4, '2024-08-13 12.11.25 PM', 'http://example.com/future-of-technology');
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 5, 'Financial Independence', 'Steps to achieving financial independence.', 5, '2024-08-13 12.11.25 PM', 'http://example.com/financial-independence');
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 6, 'Outdoor Adventures', 'The best outdoor adventures to try in 2024.', 6, '2024-08-13 12.11.25 PM', 'http://example.com/outdoor-adventures');
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 7, 'The Art of Minimalism', 'Understanding and practicing minimalism in life.', 7, '2024-08-13 12.11.25 PM', 'http://example.com/art-of-minimalism');
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 8, 'Fitness Tips for Beginners', 'Essential fitness tips for those just starting out.', 8, '2024-08-13 12.11.25 PM', 'http://example.com/fitness-tips-for-beginners');
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 9, 'Home Gardening 101', 'A beginner’s guide to starting a home garden.', 9, '2024-08-13 12.11.25 PM', 'http://example.com/home-gardening-101');
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 10, 'Digital Nomad Lifestyle', 'What it takes to live a digital nomad lifestyle.', 10, '2024-08-13 12.11.25 PM', 'http://example.com/digital-nomad-lifestyle');
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 11, 'Eco-Friendly Products', 'Review of the best eco-friendly products in 2024.', 1, '2024-08-13 12.11.25 PM', 'http://example.com/eco-friendly-products');
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 12, 'Mindfulness Meditation', 'Benefits and practices of mindfulness meditation.', 2, '2024-08-13 12.11.25 PM', 'http://example.com/mindfulness-meditation');
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 13, 'Investing for Beginners', 'A beginner’s guide to investing in the stock market.', 3, '2024-08-13 12.11.25 PM', 'http://example.com/investing-for-beginners');
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 14, 'Creative Writing Tips', 'How to get started with creative writing.', 4, '2024-08-13 12.11.25 PM', 'http://example.com/creative-writing-tips');
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 15, 'DIY Home Improvement', 'Easy DIY projects to improve your home.', 5, '2024-08-13 12.11.25 PM', 'http://example.com/diy-home-improvement');
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 16, 'Social Media Marketing', 'Effective social media marketing strategies.', 6, '2024-08-13 12.11.25 PM', 'http://example.com/social-media-marketing');
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 17, 'Sustainable Fashion', 'How to make sustainable fashion choices.', 7, '2024-08-13 12.11.25 PM', 'http://example.com/sustainable-fashion');
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 18, 'Remote Work Challenges', 'Overcoming the challenges of remote work.', 8, '2024-08-13 12.11.25 PM', 'http://example.com/remote-work-challenges');
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 19, 'Personal Development Goals', 'Setting and achieving personal development goals.', 9, '2024-08-13 12.11.25 PM', 'http://example.com/personal-development-goals');
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 20, 'Climate Change Awareness', 'Raising awareness about climate change and its impacts.', 10, '2024-08-13 12.11.25 PM', 'http://example.com/climate-change-awareness');
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 21, 'Plastikoo OSC final', 'hellloweijjfofjewofeof', 13, '2024-09-04 04.27.48 AM', 'forum-528891805.png');
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 22, 'Plastikoo OSC final', 'hellloweijjfofjewofeof', 13, '2024-09-05 01.42.19 PM', 'forum-876840768.png');
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 23, 'Plastikoo test 1', 'voici plastikoo voici test 1', 4, '2024-09-05 02.50.23 PM', null);
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 24, 'Plastikoo test 2', 'voici plastikoo voici test 2', 4, '2024-09-05 02.50.56 PM', null);
INSERT INTO plastikoo2.publication( id, titre, contenu, id_utilisateur, date_creation, lien ) VALUES ( 26, 'Plastikoo OSC final', 'hellloweijjfofjewofeof', 13, '2024-09-05 07.40.16 PM', null);
INSERT INTO plastikoo2.publication_valide( id, id_utilisateur, id_publication, date_validation ) VALUES ( 1, 14, 2, '2024-09-04');
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 1, 'oui', '2024-08-16 06.00.48 PM', 1, 1);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 2, 'oui', '2024-08-16 06.00.48 PM', 1, 2);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 3, 'oui', '2024-08-16 06.00.48 PM', 1, 3);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 4, 'oui', '2024-08-16 06.00.48 PM', 1, 4);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 5, 'oui', '2024-08-16 06.00.48 PM', 1, 5);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 6, 'oui', '2024-08-16 06.00.48 PM', 1, 6);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 7, 'oui', '2024-08-16 06.00.48 PM', 1, 7);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 8, 'oui', '2024-08-16 06.00.48 PM', 1, 8);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 9, 'oui', '2024-08-16 06.00.48 PM', 1, 9);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 10, 'oui', '2024-08-16 06.00.48 PM', 1, 10);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 11, 'oui', '2024-08-16 06.01.00 PM', 2, 1);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 12, 'oui', '2024-08-16 06.01.00 PM', 2, 2);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 13, 'oui', '2024-08-16 06.01.00 PM', 2, 3);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 14, 'oui', '2024-08-16 06.01.00 PM', 2, 4);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 15, 'oui', '2024-08-16 06.01.00 PM', 2, 5);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 16, 'oui', '2024-08-16 06.01.00 PM', 2, 6);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 17, 'oui', '2024-08-16 06.01.00 PM', 2, 7);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 18, 'oui', '2024-08-16 06.01.00 PM', 2, 8);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 19, 'oui', '2024-08-16 06.01.00 PM', 2, 9);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 20, 'oui', '2024-08-16 06.01.00 PM', 2, 10);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 21, 'oui', '2024-08-16 06.01.19 PM', 3, 1);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 22, 'oui', '2024-08-16 06.01.19 PM', 3, 2);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 23, 'oui', '2024-08-16 06.01.19 PM', 3, 3);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 24, 'oui', '2024-08-16 06.01.19 PM', 3, 4);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 25, 'oui', '2024-08-16 06.01.19 PM', 3, 5);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 26, 'oui', '2024-08-16 06.01.19 PM', 3, 6);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 27, 'oui', '2024-08-16 06.01.19 PM', 3, 7);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 28, 'oui', '2024-08-16 06.01.19 PM', 3, 8);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 29, 'oui', '2024-08-16 06.01.19 PM', 3, 9);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 30, 'oui', '2024-08-16 06.01.19 PM', 3, 10);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 31, 'oui', '2024-08-16 06.02.55 PM', 4, 1);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 32, 'oui', '2024-08-16 06.02.55 PM', 4, 2);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 33, 'oui', '2024-08-16 06.02.55 PM', 4, 3);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 34, 'oui', '2024-08-16 06.02.55 PM', 4, 4);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 35, 'oui', '2024-08-16 06.02.55 PM', 4, 5);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 36, 'oui', '2024-08-16 06.02.55 PM', 4, 6);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 37, 'oui', '2024-08-16 06.02.55 PM', 4, 7);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 38, 'oui', '2024-08-16 06.02.55 PM', 4, 8);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 39, 'oui', '2024-08-16 06.02.55 PM', 4, 9);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 40, 'oui', '2024-08-16 06.02.55 PM', 4, 10);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 41, 'oui', '2024-08-16 06.03.09 PM', 5, 1);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 42, 'oui', '2024-08-16 06.03.09 PM', 5, 2);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 43, 'oui', '2024-08-16 06.03.09 PM', 5, 3);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 44, 'oui', '2024-08-16 06.03.09 PM', 5, 4);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 45, 'oui', '2024-08-16 06.03.09 PM', 5, 5);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 46, 'oui', '2024-08-16 06.03.09 PM', 5, 6);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 47, 'oui', '2024-08-16 06.03.09 PM', 5, 7);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 48, 'oui', '2024-08-16 06.03.09 PM', 5, 8);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 49, 'oui', '2024-08-16 06.03.09 PM', 5, 9);
INSERT INTO plastikoo2.reaction_pub( id, est_reagi, date_creation, id_publication, id_utilisateur ) VALUES ( 50, 'oui', '2024-08-16 06.03.09 PM', 5, 10);
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service, url_logo ) VALUES ( 1, 'Orange Money', 0.0, 0.2, 5000, 50000, 0, 2, null);
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service, url_logo ) VALUES ( 2, 'Airtel Money', 0.0, 0.2, 5000, 50000, 0, 2, null);
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service, url_logo ) VALUES ( 3, 'Mvola', 0.0, 0.2, 5000, 50000, 0, 2, null);
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service, url_logo ) VALUES ( 4, 'Jumbo', 0.2, 0.0, 5000, 50000, 5, 1, null);
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service, url_logo ) VALUES ( 5, 'Leader Price', 0.2, 0.0, 5000, 50000, 5, 1, null);
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service, url_logo ) VALUES ( 6, 'Super U', 0.2, 0.0, 5000, 50000, 0, 1, null);
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service, url_logo ) VALUES ( 7, 'SuperMaki', 0.2, 0.0, 5000, 50000, 0, 1, null);
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service, url_logo ) VALUES ( 8, 'Aucun', 0.0, 0.0, 0, 0, 0, 3, null);
INSERT INTO plastikoo2.stock( id, qte_kg_entrant, qte_kg_sortant, date_mouvement, id_machine_recolte, reference, nbr_utilisateur ) VALUES ( 2, 0.0, 78.89, '2024-07-29', null, null, 0);
INSERT INTO plastikoo2.ticket( id, montant, code_recolte, date_creation, date_utilisation, id_machine_recolte, est_utilise ) VALUES ( 8, 50, '618536', '2024-09-11 05.14.36 PM', null, 2, 0);
INSERT INTO plastikoo2.ticket( id, montant, code_recolte, date_creation, date_utilisation, id_machine_recolte, est_utilise ) VALUES ( 9, 20, '001440', '2024-09-11 05.32.55 PM', null, 2, 0);
INSERT INTO plastikoo2.ticket( id, montant, code_recolte, date_creation, date_utilisation, id_machine_recolte, est_utilise ) VALUES ( 11, 20, '613876', '2024-09-16 10.57.21 PM', null, 4, 0);
INSERT INTO plastikoo2.ticket( id, montant, code_recolte, date_creation, date_utilisation, id_machine_recolte, est_utilise ) VALUES ( 12, 20, '518283', '2024-09-16 11.01.38 PM', null, 4, 0);
INSERT INTO plastikoo2.ticket( id, montant, code_recolte, date_creation, date_utilisation, id_machine_recolte, est_utilise ) VALUES ( 14, 20, '013927', '2024-09-17 02.38.57 PM', null, 4, 0);
INSERT INTO plastikoo2.transaction( id, montant, reference, id_utilisateur, id_machine_recolte, date_transaction, numero_beneficiaire, numero_expediteur, id_service, id_type_transaction, commission_service, commission_plastikoo ) VALUES ( 62, 2000, 'RCLT106998162240816110845', 1, 2, '2024-08-16 03.00.00 AM', null, null, 8, 2, 0.0, 0.0);
INSERT INTO plastikoo2.transaction( id, montant, reference, id_utilisateur, id_machine_recolte, date_transaction, numero_beneficiaire, numero_expediteur, id_service, id_type_transaction, commission_service, commission_plastikoo ) VALUES ( 63, 5000, 'BA585956826240816110811', 1, 7, '2024-08-16 03.00.00 AM', null, null, 4, 3, 0.0, 0.2);
INSERT INTO plastikoo2.transaction( id, montant, reference, id_utilisateur, id_machine_recolte, date_transaction, numero_beneficiaire, numero_expediteur, id_service, id_type_transaction, commission_service, commission_plastikoo ) VALUES ( 64, 2200, 'RTT355545622240816110824', 1, 7, '2024-08-16 03.00.00 AM', '+261321846915', '+261321289617', 1, 1, 0.2, 0.0);
INSERT INTO plastikoo2.transaction( id, montant, reference, id_utilisateur, id_machine_recolte, date_transaction, numero_beneficiaire, numero_expediteur, id_service, id_type_transaction, commission_service, commission_plastikoo ) VALUES ( 65, 500, 'BA176994768240816010846', 1, 7, '2024-08-16 03.00.00 AM', null, null, 4, 3, 0.0, 0.2);
INSERT INTO plastikoo2.transaction( id, montant, reference, id_utilisateur, id_machine_recolte, date_transaction, numero_beneficiaire, numero_expediteur, id_service, id_type_transaction, commission_service, commission_plastikoo ) VALUES ( 66, 100, 'RCLT251302928240827020827', 1, 2, '2024-08-27 05.53.28 PM', null, null, 8, 2, 0.0, 0.0);
INSERT INTO plastikoo2.transaction( id, montant, reference, id_utilisateur, id_machine_recolte, date_transaction, numero_beneficiaire, numero_expediteur, id_service, id_type_transaction, commission_service, commission_plastikoo ) VALUES ( 67, 2000, 'RCLT585195203240829080841', 13, 2, '2024-08-29 11.59.41 PM', null, null, 8, 2, 0.0, 0.0);
INSERT INTO plastikoo2.transaction( id, montant, reference, id_utilisateur, id_machine_recolte, date_transaction, numero_beneficiaire, numero_expediteur, id_service, id_type_transaction, commission_service, commission_plastikoo ) VALUES ( 68, 1000, 'RTT857316819240829090830', 13, 7, '2024-08-30 12.16.30 AM', '+261321846915', '+261321289617', 1, 1, 0.2, 0.0);
INSERT INTO plastikoo2.transaction( id, montant, reference, id_utilisateur, id_machine_recolte, date_transaction, numero_beneficiaire, numero_expediteur, id_service, id_type_transaction, commission_service, commission_plastikoo ) VALUES ( 69, 50, 'RCLT784925271240911030915', 14, 2, '2024-09-11 06.56.15 PM', null, null, 8, 2, 0.0, 0.0);
INSERT INTO plastikoo2.transaction( id, montant, reference, id_utilisateur, id_machine_recolte, date_transaction, numero_beneficiaire, numero_expediteur, id_service, id_type_transaction, commission_service, commission_plastikoo ) VALUES ( 70, 20, 'BA242072028240924120910', 13, 7, '2024-09-24 03.38.10 PM', null, null, 4, 3, 0.0, 0.2);
INSERT INTO plastikoo2.transaction( id, montant, reference, id_utilisateur, id_machine_recolte, date_transaction, numero_beneficiaire, numero_expediteur, id_service, id_type_transaction, commission_service, commission_plastikoo ) VALUES ( 71, 10000, 'BA956220864240925090915', 13, 7, '2024-09-26 12.51.15 AM', null, null, 4, 3, 0.0, 0.2);
INSERT INTO plastikoo2.transaction( id, montant, reference, id_utilisateur, id_machine_recolte, date_transaction, numero_beneficiaire, numero_expediteur, id_service, id_type_transaction, commission_service, commission_plastikoo ) VALUES ( 72, 10000, 'BA953575918240925090926', 13, 7, '2024-09-26 12.53.26 AM', null, null, 4, 3, 0.0, 0.2);
INSERT INTO plastikoo2.bon_achat( id, code_barre, date_exp, date_creation, id_transaction, etat ) VALUES ( 44, '9544703719713', '2024-08-21', '2024-08-16', 63, 'cree');
INSERT INTO plastikoo2.bon_achat( id, code_barre, date_exp, date_creation, id_transaction, etat ) VALUES ( 45, '4693319422838', '2024-08-21', '2024-08-16', 65, 'cree');
INSERT INTO plastikoo2.bon_achat( id, code_barre, date_exp, date_creation, id_transaction, etat ) VALUES ( 46, '2944834210858', '2024-09-29', '2024-09-24', 70, 'cree');
INSERT INTO plastikoo2.bon_achat( id, code_barre, date_exp, date_creation, id_transaction, etat ) VALUES ( 47, '2652666806851', '2024-09-30', '2024-09-25', 71, 'cree');
INSERT INTO plastikoo2.bon_achat( id, code_barre, date_exp, date_creation, id_transaction, etat ) VALUES ( 48, '2540258234869', '2024-09-30', '2024-09-25', 72, 'cree');
INSERT INTO plastikoo2.commentaire_pub( id, contenu, id_utilisateur, id_publication, date_creation, id_main_commentaire ) VALUES ( 1, 'This is a comment on publication 1 by user 1.', 1, 1, '2024-08-13', null);
INSERT INTO plastikoo2.commentaire_pub( id, contenu, id_utilisateur, id_publication, date_creation, id_main_commentaire ) VALUES ( 2, 'This is a comment on publication 1 by user 2.', 2, 1, '2024-08-13', null);
INSERT INTO plastikoo2.commentaire_pub( id, contenu, id_utilisateur, id_publication, date_creation, id_main_commentaire ) VALUES ( 3, 'This is a comment on publication 2 by user 1.', 1, 2, '2024-08-13', null);
INSERT INTO plastikoo2.commentaire_pub( id, contenu, id_utilisateur, id_publication, date_creation, id_main_commentaire ) VALUES ( 4, 'This is a comment on publication 2 by user 2.', 2, 2, '2024-08-13', null);
INSERT INTO plastikoo2.commentaire_pub( id, contenu, id_utilisateur, id_publication, date_creation, id_main_commentaire ) VALUES ( 5, 'This is a reply to user 1 on publication 1 by user 3.', 3, 1, '2024-08-13', 1);
INSERT INTO plastikoo2.commentaire_pub( id, contenu, id_utilisateur, id_publication, date_creation, id_main_commentaire ) VALUES ( 6, 'This is a reply to user 2 on publication 1 by user 4.', 4, 1, '2024-08-13', 2);
INSERT INTO plastikoo2.commentaire_pub( id, contenu, id_utilisateur, id_publication, date_creation, id_main_commentaire ) VALUES ( 7, 'This is a reply to user 1 on publication 2 by user 3.', 3, 2, '2024-08-13', 3);
INSERT INTO plastikoo2.commentaire_pub( id, contenu, id_utilisateur, id_publication, date_creation, id_main_commentaire ) VALUES ( 8, 'This is a reply to user 2 on publication 2 by user 4.', 4, 2, '2024-08-13', 4);
INSERT INTO plastikoo2.commentaire_pub( id, contenu, id_utilisateur, id_publication, date_creation, id_main_commentaire ) VALUES ( 9, 'This is a reply to user 3 on publication 1 by user 5.', 5, 1, '2024-08-13', 5);
INSERT INTO plastikoo2.commentaire_pub( id, contenu, id_utilisateur, id_publication, date_creation, id_main_commentaire ) VALUES ( 10, 'This is a reply to user 4 on publication 1 by user 6.', 6, 1, '2024-08-13', 6);
INSERT INTO plastikoo2.commentaire_pub( id, contenu, id_utilisateur, id_publication, date_creation, id_main_commentaire ) VALUES ( 11, 'This is a reply to user 3 on publication 2 by user 5.', 5, 2, '2024-08-13', 7);
INSERT INTO plastikoo2.commentaire_pub( id, contenu, id_utilisateur, id_publication, date_creation, id_main_commentaire ) VALUES ( 12, 'This is a reply to user 4 on publication 2 by user 6.', 6, 2, '2024-08-13', 8);
INSERT INTO plastikoo2.commentaire_pub( id, contenu, id_utilisateur, id_publication, date_creation, id_main_commentaire ) VALUES ( 13, 'This is another reply to user 3 on publication 1 by user 7.', 7, 1, '2024-08-13', 5);
INSERT INTO plastikoo2.commentaire_pub( id, contenu, id_utilisateur, id_publication, date_creation, id_main_commentaire ) VALUES ( 14, 'This is another reply to user 3 on publication 2 by user 7.', 7, 2, '2024-08-13', 7);
INSERT INTO plastikoo2.commentaire_pub( id, contenu, id_utilisateur, id_publication, date_creation, id_main_commentaire ) VALUES ( 15, 'This is a comment on publication 3 by user 8.', 8, 3, '2024-08-13', null);
INSERT INTO plastikoo2.commentaire_pub( id, contenu, id_utilisateur, id_publication, date_creation, id_main_commentaire ) VALUES ( 16, 'This is a comment on publication 3 by user 9.', 9, 3, '2024-08-13', null);
INSERT INTO plastikoo2.commentaire_pub( id, contenu, id_utilisateur, id_publication, date_creation, id_main_commentaire ) VALUES ( 17, 'This is a reply to user 8 on publication 3 by user 10.', 10, 3, '2024-08-13', 15);
INSERT INTO plastikoo2.commentaire_pub( id, contenu, id_utilisateur, id_publication, date_creation, id_main_commentaire ) VALUES ( 18, 'This is a reply to user 9 on publication 3 by user 10.', 10, 3, '2024-08-13', 16);
INSERT INTO plastikoo2.commentaire_pub( id, contenu, id_utilisateur, id_publication, date_creation, id_main_commentaire ) VALUES ( 19, 'This is another reply to my own comment on publication 3 by user 10.', 10, 3, '2024-08-13', 17);
INSERT INTO plastikoo2.commentaire_pub( id, contenu, id_utilisateur, id_publication, date_creation, id_main_commentaire ) VALUES ( 20, 'This is another reply to my own comment on publication 3 by user 10.', 10, 3, '2024-08-13', 18);
INSERT INTO plastikoo2.commentaire_pub( id, contenu, id_utilisateur, id_publication, date_creation, id_main_commentaire ) VALUES ( 52, 'asio pro hoe eeee', 13, 1, '2024-09-15', null);
INSERT INTO plastikoo2.commentaire_pub( id, contenu, id_utilisateur, id_publication, date_creation, id_main_commentaire ) VALUES ( 53, 'the shop market is closed', 13, 13, '2024-09-17', null);
INSERT INTO plastikoo2.photo_publication( id, img_url, img_alt, id_publication ) VALUES ( 1, 'plastikoo-test-1.png', 'Plastikoo test 1', 23);
INSERT INTO plastikoo2.photo_publication( id, img_url, img_alt, id_publication ) VALUES ( 2, 'plastikoo-test-1.png', 'Plastikoo test 2', 24);
INSERT INTO plastikoo2.photo_publication( id, img_url, img_alt, id_publication ) VALUES ( 4, 'forum-252606017.png', 'plastikoo osc final', 26);