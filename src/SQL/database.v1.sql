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
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE  TABLE plastikoo2.livraison ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	type_livraison       VARCHAR(255)       ,
	tarif                DECIMAL(10,2)       
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE  TABLE plastikoo2.type_contact ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	intitule             VARCHAR(255)       
 ) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE  TABLE plastikoo2.type_plastique ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	p_type               VARCHAR(255)       
 ) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE  TABLE plastikoo2.type_service ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	type_s               VARCHAR(255)       
 ) engine=InnoDB;

CREATE  TABLE plastikoo2.type_transaction ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	type_transaction     VARCHAR(255)       
 ) engine=InnoDB;

CREATE  TABLE plastikoo2.utilisateur ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	nom                  VARCHAR(255)       ,
	prenom               VARCHAR(255)       ,
	email                VARCHAR(255)       ,
	pseudo_utilisateur   VARCHAR(255)       ,
	mot_de_passe         VARCHAR(255)       ,
	date_naissance       DATE       ,
	solde                DECIMAL(10,2)  DEFAULT (0)  NOT NULL   
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
	CONSTRAINT fk_commande_livraison_0 FOREIGN KEY ( id_type_livraison ) REFERENCES plastikoo2.livraison( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_commande_utilisateur_0 FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
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
	CONSTRAINT fk_contact_forms_type_contact_0 FOREIGN KEY ( id_type_contact ) REFERENCES plastikoo2.type_contact( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_contact_forms_type_contact ON plastikoo2.contact_forms ( id_type_contact );

CREATE  TABLE plastikoo2.machine_recolte ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	designation          VARCHAR(255)       ,
	id_type_plastique    INT       ,
	capacite_stockage    DOUBLE       ,
	CONSTRAINT fk_machine_recolte_type_plastique_0 FOREIGN KEY ( id_type_plastique ) REFERENCES plastikoo2.type_plastique( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_machine_recolte_type_plastique ON plastikoo2.machine_recolte ( id_type_plastique );

CREATE  TABLE plastikoo2.produit ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	designation          VARCHAR(255)       ,
	description          TEXT       ,
	id_cat               INT       ,
	img                  VARCHAR(255)       ,
	prix_vente           DECIMAL(10,2)       ,
	qte_kg               DOUBLE       ,
	id_type_plastique    INT       ,
	CONSTRAINT fk_produit_categorie_0 FOREIGN KEY ( id_cat ) REFERENCES plastikoo2.categorie( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_produit_type_plastique_0 FOREIGN KEY ( id_type_plastique ) REFERENCES plastikoo2.type_plastique( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_produit_categorie ON plastikoo2.produit ( id_cat );

CREATE INDEX fk_produit_type_plastique ON plastikoo2.produit ( id_type_plastique );

CREATE  TABLE plastikoo2.service ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	libelle              VARCHAR(255)       ,
	commission_plastikoo DOUBLE  DEFAULT (0)     ,
	commission_service   DOUBLE  DEFAULT (0)     ,
	min_som_requis       DECIMAL(10,2)  DEFAULT (0)  NOT NULL   ,
	max_som_requis       DECIMAL(10,2)  DEFAULT (0)     ,
	duree_jour_valide    INT  DEFAULT (0)  NOT NULL   ,
	id_type_service      INT       ,
	CONSTRAINT fk_service_type_service FOREIGN KEY ( id_type_service ) REFERENCES plastikoo2.type_service( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) engine=InnoDB;

CREATE INDEX fk_service_type_service ON plastikoo2.service ( id_type_service );

CREATE  TABLE plastikoo2.stock ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	qte_kg_entrant       DOUBLE       ,
	qte_kg_sortant       DOUBLE       ,
	date_mouvement       DATE       ,
	id_machine_recolte   INT       ,
	reference            VARCHAR(255)       ,
	CONSTRAINT fk_stock_machine_recolte_0 FOREIGN KEY ( id_machine_recolte ) REFERENCES plastikoo2.machine_recolte( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_stock_machine_recolte ON plastikoo2.stock ( id_machine_recolte );

CREATE  TABLE plastikoo2.transaction ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	montant              DECIMAL(10,2)       ,
	reference            VARCHAR(255)       ,
	id_type_transaction  INT       ,
	id_utilisateur       INT       ,
	id_machine_recolte   INT       ,
	id_service           INT       ,
	date_transaction     DATE  DEFAULT (curdate())  NOT NULL   ,
	numero_beneficiaire  VARCHAR(13)       ,
	numero_expediteur    VARCHAR(13)       ,
	code_barre_ba        VARCHAR(255)       ,
	date_exp_ba          DATE  DEFAULT (curdate())  NOT NULL   ,
	etat                 ENUM('cree','utilise')       ,
	CONSTRAINT fk_transaction_utilisateur FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_transaction_machine_recolte FOREIGN KEY ( id_machine_recolte ) REFERENCES plastikoo2.machine_recolte( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_transaction_service FOREIGN KEY ( id_service ) REFERENCES plastikoo2.service( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_transaction_type_transaction FOREIGN KEY ( id_type_transaction ) REFERENCES plastikoo2.type_transaction( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) engine=InnoDB;

CREATE INDEX fk_transaction_utilisateur ON plastikoo2.transaction ( id_utilisateur );

CREATE INDEX fk_transaction_machine_recolte ON plastikoo2.transaction ( id_machine_recolte );

CREATE INDEX fk_transaction_service ON plastikoo2.transaction ( id_service );

CREATE INDEX idx_date_transaction ON plastikoo2.transaction ( date_transaction );

CREATE  TABLE plastikoo2.details_commande ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	id_commande          INT       ,
	id_produit           INT       ,
	qte                  INT       ,
	prix_vente           DECIMAL(10,2)       ,
	CONSTRAINT fk_details_commande_commande_0 FOREIGN KEY ( id_commande ) REFERENCES plastikoo2.commande( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_details_commande_produit_0 FOREIGN KEY ( id_produit ) REFERENCES plastikoo2.produit( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_details_commande_commande ON plastikoo2.details_commande ( id_commande );

CREATE INDEX fk_details_commande_produit ON plastikoo2.details_commande ( id_produit );

CREATE  TABLE plastikoo2.details_produit ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	id_produit           INT       ,
	id_produit_comp      INT       ,
	nbr                  INT       ,
	CONSTRAINT fk_details_produit_produit_0 FOREIGN KEY ( id_produit ) REFERENCES plastikoo2.produit( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_produit_composant_0 FOREIGN KEY ( id_produit_comp ) REFERENCES plastikoo2.produit( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
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

CREATE  TABLE plastikoo2.panier ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	reference            VARCHAR(255)       ,
	id_utilisateur       INT       ,
	id_produit           INT       ,
	qte                  INT       ,
	CONSTRAINT fk_panier_produit_0 FOREIGN KEY ( id_produit ) REFERENCES plastikoo2.produit( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_panier_utilisateur_0 FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_panier_utilisateur ON plastikoo2.panier ( id_utilisateur );

CREATE INDEX fk_panier_produit ON plastikoo2.panier ( id_produit );

CREATE  FUNCTION `generate_recolte_reference`() RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
  RETURN CONCAT('RCLT', UUID(), '_', DATE_FORMAT(NOW(), '%y%m%d'));
END;

CREATE  FUNCTION `generate_retrait_reference`() RETURNS varchar(255) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
  RETURN CONCAT('RTT_', UUID(), '_', DATE_FORMAT(NOW(), '%y%m%d'));
END;

CREATE  PROCEDURE `recolte_ticket`(IN montant DECIMAL(10,2), IN id_user INT, IN ref_trans VARCHAR(255), IN id_details_service INT, IN id_machine_recolte INT)
BEGIN 
    DECLARE ref_tk INT;

    START TRANSACTION;

    SELECT COUNT(id) INTO ref_tk
    FROM transaction_gains
    where reference_transaction LIKE CONCAT('%',ref_trans,'%');

    IF ref_tk > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ce ticket est deja expire';
    END IF;

    IF id_details_service IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Aucun service attribue';
    END IF;

    INSERT INTO transaction_gains (montant_entrant, reference_transaction, id_details_service, id_utilisateur,id_machine_recolte)
    VALUES (montant, ref_trans, id_details_service, id_user,id_machine_recolte);

    COMMIT;
END;

ALTER TABLE plastikoo2.transaction MODIFY numero_beneficiaire VARCHAR(13)     COMMENT 's''applique avec le retrait, achat plastikoo';

ALTER TABLE plastikoo2.transaction MODIFY numero_expediteur VARCHAR(13)     COMMENT 's''applique avec le retrait, achat plastikoo';

ALTER TABLE plastikoo2.transaction MODIFY etat ENUM('cree','utilise')     COMMENT 'validation provenant du marchand
- jumbo, leader price, super u, ...';

INSERT INTO plastikoo2.type_contact( id, intitule ) VALUES ( 4, 'Nos partenaire');
INSERT INTO plastikoo2.type_contact( id, intitule ) VALUES ( 5, 'Nos clients');
INSERT INTO plastikoo2.type_contact( id, intitule ) VALUES ( 6, 'Nos collaborateur');
INSERT INTO plastikoo2.type_plastique( id, p_type ) VALUES ( 1, 'LDPE');
INSERT INTO plastikoo2.type_plastique( id, p_type ) VALUES ( 2, 'HDPE');
INSERT INTO plastikoo2.type_plastique( id, p_type ) VALUES ( 3, 'PP');
INSERT INTO plastikoo2.type_plastique( id, p_type ) VALUES ( 4, 'PET');
INSERT INTO plastikoo2.type_service( id, type_s ) VALUES ( 1, 'Partenariat');
INSERT INTO plastikoo2.type_service( id, type_s ) VALUES ( 2, 'Operateur');
INSERT INTO plastikoo2.type_transaction( id, type_transaction ) VALUES ( 1, 'Retrait');
INSERT INTO plastikoo2.type_transaction( id, type_transaction ) VALUES ( 2, 'Recolte');
INSERT INTO plastikoo2.type_transaction( id, type_transaction ) VALUES ( 3, 'Bon d''achat');
INSERT INTO plastikoo2.type_transaction( id, type_transaction ) VALUES ( 4, 'Achat Plastikoo');
INSERT INTO plastikoo2.contact_forms( id, nom, prenom, email, id_type_contact, message ) VALUES ( 55, 'RAKOTO', 'jean', 'rakoto.nirina@gmail.com', 4, 'Hello world');
INSERT INTO plastikoo2.machine_recolte( id, designation, id_type_plastique, capacite_stockage ) VALUES ( 1, 'Akoor digue PL001', 3, 200.0);
INSERT INTO plastikoo2.machine_recolte( id, designation, id_type_plastique, capacite_stockage ) VALUES ( 2, 'Akoor digue PL002', 3, 200.0);
INSERT INTO plastikoo2.machine_recolte( id, designation, id_type_plastique, capacite_stockage ) VALUES ( 3, 'Jumbo Score PL001', 1, 200.0);
INSERT INTO plastikoo2.machine_recolte( id, designation, id_type_plastique, capacite_stockage ) VALUES ( 4, 'Jumbo Score PL002', 1, 200.0);
INSERT INTO plastikoo2.machine_recolte( id, designation, id_type_plastique, capacite_stockage ) VALUES ( 5, 'Stade de Barea PL001', 1, 200.0);
INSERT INTO plastikoo2.machine_recolte( id, designation, id_type_plastique, capacite_stockage ) VALUES ( 6, 'Stade de Barea PL002', 1, 200.0);
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service ) VALUES ( 1, 'Orange Money', 0.0, 0.2, 5000, 50000, 0, 2);
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service ) VALUES ( 2, 'Airtel Money', 0.0, 0.2, 5000, 50000, 0, 2);
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service ) VALUES ( 3, 'Mvola', 0.0, 0.2, 5000, 50000, 0, 2);
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service ) VALUES ( 4, 'Jumbo', 0.2, 0.0, 5000, 50000, 0, 1);
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service ) VALUES ( 5, 'Leader Price', 0.2, 0.0, 5000, 50000, 0, 1);
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service ) VALUES ( 6, 'Super U', 0.2, 0.0, 5000, 50000, 0, 1);
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service ) VALUES ( 7, 'SuperMaki', 0.2, 0.0, 5000, 50000, 0, 1);
INSERT INTO plastikoo2.stock( id, qte_kg_entrant, qte_kg_sortant, date_mouvement, id_machine_recolte, reference ) VALUES ( 2, 0.0, 78.89, '2024-07-29', null, null);