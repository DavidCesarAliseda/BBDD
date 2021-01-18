/*DROP DATABASE IF EXISTS david_Tarea26 ;
CREATE DATABASE david_Tarea26;
USE david_Tarea26;*/

/*El código para crear las 2 tablas, se debe escribir en 2 archivos distinto de texto plano, para ello debes utilizar un editor que no introduzca caracteres de formato. Puedes utilizar Notepad+, o cualquier otro entorno similar con el que estés familiarizado. No olvides guardarlo con extensión .sql

El ejercicio estará correcto cuando importando el código a un GBD las tablas se creen correctamente.

1. Crea la tabla provincias y personas con las siguiente estructura, en negrita la clave principal y codprovin referencia a cod_provincia. Además pondremos la opción de BORRADO EN CASCADA*/

CREATE TABLE personas
(
	dni VARCHAR PRIMARY KEY,
	nombre VARCHAR,
	direccion VARCHAR,
	poblacion VARCHAR,
	codprovincia INT,
	CONSTRAINT fk_prov_pers FOREIGN KEY (codprovi) REFERENCES provincias (codprovi) ON DELETE CASCADE
	
);