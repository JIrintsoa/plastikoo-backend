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
	url_profil           VARCHAR(255)       
 ) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
 ) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_publication_utilisateur ON plastikoo2.publication ( id_utilisateur );

CREATE  TABLE plastikoo2.reaction_pub ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	est_reagi            ENUM('oui','non')  DEFAULT ('non')     ,
	date_creation        DATETIME  DEFAULT (now())  NOT NULL   ,
	id_publication       INT       ,
	id_utilisateur       INT       ,
	CONSTRAINT fk_reaction_publication_utilisateur FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_reaction_to_publication FOREIGN KEY ( id_publication ) REFERENCES plastikoo2.publication( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_reaction_to_publication ON plastikoo2.reaction_pub ( id_publication );

CREATE INDEX fk_reaction_publication_utilisateur ON plastikoo2.reaction_pub ( id_utilisateur );

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

CREATE  TABLE plastikoo2.transaction ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	montant              DECIMAL(10,2)       ,
	reference            VARCHAR(255)       ,
	id_utilisateur       INT       ,
	id_machine_recolte   INT       ,
	date_transaction     DATE  DEFAULT (curdate())  NOT NULL   ,
	numero_beneficiaire  VARCHAR(13)       ,
	numero_expediteur    VARCHAR(13)       ,
	id_service           INT       ,
	id_type_transaction  INT       ,
	code_recolte         VARCHAR(6)  DEFAULT ('XXXXXX')     ,
	commission_service   DOUBLE  DEFAULT (0)  NOT NULL   ,
	commission_plastikoo DOUBLE  DEFAULT (0)  NOT NULL   ,
	CONSTRAINT fk_transaction_machine_recolte FOREIGN KEY ( id_machine_recolte ) REFERENCES plastikoo2.machine_recolte( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_transaction_service FOREIGN KEY ( id_service ) REFERENCES plastikoo2.service( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_transaction_type_transaction FOREIGN KEY ( id_type_transaction ) REFERENCES plastikoo2.type_transaction( id ) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT fk_transaction_utilisateur FOREIGN KEY ( id_utilisateur ) REFERENCES plastikoo2.utilisateur( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_transaction_utilisateur ON plastikoo2.transaction ( id_utilisateur );

CREATE INDEX fk_transaction_machine_recolte ON plastikoo2.transaction ( id_machine_recolte );

CREATE INDEX fk_transaction_type_transaction ON plastikoo2.transaction ( id_type_transaction );

CREATE INDEX fk_transaction_service ON plastikoo2.transaction ( id_service );

CREATE INDEX idx_date_transaction ON plastikoo2.transaction ( date_transaction );

CREATE INDEX idx_num_benificiaire ON plastikoo2.transaction ( numero_beneficiaire );

CREATE INDEX idx_num_expediteur ON plastikoo2.transaction ( numero_expediteur );

CREATE INDEX idx_code_recolte ON plastikoo2.transaction ( code_recolte );

CREATE INDEX idx_transaction_reference ON plastikoo2.transaction ( reference );

CREATE  TABLE plastikoo2.bon_achat ( 
	id                   INT    NOT NULL AUTO_INCREMENT  PRIMARY KEY,
	code_barre           VARCHAR(255)  DEFAULT ('XXXXXXXXXXXXX')  NOT NULL   ,
	date_exp             DATE    NOT NULL   ,
	date_creation        DATE  DEFAULT (curdate())  NOT NULL   ,
	id_transaction       INT       ,
	etat                 ENUM('cree','en cours','utilise')  DEFAULT ('_utf8mb4'cree'')     ,
	CONSTRAINT fk_bon_achat_transaction FOREIGN KEY ( id_transaction ) REFERENCES plastikoo2.transaction( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
 ) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
	CONSTRAINT fk_photo_publication_publication FOREIGN KEY ( id_publication ) REFERENCES plastikoo2.publication( id ) ON DELETE NO ACTION ON UPDATE NO ACTION
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE INDEX fk_photo_publication_publication ON plastikoo2.photo_publication ( id_publication );

ALTER TABLE plastikoo2.transaction MODIFY numero_beneficiaire VARCHAR(13)     COMMENT 's''applique avec le retrait, achat plastikoo';

ALTER TABLE plastikoo2.transaction MODIFY numero_expediteur VARCHAR(13)     COMMENT 's''applique avec le retrait, achat plastikoo';

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
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil ) VALUES ( 1, 'RANDRIANARISON', 'Johns Irintsoa', 'johnsirintsoa18@gmail.com', 'JIrintsoa', '1234Jo', '2002-09-18', 2200, '1234', 0, '2024-08-08 04.16.49 PM', null);
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil ) VALUES ( 2, 'Jane', 'Doe', 'jane.doe@example.com', 'janedoe', 'password2', '1991-02-01', 100, '5678', 0, '2025-01-01 02.59.59 AM', null);
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil ) VALUES ( 3, 'Alice', 'Smith', 'alice.smith@example.com', 'alicesmith', 'password3', '1992-03-01', 100, '9101', 0, '2025-01-01 02.59.59 AM', null);
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil ) VALUES ( 4, 'Bob', 'Johnson', 'bob.johnson@example.com', 'bobjohnson', 'password4', '1993-04-01', 100, '1121', 0, '2025-01-01 02.59.59 AM', null);
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil ) VALUES ( 5, 'Charlie', 'Brown', 'charlie.brown@example.com', 'charlieb', 'password5', '1994-05-01', 100, '3141', 0, '2025-01-01 02.59.59 AM', null);
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil ) VALUES ( 6, 'David', 'Davis', 'david.davis@example.com', 'davidd', 'password6', '1995-06-01', 100, '5161', 0, '2025-01-01 02.59.59 AM', null);
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil ) VALUES ( 7, 'Eva', 'Martinez', 'eva.martinez@example.com', 'evam', 'password7', '1996-07-01', 100, '7181', 0, '2025-01-01 02.59.59 AM', null);
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil ) VALUES ( 8, 'Frank', 'Garcia', 'frank.garcia@example.com', 'frankg', 'password8', '1997-08-01', 100, '9201', 0, '2025-01-01 02.59.59 AM', null);
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil ) VALUES ( 9, 'Grace', 'Hernandez', 'grace.hernandez@example.com', 'graceh', 'password9', '1998-09-01', 100, '1223', 0, '2025-01-01 02.59.59 AM', null);
INSERT INTO plastikoo2.utilisateur( id, nom, prenom, email, pseudo_utilisateur, mot_de_passe, date_naissance, solde, code_pin, cp_tentative, cp_timestamp_exp, url_profil ) VALUES ( 10, 'Hank', 'Wilson', 'hank.wilson@example.com', 'hankw', 'password10', '1999-10-01', 100, '3245', 0, '2025-01-01 02.59.59 AM', null);
INSERT INTO plastikoo2.contact_forms( id, nom, prenom, email, id_type_contact, message ) VALUES ( 55, 'RAKOTO', 'jean', 'rakoto.nirina@gmail.com', 4, 'Hello world');
INSERT INTO plastikoo2.machine_recolte( id, designation, id_type_plastique, capacite_stockage, lieu ) VALUES ( 1, 'Akoor digue PL001', 3, 200.0, 'Akoor digue');
INSERT INTO plastikoo2.machine_recolte( id, designation, id_type_plastique, capacite_stockage, lieu ) VALUES ( 2, 'Akoor digue PL002', 3, 200.0, 'Akoor digue');
INSERT INTO plastikoo2.machine_recolte( id, designation, id_type_plastique, capacite_stockage, lieu ) VALUES ( 3, 'Jumbo Score PL001', 1, 200.0, 'Jumbo score');
INSERT INTO plastikoo2.machine_recolte( id, designation, id_type_plastique, capacite_stockage, lieu ) VALUES ( 4, 'Jumbo Score PL002', 1, 200.0, 'Jumbo score');
INSERT INTO plastikoo2.machine_recolte( id, designation, id_type_plastique, capacite_stockage, lieu ) VALUES ( 5, 'Stade de Barea PL001', 1, 200.0, 'Stade de Barea');
INSERT INTO plastikoo2.machine_recolte( id, designation, id_type_plastique, capacite_stockage, lieu ) VALUES ( 6, 'Stade de Barea PL002', 1, 200.0, 'Stade de Barea');
INSERT INTO plastikoo2.machine_recolte( id, designation, id_type_plastique, capacite_stockage, lieu ) VALUES ( 7, 'No machine', 9, 0.0, 'Aucun');
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
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service, url_logo ) VALUES ( 1, 'Orange Money', 0.0, 0.2, 5000, 50000, 0, 2, null);
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service, url_logo ) VALUES ( 2, 'Airtel Money', 0.0, 0.2, 5000, 50000, 0, 2, null);
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service, url_logo ) VALUES ( 3, 'Mvola', 0.0, 0.2, 5000, 50000, 0, 2, null);
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service, url_logo ) VALUES ( 4, 'Jumbo', 0.2, 0.0, 5000, 50000, 5, 1, null);
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service, url_logo ) VALUES ( 5, 'Leader Price', 0.2, 0.0, 5000, 50000, 5, 1, null);
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service, url_logo ) VALUES ( 6, 'Super U', 0.2, 0.0, 5000, 50000, 0, 1, null);
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service, url_logo ) VALUES ( 7, 'SuperMaki', 0.2, 0.0, 5000, 50000, 0, 1, null);
INSERT INTO plastikoo2.service( id, libelle, commission_plastikoo, commission_service, min_som_requis, max_som_requis, duree_jour_valide, id_type_service, url_logo ) VALUES ( 8, 'Recolte', 0.0, 0.0, 0, 0, 0, 3, null);
INSERT INTO plastikoo2.stock( id, qte_kg_entrant, qte_kg_sortant, date_mouvement, id_machine_recolte, reference, nbr_utilisateur ) VALUES ( 2, 0.0, 78.89, '2024-07-29', null, null, 0);
INSERT INTO plastikoo2.transaction( id, montant, reference, id_utilisateur, id_machine_recolte, date_transaction, numero_beneficiaire, numero_expediteur, id_service, id_type_transaction, code_recolte, commission_service, commission_plastikoo ) VALUES ( 55, 2200, 'BA900040917240807120851', 1, 7, '2024-08-07', null, null, 4, 3, 'XXXXXX', 0.0, 0.0);
INSERT INTO plastikoo2.bon_achat( id, code_barre, date_exp, date_creation, id_transaction, etat ) VALUES ( 43, 'XXXXXXXXXXXXX', '2024-08-12', '2024-08-07', 55, 'cree');
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