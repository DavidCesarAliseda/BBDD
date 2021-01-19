/*Paso a DDL Empleados*/
DROP DATABASE IF EXISTS david_empleados ;
CREATE DATABASE david_empleados;
USE david_empleados;

CREATE TABLE proyecto
(
	codigo INT(4) PRIMARY KEY,	
	nombre VARCHAR(50)
);

INSERT INTO proyecto (codigo, nombre )
VALUES ('135','Skyfall');
INSERT INTO proyecto (codigo, nombre )
VALUES ('52','Spectre');
INSERT INTO proyecto (codigo, nombre )
VALUES ('2685','Starlight');

CREATE TABLE empleado
(
	dni VARCHAR(9) PRIMARY KEY,
	nombre VARCHAR(30),
	sueldo INT,
	fecha_asig DATE,
	codigo INT(4),
	CONSTRAINT fk_proy_emple FOREIGN KEY (codigo) REFERENCES proyecto (codigo) ON DELETE CASCADE ON UPDATE CASCADE

);

INSERT INTO empleado (dni, nombre, sueldo, fecha_asig, codigo)
VALUES ('12345678C''Federico','1320', '11-6-2020', '135');
INSERT INTO empleado (dni, nombre, sueldo, fecha_asig, codigo)
VALUES ('65482154C''Antonio','1450', '11-13-2020', '135');
INSERT INTO empleado (dni, nombre, sueldo, fecha_asig, codigo)
VALUES ('67892451C''Sara','1675', '2-1-2021', '2685');
INSERT INTO empleado (dni, nombre, sueldo, fecha_asig, codigo)
VALUES ('35489652C''Eugenio','1320', '7-8-2020', '135');

CREATE TABLE jefe
(
	dni VARCHAR(9) PRIMARY KEY,
	dni_jefe VARCHAR(9),
	CONSTRAINT fk_emple_jefe FOREIGN KEY (dni) REFERENCES empleado (dni) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO jefe (dni, dni_jefe)
VALUES ('35489652C''Eugenio','1320', '7-8-2020', '135');


