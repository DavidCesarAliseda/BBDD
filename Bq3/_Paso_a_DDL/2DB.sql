/*Paso a DDL Empleados*/
DROP DATABASE IF EXISTS david_empleados ;
CREATE DATABASE david_empleados;
USE david_empleados;

CREATE TABLE proyecto
(
	codigo INT(4) PRIMARY KEY,	
	nombre_proy VARCHAR(50) NOT NULL
);

INSERT INTO proyecto (codigo, nombre_proy )
VALUES ('135','Skyfall');
INSERT INTO proyecto (codigo, nombre_proy )
VALUES ('52','Spectre');
INSERT INTO proyecto (codigo, nombre_proy )
VALUES ('2685','Starlight');

CREATE TABLE empleado
(
	dni CHAR(9) PRIMARY KEY,
	nombre_emple VARCHAR(30) NOT NULL,
	sueldo INT NOT NULL,
	fecha_asig DATE NOT NULL DEFAULT SYSDATE(),
	codigo INT(4) NOT NULL,
	CONSTRAINT fk_proy_emple FOREIGN KEY (codigo) REFERENCES proyecto (codigo) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO empleado (dni, nombre_emple, sueldo, fecha_asig, codigo)
VALUES ('12345678C','Federico','1320', '2020-12-6', '135');
INSERT INTO empleado (dni, nombre_emple, sueldo, fecha_asig, codigo)
VALUES ('65482154C','Antonio','1450', '2020-1-2', '135');
INSERT INTO empleado (dni, nombre_emple, sueldo, fecha_asig, codigo)
VALUES ('67892451C','Sara','1675', '2021-1-2', '2685');
INSERT INTO empleado (dni, nombre_emple, sueldo, fecha_asig, codigo)
VALUES ('35489652C','Eugenio','1320', '2021-1-13', '135');

CREATE TABLE jefe
(
	dni CHAR(9) PRIMARY KEY,
	dni_jefe CHAR(9),
	CONSTRAINT fk_empledni_jefe FOREIGN KEY (dni) REFERENCES empleado (dni) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_emple_jefedni FOREIGN KEY (dni_jefe) REFERENCES empleado (dni) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO jefe (dni, dni_jefe)
VALUES ('65482154C','12345678C');
INSERT INTO jefe (dni, dni_jefe)
VALUES ('67892451C','12345678C');
INSERT INTO jefe (dni, dni_jefe)
VALUES ('35489652C','12345678C');