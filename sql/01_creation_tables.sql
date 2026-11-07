CREATE TABLE Region (

                Code_dep_code_commune VARCHAR(6) NOT NULL,

                reg_code VARCHAR(2) NOT NULL,

                dep_nom_num VARCHAR(50) NOT NULL,

                dep_code VARCHAR(3) NOT NULL,

                com_nom_maj_court VARCHAR(50) NOT NULL,

                dep_nom VARCHAR(50) NOT NULL,

                aca_nom VARCHAR(30) NOT NULL,

                reg_nom VARCHAR(50) NOT NULL,

                CONSTRAINT Region_pk PRIMARY KEY (Code_dep_code_commune)

);





CREATE TABLE Contrat (

                Contrat_ID INTEGER NOT NULL,

                Prix_cotisation_mensuel INTEGER NOT NULL,

                Valeur_declaree_biens VARCHAR(25) NOT NULL,

                Formule VARCHAR(15) NOT NULL,

                Type_contrat VARCHAR(25) NOT NULL,

                Occupation VARCHAR(15) NOT NULL,

                Type_local VARCHAR(15) NOT NULL,

                Surface INTEGER NOT NULL,

                No_voie INTEGER NOT NULL,

                B_T_Q VARCHAR(1) NOT NULL,

                Type_de_voie VARCHAR(10) NOT NULL,

                Voie VARCHAR(50) NOT NULL,

                Code_dep_code_commune VARCHAR(6) NOT NULL,

                Code_postal VARCHAR(5) NOT NULL,

                CONSTRAINT Contrat_pk PRIMARY KEY (Contrat_ID)

);





ALTER TABLE Contrat ADD CONSTRAINT Region_Contrat_fk

FOREIGN KEY (Code_dep_code_commune)

REFERENCES Region (Code_dep_code_commune)

ON DELETE NO ACTION

ON UPDATE NO ACTION

NOT DEFERRABLE;