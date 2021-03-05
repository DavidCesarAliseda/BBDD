/*1.8.7 Cursores*/
/*1. Escribe las sentencias SQL necesarias para crear una base de datos llamada test, una tabla llamada alumnos y 4 sentencias de inserción 
para inicializar la tabla. La tabla alumnos está formada por las siguientes columnas:

id (entero sin signo y clave primaria)
nombre (cadena de caracteres)
apellido1 (cadena de caracteres)
apellido2 (cadena de caracteres
fecha_nacimiento (fecha)

Una vez creada la tabla se decide añadir una nueva columna a la tabla llamada edad que será un valor calculado a partir de la columna 
fecha_nacimiento. Escriba la sentencia SQL necesaria para modificar la tabla y añadir la nueva columna.

Escriba una función llamada calcular_edad que reciba una fecha y devuelva el número de años que han pasado desde la fecha actual hasta la 
fecha pasada como parámetro:

Función: calcular_edad
Entrada: Fecha
Salida: Número de años (entero)

Ahora escriba un procedimiento que permita calcular la edad de todos los alumnmos que ya existen en la tabla. Para esto será necesario 
crear un procedimiento llamado actualizar_columna_edad que calcule la edad de cada alumno y actualice la tabla. Este procedimiento hará 
uso de la función calcular_edad que hemos creado en el paso anterior.*/

DROP DATABASE IF EXISTS test ;
CREATE DATABASE test;
USE test; 

CREATE TABLE alumnos
(
	id INT UNSIGNED PRIMARY KEY,
	nombre VARCHAR(20),
	apellido1 VARCHAR(20),
	apellido2 VARCHAR(20),
	fecha_nacimiento DATE
)

ALTER TABLE alumnos
ADD COLUMN edad INT AFTER fecha_nacimiento;

/*Funcion calcular edad*/
DELIMITER $$
DROP FUNCTION IF EXISTS calcular_edad$$
CREATE FUNCTION calcular_edad(fecha_nacimiento_funcion DATE) RETURNS INT
BEGIN
	DECLARE edad_alum INT DEFAULT 0;
	IF(MONTH(fecha_nacimiento_funcion)>MONTH(SYSDATE())) THEN
		SET edad_alum=(YEAR(SYSDATE())-YEAR(fecha_nacimiento_funcion))-1;
	ELSE
		SET edad_alum=YEAR(SYSDATE())-YEAR(fecha_nacimiento_funcion);
	END IF;
	RETURN edad_alum;
END$$
DELIMITER ;

/*Procedimiento actualizar*/
DELIMITER $$
DROP PROCEDURE IF EXISTS actualizar_columna_edad$$
CREATE PROCEDURE actualizar_columna_edad() 
BEGIN
	DECLARE id_alm INT DEFAULT 0;
	DECLARE done INT DEFAULT 0;
	DECLARE cur CURSOR FOR SELECT id FROM alumnos; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN cur;

	REPEAT 
		FETCH cur INTO id_alm;
		IF NOT done THEN 
			UPDATE alumnos
			SET edad = calcular_edad(alumnos.fecha_nacimiento)
			WHERE id_alm=alumnos.id AND alumnos.fecha_nacimiento IS NOT NULL;
		END IF;
	UNTIL done END REPEAT;
	CLOSE cur;
END$$
DELIMITER ;


/*2.Modifica la tabla alumnos del ejercicio anterior para añadir una nueva columna email. Una vez que hemos modificado la tabla necesitamos 
asignarle una dirección de correo electrónico de forma automática.Escriba un procedimiento llamado crear_email que dados los parámetros 
de entrada: nombre, apellido1, apellido2 y dominio, cree una dirección de email y la devuelva como salida.

Procedimiento: crear_email
Entrada:
nombre (cadena de caracteres)
apellido1 (cadena de caracteres)
apellido2 (cadena de caracteres)
dominio (cadena de caracteres)
Salida:
email (cadena de caracteres)
devuelva una dirección de correo electrónico con el siguiente formato:

El primer carácter del parámetro nombre.
Los tres primeros caracteres del parámetro apellido1.
Los tres primeros caracteres del parámetro apellido2.
El carácter @.
El dominio pasado como parámetro.

Ahora escriba un procedimiento que permita crear un email para todos los alumnmos que ya existen en la tabla. Para esto será necesario 
crear un procedimiento llamado actualizar_columna_email que actualice la columna email de la tabla alumnos. Este procedimiento hará uso 
del procedimiento crear_email que hemos creado en el paso anterior.
*/
ALTER TABLE alumnos
ADD COLUMN email VARCHAR(50) AFTER edad;

