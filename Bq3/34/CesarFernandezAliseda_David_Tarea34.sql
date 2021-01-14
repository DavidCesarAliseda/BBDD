/*DROP DATABASE IF EXISTS david_Tarea34 ;
CREATE DATABASE david_Tarea34;
USE david_Tarea34;*/

/*Si una restricción de integridad se define mediante el comando CREATE TABLE o se añade con el comando ALTER TABLE, la condición se habilita automáticamente. Una restricción puede ser posteriormente deshabilitada con el comando ALTER TABLE.

Teniendo en cuenta esta indicación, utiliza el siguiente código para la creación de tablas:

CREATE TABLE clientes(
dni VARCHAR(9) CONSTRAINT clientes_pk PRIMARY KEY,
nombre VARCHAR(50)
);

CREATE TABLE alquileres(
dni VARCHAR2(9) 
CONSTRAINT alquileres_fk1 REFERENCES clientes(dni),
cod_alquiler NUMBER(5) PRIMARY KEY
);

Una vez creadas las tablas y comprobado que todas las restricciones están activadas, deshabilita la clave primaria de la tabla clientes. Para responder al ejercicio deberás subir el código que crea las tablas modificando el nombre de las tablas y delas restricciones añadiendo las iniciales de tu nombre al final.

También debes subir rellenar una explicación de texto en la que cuentes que hay que tener en cuenta antes de deshabilitar la clave primaria.*/

CREATE TABLE clientes(
	dni VARCHAR(9) CONSTRAINT clientes_pk PRIMARY KEY,
	nombre VARCHAR(50)
);

CREATE TABLE alquileres(
	dni VARCHAR2(9) 
	CONSTRAINT alquileres_fk1 REFERENCES clientes(dni),
	cod_alquiler NUMBER(5) PRIMARY KEY
);

ALTER TABLE alquileres
DISABLE CONSTRAINT alquileres_fk1;

