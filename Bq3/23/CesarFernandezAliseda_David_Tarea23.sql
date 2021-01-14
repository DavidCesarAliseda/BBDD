/*DROP DATABASE IF EXISTS david_Tarea23 ;
CREATE DATABASE david_Tarea23;
USE david_Tarea23;*/

/*1. Crea la tabla provincias con los siguientes campos

Cod_provi de tipo number(2) y es la clave primaria
Nombre de tipo varchar2(25), es obligatorio
Pais de tipo varchar2(25) debe ser uno de los siguientes España, Portugal o Italia*/

CREATE TABLE provincias
(
	cod_provi INTEGER(2) PRIMARY KEY,
	nombre VARCHAR(25) NOT NULL,
	pais VARCHAR(25) CHECK (pais IN ('España', 'Portugal', 'Italia'))
	
);


/*2. Crea la tabla empresas con los siguientes campos:

Cod_empre number(2) es la clave
Nombre varchar2(25) obligatorio por defecto será empresa1
Fecha_crea de tipo fecha por defecto será un dia posterior a la fecha actual.*/

CREATE TABLE empresas
(
	cod_empre INTEGER PRIMARY KEY,
	nombre VARCHAR(25) NOT NULL DEFAULT 'empresa1',
	fecha_crea DATE DEFAULT (ADDDATE(current_date(), interval 1 day))
	
);

/*3. Crea la tabla Continentes con los siguientes campos

Cod_conti de tipo number y es la clave primaria
Nombre de tipo varchar2(20) el valor por defecto es EUROPA Y es obligatorio*/

CREATE TABLE continentes
(
	cod_conti INTEGER(2) PRIMARY KEY,
	nombre VARCHAR(20) NOT NULL DEFAULT 'EUROPA'
);

