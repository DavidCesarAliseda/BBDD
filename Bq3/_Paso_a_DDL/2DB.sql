/*Paso a DDL Empleados*/
DROP DATABASE IF EXISTS david_empleados ;
CREATE DATABASE david_empleados;
USE david_empleados;

CREATE TABLE proyecto
(
	codigo INT(4) PRIMARY KEY,	
	nombre VARCHAR(50)
);

CREATE TABLE empleado
(
	dni VARCHAR(9) PRIMARY KEY,
	nombre VARCHAR(30),
	sueldo INT,
	fecha_asig DATE,
	codigo INT(4),
	CONSTRAINT fk_proy_emple FOREIGN KEY (codigo) REFERENCES proyecto (codigo) ON DELETE CASCADE ON UPDATE CASCADE

);

CREATE TABLE jefe
(
	dni VARCHAR(9) PRIMARY KEY,
	dni_jefe VARCHAR(9),
	CONSTRAINT fk_emple_jefe FOREIGN KEY (dni) REFERENCES empleado (dni) ON DELETE CASCADE ON UPDATE CASCADE
);