/*Funcion crear email*/
DELIMITER $$
DROP FUNCTION IF EXISTS crear_email$$
CREATE FUNCTION crear_email(nombre VARCHAR(20), apellido1 VARCHAR(20), apellido2 VARCHAR(20), dominio VARCHAR(25)) RETURNS VARCHAR(100)
BEGIN
	RETURN CONCAT(SUBSTRING(nombre, 1, 1), SUBSTRING(apellido1, 1, 3), SUBSTRING(apellido2, 1, 3), '@', dominio); 
END$$
DELIMITER ;

/*Procedimiento actualizar*/
DELIMITER $$
DROP PROCEDURE IF EXISTS actualizar_columna_email$$
CREATE PROCEDURE actualizar_columna_email(dominio VARCHAR(25)) 
BEGIN
	DECLARE id_alm INT DEFAULT 0;
	DECLARE done INT DEFAULT 0;
	DECLARE cur CURSOR FOR SELECT id FROM alumnos; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN cur;

	REPEAT 
		FETCH cur INTO id_alm;
		IF NOT done THEN 
			UPDATE alumnos
			SET email = crear_email(alumnos.nombre, alumnos.apellido1, alumnos.apellido2, dominio)
			WHERE id_alm=alumnos.id AND alumnos.nombre IS NOT NULL AND alumnos.apellido1 IS NOT NULL AND alumnos.apellido2 IS NOT NULL;
		END IF;
	UNTIL done END REPEAT;
	CLOSE cur;
END$$
DELIMITER ;

/*3. Escribe un procedimiento llamado crear_lista_emails_alumnos que devuelva la lista de emails de la tabla alumnos separados por un punto y coma. 
Ejemplo: juan@iescelia.org;maria@iescelia.org;pepe@iescelia.org;lucia@iescelia.org.*/

DELIMITER $$
DROP PROCEDURE IF EXISTS crear_lista_emails_alumnos$$
CREATE PROCEDURE crear_lista_emails_alumnos() 
BEGIN
	
	DECLARE id_alm INT DEFAULT 0;
	DECLARE lista VARCHAR(1000) DEFAULT '';
	DECLARE done INT DEFAULT 0;
	DECLARE cur CURSOR FOR SELECT id FROM alumnos; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	
	OPEN cur;
	REPEAT 
		FETCH cur INTO id_alm;
		IF NOT done THEN 
			SELECT CONCAT(lista,alumnos.email,';') 
			INTO lista
			FROM alumnos
			WHERE id_alm=alumnos.id;
		END IF;
	UNTIL done END REPEAT;
	SELECT lista AS ListaEmail;
END$$
DELIMITER ;

/*1.8.8 Triggers*/
/*1. Crea una base de datos llamada test que contenga una tabla llamada alumnos con las siguientes columnas.
Tabla alumnos:

id (entero sin signo)
nombre (cadena de caracteres)
apellido1 (cadena de caracteres)
apellido2 (cadena de caracteres)
nota (número real)
Una vez creada la tabla escriba dos triggers con las siguientes características:

Trigger 1: trigger_check_nota_before_insert
Se ejecuta sobre la tabla alumnos.
Se ejecuta antes de una operación de inserción.
Si el nuevo valor de la nota que se quiere insertar es negativo, se guarda como 0.
Si el nuevo valor de la nota que se quiere insertar es mayor que 10, se guarda como 10.

Trigger2 : trigger_check_nota_before_update
Se ejecuta sobre la tabla alumnos.
Se ejecuta antes de una operación de actualización.
Si el nuevo valor de la nota que se quiere actualizar es negativo, se guarda como 0.
Si el nuevo valor de la nota que se quiere actualizar es mayor que 10, se guarda como 10.
Una vez creados los triggers escriba varias sentencias de inserción y actualización sobre la tabla alumnos y verifica que los triggers se están ejecutando correctamente.
*/

