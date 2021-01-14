/*DROP DATABASE IF EXISTS david_Tarea24 ;
CREATE DATABASE david_Tarea24;
USE david_Tarea24;*/

/*1.- Crea la tabla alumnos con los siguientes campos


codigo number(3) y es la clave primaria
nombre cadena de caracteres de longitud máxima 21, es obligatorio
apellido cadena de caracteres de longitud máxima 30, es obligatorio y ha de estar en mayúsculas.
Curso de tipo number y ha de ser 1,2 o 3
Fecha_matri de tipo fecha y por defecto es la fecha actual*/

CREATE TABLE alumnos
(
	codigo INT(3) PRIMARY KEY,
	nombre VARCHAR(21) NOT NULL,
	apellido VARCHAR(30) NOT NULL,
	curso INT(1) CHECK(curso <=3 AND curso >=1),
	fecha_matri DATE DEFAULT (SYSDATE())
);

/*Convierte el dato apellido a mayuscula*/
/*DELIMITER //
CREATE TRIGGER transforma BEFORE INSERT ON alumnos
FOR EACH ROW
    BEGIN
        SET New.apellido = UPPER(NEW.apellido);
    END;
//
*/

/*3.- Crea la tabla empleados con los siguientes campos


Cod_emple number(2) y es clave
Nombre cadena de caracteres de longitud máxima 20 y es obligatorio
Apellido cadena de caracteres de longitud máxima 25
Salario número de 7 cifras con dos decimales debe ser mayor que 0


Además tiene dos campos que son claves ajenas de las tablas provincias y empresas respectivamente, para la clave ajena de provincias indicaremos un borrado en cascada.*/

CREATE TABLE empleados
(
	cod_emple INT(2) PRIMARY KEY,
	nombre VARCHAR(20) NOT NULL,
	apellido VARCHAR(25),
	salario FLOAT(7, 2) CHECK(salario>0),
	cod_provi INT(2),
	cod_empre INT,
	CONSTRAINT fk_prov_emple FOREIGN KEY (cod_provi) REFERENCES provincias (cod_provi) ON DELETE CASCADE,
	CONSTRAINT fk_empres_emple FOREIGN KEY (cod_empre) REFERENCES empresas (cod_empre)

);