/*Paso a DDL Oficinas*/
DROP DATABASE IF EXISTS david_oficinas ;
CREATE DATABASE david_oficinas;
USE david_oficinas;

CREATE TABLE edificio
(
	nombre_edif VARCHAR(25) PRIMARY KEY,
	direc_edif VARCHAR(30)
);

INSERT INTO edificio (nombre_edif, direc_edif )
VALUES ('Centris','Calle Almeria Nº62');
INSERT INTO edificio (nombre_edif, direc_edif )
VALUES ('Alcora','Calle Jaén Nº46');
INSERT INTO edificio (nombre_edif, direc_edif )
VALUES ('Peón','Calle Tomás Ybarra Nº39');

CREATE TABLE oficina
(
	num_ofi INT PRIMARY KEY,
	nombre_edif VARCHAR(25),
	CONSTRAINT fk_edif_ofic FOREIGN KEY (nombre_edif) REFERENCES edificio (nombre_edif) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO oficina (num_ofi, nombre_edif)
VALUES ('103','Centris');
INSERT INTO oficina (num_ofi, nombre_edif)
VALUES ('23','Peón');
INSERT INTO oficina (num_ofi, nombre_edif)
VALUES ('55','Peón');
INSERT INTO oficina (num_ofi, nombre_edif)
VALUES ('5','Alcora');

CREATE TABLE empresa
(
	cif_empre VARCHAR(9) PRIMARY KEY,
	nom_empre VARCHAR(30)
);

INSERT INTO empresa (cif_empre, nom_empre )
VALUES ('12345678A','Endesa');
INSERT INTO empresa (cif_empre, nom_empre )
VALUES ('45678912T','Repsol');
INSERT INTO empresa (cif_empre, nom_empre )
VALUES ('12356875J','Everis');


CREATE TABLE propietaria
(
	num_ofi INT PRIMARY KEY,
	cif_empre VARCHAR(9),
	CONSTRAINT fk_empr_prop FOREIGN KEY (cif_empre) REFERENCES empresa (cif_empre) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_ofic_prop FOREIGN KEY (num_ofi) REFERENCES oficina (num_ofi) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO propietaria
VALUES ('103','12345678A');
INSERT INTO propietaria
VALUES ('23','45678912T');
INSERT INTO propietaria
VALUES ('55','12345678A');
INSERT INTO propietaria
VALUES ('5','12356875J');