DROP DATABASE IF EXISTS test ;
CREATE DATABASE test;
USE test; 

CREATE TABLE alumnos
(
	id INT UNSIGNED PRIMARY KEY,
	nombre VARCHAR(20),
	apellido1 VARCHAR(20),
	apellido2 VARCHAR(20),
	nota FLOAT
)

/*trigger_check_nota_before_insert*/
DELIMITER $$
DROP TRIGGER IF EXISTS trigger_check_nota_before_insert$$
CREATE TRIGGER trigger_check_nota_before_insert
BEFORE INSERT 
ON alumnos FOR EACH ROW
BEGIN
  IF NEW.nota < 0 THEN
    SET NEW.nota = 0;
  ELSEIF NEW.nota > 10 THEN
    SET NEW.nota = 10;
  END IF;
END$$

/*trigger_check_nota_before_update*/
DELIMITER $$
DROP TRIGGER IF EXISTS trigger_check_nota_before_update$$
CREATE TRIGGER trigger_check_nota_before_update
BEFORE UPDATE
ON alumnos FOR EACH ROW
BEGIN
  IF NEW.nota < 0 THEN
    SET NEW.nota = 0;
  ELSEIF NEW.nota > 10 THEN
    SET NEW.nota = 10;
  END IF;
END$$

INSERT INTO alumnos VALUES (1, 'Pedro', 'Pérez', 'Pérez', -2);
INSERT INTO alumnos VALUES (2, 'Marta', 'López', 'López', 15);
INSERT INTO alumnos VALUES (3, 'Jose', 'Sánchez', 'Sánchez', 8.5);

UPDATE alumnos SET nota = 22 WHERE id = 1;
UPDATE alumnos SET nota = 9.5 WHERE id = 2;
UPDATE alumnos SET nota = -7 WHERE id = 3;

/*2. Crea una base de datos llamada test que contenga una tabla llamada alumnos con las siguientes columnas.
Tabla alumnos:

id (entero sin signo)
nombre (cadena de caracteres)
apellido1 (cadena de caracteres)
apellido2 (cadena de caracteres)
email (cadena de caracteres)
*/
DROP DATABASE IF EXISTS test ;
CREATE DATABASE test;
USE test; 

CREATE TABLE alumnos
(
	id INT UNSIGNED PRIMARY KEY,
	nombre VARCHAR(20),
	apellido1 VARCHAR(20),
	apellido2 VARCHAR(20),
	email VARCHAR(50)
)
/*
Escriba un procedimiento llamado crear_email que dados los parámetros de entrada: nombre, apellido1, apellido2 y dominio, cree una dirección de email y la devuelva como salida.
Procedimiento: crear_email
Entrada:
nombre (cadena de caracteres)
apellido1 (cadena de caracteres)
apellido2 (cadena de caracteres)
dominio (cadena de caracteres)
Salida:
email (cadena de caracteres)
devuelva una dirección de correo electrónico con el siguiente formato:

El primer carácter del parámetro nombre.
Los tres primeros caracteres del parámetro apellido1.
Los tres primeros caracteres del parámetro apellido2.
El carácter @.
El dominio pasado como parámetro.
*/
DELIMITER $$
DROP FUNCTION IF EXISTS crear_email$$
CREATE FUNCTION crear_email(nombre VARCHAR(20), apellido1 VARCHAR(20), apellido2 VARCHAR(20), dominio VARCHAR(25)) RETURNS VARCHAR(100)
BEGIN
	RETURN CONCAT(SUBSTRING(nombre, 1, 1), SUBSTRING(apellido1, 1, 3), SUBSTRING(apellido2, 1, 3), '@', dominio); 
END$$
DELIMITER ;
/*
Una vez creada la tabla escriba un trigger con las siguientes características:

Trigger: trigger_crear_email_before_insert
Se ejecuta sobre la tabla alumnos.
Se ejecuta antes de una operación de inserción.
Si el nuevo valor del email que se quiere insertar es NULL, entonces se le creará automáticamente una dirección de email y se insertará en la tabla.
Si el nuevo valor del email no es NULL se guardará en la tabla el valor del email.
Nota: Para crear la nueva dirección de email se deberá hacer uso del procedimiento crear_email.
*/

DELIMITER $$
DROP TRIGGER IF EXISTS trigger_crear_email_before_insert$$
CREATE TRIGGER trigger_crear_email_before_insert
BEFORE INSERT
ON alumnos FOR EACH ROW
BEGIN
  IF (NEW.email IS NULL) THEN
    SET NEW.email = crear_email(NEW.nombre, NEW.apellido1, NEW.apellido2, 'ejemplo.org');
  END IF;
END$$

/*
3. Modifica el ejercicio anterior y añade un nuevo trigger que las siguientes características:
Trigger: trigger_guardar_email_after_update:
/*
Se ejecuta sobre la tabla alumnos.
Se ejecuta después de una operación de actualización.
Cada vez que un alumno modifique su dirección de email se deberá insertar un nuevo registro en una tabla llamada log_cambios_email.
*/
DELIMITER $$
DROP TRIGGER IF EXISTS trigger_guardar_email_after_update$$
CREATE TRIGGER trigger_guardar_email_after_update
AFTER UPDATE
ON alumnos FOR EACH ROW
BEGIN
	
	INSERT INTO log_cambios_email (id_alumno, old_email, new_email ) 
	VALUES (OLD.id, OLD.email, NEW.email);
  
END$$
/*
La tabla log_cambios_email contiene los siguientes campos:
id: clave primaria (entero autonumérico)
id_alumno: id del alumno (entero)
fecha_hora: marca de tiempo con el instante del cambio (fecha y hora)
old_email: valor anterior del email (cadena de caracteres)
new_email: nuevo valor con el que se ha actualizado
*/
CREATE TABLE log_cambios_email
(
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	id_alumno INT,
	fecha_hora DATETIME DEFAULT SYSDATE(),
	old_email VARCHAR(50),
	new_email VARCHAR(50)
)

/*
Modifica el ejercicio anterior y añade un nuevo trigger que tenga las siguientes características:
Trigger: trigger_guardar_alumnos_eliminados:

Se ejecuta sobre la tabla alumnos.
Se ejecuta después de una operación de borrado.
Cada vez que se elimine un alumno de la tabla alumnos se deberá insertar un nuevo registro en una tabla llamada log_alumnos_eliminados.
*/
DELIMITER $$
DROP TRIGGER IF EXISTS trigger_guardar_alumnos_eliminados$$
CREATE TRIGGER trigger_guardar_alumnos_eliminados
BEFORE DELETE
ON alumnos FOR EACH ROW
BEGIN
	
	INSERT INTO log_alumnos_eliminados (id_alumno, nombre, apellido1, apellido2, email ) 
	VALUES (OLD.id, OLD.nombre, OLD.apellido1, OLD.apellido2, OLD.email);
  
END$$
/*
La tabla log_alumnos_eliminados contiene los siguientes campos:
id: clave primaria (entero autonumérico)
id_alumno: id del alumno (entero)
fecha_hora: marca de tiempo con el instante del cambio (fecha y hora)
nombre: nombre del alumno eliminado (cadena de caracteres)
apellido1: primer apellido del alumno eliminado (cadena de caracteres)
apellido2: segundo apellido del alumno eliminado (cadena de caracteres)
email: email del alumno eliminado (cadena de caracteres)
*/
CREATE TABLE log_alumnos_eliminados
(
	id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR(20),
	apellido1 VARCHAR(20),
	apellido2 VARCHAR(20),
	email VARCHAR(50),
	id_alumno INT,
	fecha_hora DATETIME DEFAULT SYSDATE()
	
)
