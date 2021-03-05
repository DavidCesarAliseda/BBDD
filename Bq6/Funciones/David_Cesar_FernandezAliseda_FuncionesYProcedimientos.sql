/*Base de datos jardineria*/
/*12. Diseñar una función a la que se le pase una fecha y nos diga (devolviendo
verdadero o falso) si es una época lectiva(de septiembre a junio) o estamos de
vacaciones (el resto del curso).*/
DELIMITER $$
DROP FUNCTION IF EXISTS lectiva$$
CREATE FUNCTION lectiva (fecha DATE) RETURNS BOOLEAN
BEGIN
	DECLARE es_lectiva BOOLEAN DEFAULT TRUE;
	
	IF (MONTH(fecha)=8 OR MONTH(fecha)=7) THEN 
		 SET es_lectiva = FALSE;
	END IF;
	
	RETURN es_lectiva;
END$$

/*a. ¿Cómo podríamos ver si los pagos se realizaron en época lectiva?*/

SELECT pago.codigo_cliente, jardineria.lectiva(pago.fecha_pago) AS Es_Lectiva
FROM pago;

/*1.8.1 Procedimientos sin sentencias SQL*/
/*1. Escribe un procedimiento que no tenga ningún parámetro de entrada ni de salida y que muestre el texto ¡Hola mundo!.*/

DELIMITER $$
DROP PROCEDURE IF EXISTS Hola_Mundo$$
CREATE PROCEDURE Hola_Mundo ()
BEGIN
	SELECT 'Hola mundo';
END$$
DELIMITER ;

/*2. Escribe un procedimiento que reciba un número real de entrada y muestre un mensaje indicando si el número es positivo, negativo o cero.*/

DELIMITER $$
DROP PROCEDURE IF EXISTS comprobarSigno$$
CREATE PROCEDURE comprobarSigno (num DOUBLE)
BEGIN
	IF (num<0) THEN
		SELECT 'Es negativo';
	ELSEIF (num>0) THEN
		SELECT 'Es positivo';
	ELSE
		SELECT 'Es cero';
	END IF;
END$$
DELIMITER ;

/*3. Modifique el procedimiento diseñado en el ejercicio anterior para que tenga un parámetro de entrada, con el valor un número real, y un parámetro de salida, 
con una cadena de caracteres indicando si el número es positivo, negativo o cero.*/

DELIMITER $$
DROP PROCEDURE IF EXISTS comprobarSigno$$
CREATE PROCEDURE comprobarSigno (num DOUBLE)
BEGIN
	
	DECLARE signo VARCHAR(11);
		
	IF (num<0) THEN
		SET signo = 'Es negativo';
	ELSEIF (num>0) THEN
		SET signo = 'Es positivo';
	ELSE
		SET signo = 'Es cero';
	END IF;
	SELECT signo;
END$$
DELIMITER ;

/*4. Escribe un procedimiento que reciba un número real de entrada, que representa el valor de la nota de un alumno, 
y muestre un mensaje indicando qué nota ha obtenido teniendo en cuenta las siguientes condiciones:
[0,5) = Insuficiente
[5,6) = Aprobado
[6, 7) = Bien
[7, 9) = Notable
[9, 10] = Sobresaliente
En cualquier otro caso la nota no será válida.*/

DELIMITER $$
DROP PROCEDURE IF EXISTS comprobarNota$$
CREATE PROCEDURE comprobarNota (num INT)
BEGIN
	
	IF (num>=0 AND num<5) THEN
		SELECT 'Insuficiente';
	ELSEIF (num>=5 AND num<6) THEN
		SELECT 'Aprobado';
	ELSEIF (num>=6 AND num<7) THEN	
		SELECT 'Bien';
	ELSEIF (num>=7 AND num<9) THEN
		SELECT 'Notable';
	ELSEIF (num>=9 AND num<=10) THEN
		SELECT 'Sobresaliente';
	ELSE
		SELECT 'Nota no valida';
	END IF;
END$$
DELIMITER ;

/*5. Modifique el procedimiento diseñado en el ejercicio anterior para que tenga un parámetro de entrada, con el valor de la nota en formato numérico y un parámetro de salida, 
con una cadena de texto indicando la nota correspondiente.*/

DELIMITER $$
DROP PROCEDURE IF EXISTS comprobarNota$$
CREATE PROCEDURE comprobarNota (num INT)
BEGIN

	DECLARE nota VARCHAR(15);
	
	IF (num>=0 AND num<5) THEN
		SET nota = 'Insuficiente';
	ELSEIF (num>=5 AND num<6) THEN
		SET nota = 'Aprobado';
	ELSEIF (num>=6 AND num<7) THEN	
		SET nota = 'Bien';
	ELSEIF (num>=7 AND num<9) THEN
		SET nota = 'Notable';
	ELSEIF (num>=9 AND num<=10) THEN
		SET nota = 'Sobresaliente';
	ELSE
		SET nota = 'Nota no valida';
	END IF;
	SELECT nota;
END$$
DELIMITER ;

/*6. Resuelva el procedimiento diseñado en el ejercicio anterior haciendo uso de la estructura de control CASE.*/

DELIMITER $$
DROP PROCEDURE IF EXISTS comprobarNota$$
CREATE PROCEDURE comprobarNota (num INT)
BEGIN

	DECLARE nota VARCHAR(15);
	
	CASE 
		WHEN num>=0 AND num<5 THEN SET nota = 'Insuficiente';
		WHEN num>=5 AND num<6 THEN SET nota = 'Aprobado';
		WHEN num>=6 AND num<7 THEN SET nota = 'Bien';
		WHEN num>=7 AND num<9 THEN SET nota = 'Notable';
		WHEN num>=9 AND num<=10 THEN SET nota = 'Sobresaliente';
		ELSE SET nota = 'Nota no valida';
	END CASE;
	SELECT nota;
END$$
DELIMITER ;

/*7. Escribe un procedimiento que reciba como parámetro de entrada un valor numérico que represente un día de la semana y que devuelva una cadena de caracteres 
con el nombre del día de la semana correspondiente. Por ejemplo, para el valor de entrada 1 debería devolver la cadena lunes.*/

DELIMITER $$
DROP PROCEDURE IF EXISTS comprobarDia$$
CREATE PROCEDURE comprobarDia (num INT)
BEGIN

	DECLARE dia VARCHAR(15);
	
	CASE 
		WHEN num=1 THEN SET dia = 'Lunes';
		WHEN num=2 THEN SET dia = 'Martes';
		WHEN num=3 THEN SET dia = 'Miercoles';
		WHEN num=4 THEN SET dia = 'Jueves';
		WHEN num=5 THEN SET dia = 'Viernes';
		WHEN num=6 THEN SET dia = 'Sabado';
		WHEN num=7 THEN SET dia = 'Domingo';
		ELSE SET dia = 'Dia no valido';
	END CASE;
	SELECT dia;
END$$
DELIMITER ;

/***************************************************************************************************************************************************************************************************/
/***************************************************************************************************************************************************************************************************/

/*1.8.2 Procedimientos con sentencias SQL*/
/*1 Escribe un procedimiento que reciba el nombre de un país como parámetro de entrada y realice una consulta sobre la tabla cliente para obtener 
todos los clientes que existen en la tabla de ese país.*/

DROP PROCEDURE IF EXISTS getListClientesPais;
DELIMITER $$
CREATE PROCEDURE getListClientesPais (pais_consulta VARCHAR(50))
BEGIN
	SELECT *
	FROM cliente
	WHERE cliente.pais=pais_consulta;
END$$
DELIMITER ;

CALL getListClientesPais('Spain');

/*2 Escribe un procedimiento que reciba como parámetro de entrada una forma de pago, que será una cadena de caracteres (Ejemplo: PayPal, Transferencia, etc). 
Y devuelva como salida el pago de máximo valor realizado para esa forma de pago. Deberá hacer uso de la tabla pago de la base de datos jardineria.*/

DROP PROCEDURE IF EXISTS getPagoMax;
DELIMITER $$
CREATE PROCEDURE getPagoMax (forma VARCHAR(40))
BEGIN
	SELECT MAX(pago.total) AS MayorPago
	FROM pago
	WHERE pago.forma_pago=forma;
END$$
DELIMITER ;

CALL getPagoMax('PayPal');

/*3 Escribe un procedimiento que reciba como parámetro de entrada una forma de pago, que será una cadena de caracteres (Ejemplo: PayPal, Transferencia, etc). 
Y devuelva como salida los siguientes valores teniendo en cuenta la forma de pago seleccionada como parámetro de entrada:
el pago de máximo valor,
el pago de mínimo valor,
el valor medio de los pagos realizados,
la suma de todos los pagos,
el número de pagos realizados para esa forma de pago.
Deberá hacer uso de la tabla pago de la base de datos jardineria.*/

DROP PROCEDURE IF EXISTS getListFormaPago;
DELIMITER $$
CREATE PROCEDURE getListFormaPago (forma VARCHAR(20))
BEGIN
	SELECT MAX(pago.total) AS MayorPago, MIN(pago.total) AS MenorPago, AVG(pago.total) AS MediaPago, SUM(pago.total) AS SumaPagos, COUNT(pago.codigo_cliente) AS NumPagos
	FROM pago
	WHERE pago.forma_pago=forma;
END$$
DELIMITER ;

CALL getListFormaPago('PayPal');

/*4 Crea una base de datos llamada procedimientos que contenga una tabla llamada cuadrados. La tabla cuadrados debe tener dos columnas de tipo 
INT UNSIGNED, una columna llamada número y otra columna llamada cuadrado. Una vez creada la base de datos y la tabla deberá crear un procedimiento 
llamado calcular_cuadrados con las siguientes características. El procedimiento recibe un parámetro de entrada llamado tope de tipo INT UNSIGNED y 
calculará el valor de los cuadrados de los primeros números naturales hasta el valor introducido como parámetro. El valor del números y de sus 
cuadrados deberán ser almacenados en la tabla cuadrados que hemos creado previamente.*/

DROP DATABASE IF EXISTS procedimientos ;
CREATE DATABASE procedimientos;
USE procedimientos;

CREATE TABLE cuadrados
(
	numero INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	cuadrado INT UNSIGNED
);

/*Tenga en cuenta que el procedimiento deberá eliminar el contenido actual de la tabla antes de insertar los nuevos valores de los cuadrados que 
va a calcular.

Utilice un bucle WHILE para resolver el procedimiento.*/

DROP PROCEDURE IF EXISTS calcular_cuadrados;
DELIMITER $$
CREATE PROCEDURE calcular_cuadrados (tope INT UNSIGNED)
BEGIN
	DECLARE cont INT UNSIGNED DEFAULT 0;
	DELETE FROM cuadrados;
	ALTER TABLE cuadrados AUTO_INCREMENT = 0;
		
	WHILE cont<>tope DO
		INSERT INTO cuadrados (cuadrado) 
		VALUES (POW(cont, 2));
		SET cont=cont+1;
	END WHILE;
		
		
END$$
DELIMITER ;
/*5 Utilice un bucle REPEAT para resolver el procedimiento del ejercicio anterior.*/

DROP PROCEDURE IF EXISTS calcular_cuadrados;
DELIMITER $$
CREATE PROCEDURE calcular_cuadrados (tope INT UNSIGNED)
BEGIN
	DECLARE cont INT UNSIGNED DEFAULT 0;
	DELETE FROM cuadrados;
	ALTER TABLE cuadrados AUTO_INCREMENT = 0;
	
	REPEAT
		INSERT INTO cuadrados (cuadrado) 
		VALUES (POW(cont, 2));
		SET cont=cont+1;
	UNTIL tope=cont END REPEAT;
		
		
END$$
DELIMITER ;

/*6 Utilice un bucle LOOP para resolver el procedimiento del ejercicio anterior.*/

DROP PROCEDURE IF EXISTS calcular_cuadrados;
DELIMITER $$
CREATE PROCEDURE calcular_cuadrados (tope INT UNSIGNED)
BEGIN
	DECLARE cont INT UNSIGNED DEFAULT 0;
	DELETE FROM cuadrados;
	ALTER TABLE cuadrados AUTO_INCREMENT = 0;
	bucle: LOOP
		INSERT INTO cuadrados (cuadrado) 
		VALUES (POW(cont, 2));
		SET cont=cont+1;
		IF (tope=cont) THEN
			LEAVE bucle;
		END IF;
	END LOOP bucle;
END$$
DELIMITER ;

/*7 Crea una base de datos llamada procedimientos que contenga una tabla llamada ejercicio. La tabla debe tener una única columna llamada número y 
el tipo de dato de esta columna debe ser INT UNSIGNED.
Una vez creada la base de datos y la tabla deberá crear un procedimiento llamado calcular_números con las siguientes características. 
El procedimiento recibe un parámetro de entrada llamado valor_inicial de tipo INT UNSIGNED y deberá almacenar en la tabla ejercicio toda la 
secuencia de números desde el valor inicial pasado como entrada hasta el 1.
Tenga en cuenta que el procedimiento deberá eliminar el contenido actual de las tablas antes de insertar los nuevos valores.*/

/*Crear tabla*/
DROP DATABASE IF EXISTS procedimientos ;
CREATE DATABASE procedimientos;
USE procedimientos;

CREATE TABLE ejercicio
(
	numero INT UNSIGNED
);

/*Utilice un bucle WHILE para resolver el procedimiento.*/

DROP PROCEDURE IF EXISTS calcular_números;
DELIMITER $$
CREATE PROCEDURE calcular_números (valor_inicial INT UNSIGNED)
BEGIN
	DELETE FROM ejercicio;
	WHILE valor_inicial>0 DO
		INSERT INTO ejercicio (numero) 
		VALUES (valor_inicial);
		SET valor_inicial=valor_inicial-1;
	END WHILE;		
		
END$$
DELIMITER ;


/*8 Utilice un bucle REPEAT para resolver el procedimiento del ejercicio anterior.*/

DROP PROCEDURE IF EXISTS calcular_números;
DELIMITER $$
CREATE PROCEDURE calcular_números (valor_inicial INT UNSIGNED)
BEGIN
	DELETE FROM ejercicio;
	REPEAT
		INSERT INTO ejercicio (numero) 
		VALUES (valor_inicial);
		SET valor_inicial=valor_inicial-1;
	UNTIL valor_inicial=0 END REPEAT;		
		
END$$
DELIMITER ;

/*9 Utilice un bucle LOOP para resolver el procedimiento del ejercicio anterior.*/

DROP PROCEDURE IF EXISTS calcular_números;
DELIMITER $$
CREATE PROCEDURE calcular_números (valor_inicial INT UNSIGNED)
BEGIN
	DELETE FROM ejercicio;
	bucle: LOOP
		INSERT INTO ejercicio (numero) 
		VALUES (valor_inicial);
		SET valor_inicial=valor_inicial-1;
		IF (valor_inicial=0) THEN
				LEAVE bucle;
		END IF;
	END LOOP bucle;	
END$$
DELIMITER ;

/*10 Crea una base de datos llamada procedimientos que contenga una tabla llamada pares y otra tabla llamada impares. Las dos tablas deben tener 
única columna llamada número y el tipo de dato de esta columna debe ser INT UNSIGNED. Una vez creada la base de datos y las tablas deberá crear 
un procedimiento llamado calcular_pares_impares con las siguientes características. El procedimiento recibe un parámetro de entrada llamado tope 
de tipo INT UNSIGNED y deberá almacenar en la tabla pares aquellos números pares que existan entre el número 1 el valor introducido como parámetro. 
Habrá que realizar la misma operación para almacenar los números impares en la tabla impares.*/

DROP DATABASE IF EXISTS procedimientos ;
CREATE DATABASE procedimientos;
USE procedimientos;

CREATE TABLE pares
(
	numero INT UNSIGNED
);

CREATE TABLE impares
(
	numero INT UNSIGNED
);

/*Tenga en cuenta que el procedimiento deberá eliminar el contenido actual de las tablas antes de insertar los nuevos valores.*/

/*Utilice un bucle WHILE para resolver el procedimiento.*/

DROP PROCEDURE IF EXISTS calcular_pares_impares;
DELIMITER $$
CREATE PROCEDURE calcular_pares_impares (tope INT UNSIGNED)
BEGIN
	DECLARE cont INT UNSIGNED DEFAULT 0;
	DELETE FROM pares;
	DELETE FROM impares;
			
	WHILE cont<>tope DO
		SET cont=cont+1;
		IF(cont%2=0) THEN 
			INSERT INTO pares (numero) 
			VALUES (cont);
		ELSE
			INSERT INTO impares (numero) 
			VALUES (cont);
		END IF;
	END WHILE;		
		
END$$
DELIMITER ;

/*11 Utilice un bucle REPEAT para resolver el procedimiento del ejercicio anterior.*/

DROP PROCEDURE IF EXISTS calcular_pares_impares;
DELIMITER $$
CREATE PROCEDURE calcular_pares_impares (tope INT UNSIGNED)
BEGIN
	DECLARE cont INT UNSIGNED DEFAULT 0;
	DELETE FROM pares;
	DELETE FROM impares;
			
	REPEAT
		SET cont=cont+1;
		IF(cont%2=0) THEN 
			INSERT INTO pares (numero) 
			VALUES (cont);
		ELSE
			INSERT INTO impares (numero) 
			VALUES (cont);
		END IF;
	UNTIL cont=tope END REPEAT;		
		
END$$
DELIMITER ;

/*12 Utilice un bucle LOOP para resolver el procedimiento del ejercicio anterior.*/

DROP PROCEDURE IF EXISTS calcular_pares_impares;
DELIMITER $$
CREATE PROCEDURE calcular_pares_impares (tope INT UNSIGNED)
BEGIN
	DECLARE cont INT UNSIGNED DEFAULT 0;
	DELETE FROM pares;
	DELETE FROM impares;
			
   bucle: LOOP
		SET cont=cont+1;
		IF(cont%2=0) THEN 
			INSERT INTO pares (numero) 
			VALUES (cont);
		ELSE
			INSERT INTO impares (numero) 
			VALUES (cont);
		END IF;
	IF (tope=cont) THEN
				LEAVE bucle;
		END IF;
	END LOOP bucle;		
		
END$$
DELIMITER ;

/***************************************************************************************************************************************************************************************************/
/***************************************************************************************************************************************************************************************************/

/*1.8.3 Funciones sin sentencias SQL*/
/*1. Escribe una función que reciba un número entero de entrada y devuelva TRUE si el número es par o FALSE en caso contrario.*/

DELIMITER $$
DROP FUNCTION IF EXISTS esPar$$
CREATE FUNCTION esPar(num INT) RETURNS VARCHAR(5)
BEGIN
	DECLARE espar VARCHAR(5) DEFAULT 'TRUE';
	DECLARE resto INT DEFAULT num%2;
	IF (resto <> 0) THEN
		SET espar = 'FALSE';
	END IF;	
	RETURN espar;
END$$
DELIMITER ;

/*2. Escribe una función que devuelva el valor de la hipotenusa de un triángulo a partir de los valores de sus lados.*/

DELIMITER $$
DROP FUNCTION IF EXISTS calcularHipotenusa$$
CREATE FUNCTION calcularHipotenusa(lado1 INT, lado2 INT) RETURNS FLOAT
BEGIN
	RETURN SQRT(POW(lado1, 2)+POW(lado2, 2));
END$$
DELIMITER ;

/*3. Escribe una función que reciba como parámetro de entrada un valor numérico que represente un día de la semana y que devuelva una cadena de 
caracteres con el nombre del día de la semana correspondiente. 
Por ejemplo, para el valor de entrada 1 debería devolver la cadena lunes.*/

DELIMITER $$
DROP FUNCTION IF EXISTS comprobarDia$$
CREATE FUNCTION comprobarDia(num INT) RETURNS VARCHAR (15) 
BEGIN

	DECLARE dia VARCHAR(15);
	
	CASE num
		WHEN 1 THEN SET dia = 'Lunes';
		WHEN 2 THEN SET dia = 'Martes';
		WHEN 3 THEN SET dia = 'Miercoles';
		WHEN 4 THEN SET dia = 'Jueves';
		WHEN 5 THEN SET dia = 'Viernes';
		WHEN 6 THEN SET dia = 'Sabado';
		WHEN 7 THEN SET dia = 'Domingo';
		ELSE SET dia = 'Dia no valido';
	END CASE;
	RETURN dia;
END$$
DELIMITER ;

/*4. Escribe una función que reciba tres números reales como parámetros de entrada y devuelva el mayor de los tres.*/

DELIMITER $$
DROP FUNCTION IF EXISTS listMayor$$
CREATE FUNCTION listMayor(num1 INT, num2 INT, num3 INT) RETURNS INT
BEGIN
	DECLARE mayor INT DEFAULT num1;
	IF (num2>mayor) THEN
		SET mayor = num2;
	ELSEIF (num3>mayor) THEN
		SET mayor = num3;
	END IF;	
	RETURN mayor;
END$$
DELIMITER ;

/*5. Escribe una función que devuelva el valor del área de un círculo a partir del valor del radio que se recibirá como parámetro de entrada.*/

DELIMITER $$
DROP FUNCTION IF EXISTS areaCirculo$$
CREATE FUNCTION areaCirculo(radio INT) RETURNS FLOAT
BEGIN
	RETURN PI()*POW(radio,2);
END$$
DELIMITER ;

/*6. Escribe una función que devuelva como salida el número de años que han transcurrido entre dos fechas que se reciben como parámetros de entrada. 
Por ejemplo, si pasamos como parámetros de entrada las fechas 2018-01-01 y 2008-01-01 la función tiene que devolver que han pasado 10 años.
Para realizar esta función puede hacer uso de las siguientes funciones que nos proporciona MySQL:

DATEDIFF
TRUNCATE*/

DELIMITER $$
DROP FUNCTION IF EXISTS calcularAnios$$
CREATE FUNCTION calcularAnios(fecha1 DATE, fecha2 DATE) RETURNS INT
BEGIN
	RETURN TRUNCATE(DATEDIFF(fecha1 , fecha2)/365, 0);
END$$
DELIMITER ;

/*7. Escribe una función que reciba una cadena de entrada y devuelva la misma cadena pero sin acentos. La función tendrá que reemplazar todas las
 vocales que tengan acento por la misma vocal pero sin acento.
 ejemplo, si la función recibe como parámetro de entrada la cadena María la función debe devolver la cadena Maria.*/

DELIMITER $$
DROP FUNCTION IF EXISTS quitarAcentos$$
CREATE FUNCTION quitarAcentos(palabra VARCHAR(20)) RETURNS VARCHAR(20)
BEGIN
	RETURN REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(palabra, 'á', 'a'),'é', 'e'),'í', 'i'),'ó', 'o'),'ú', 'u');
END$$
DELIMITER ;

/***************************************************************************************************************************************************************************************************/
/***************************************************************************************************************************************************************************************************/

/*1.8.4 Funciones con sentencias SQL*/
/*1. Escribe una función para la base de datos tienda que devuelva el número total de productos que hay en la tabla productos.*/

DELIMITER $$
DROP FUNCTION IF EXISTS contarProductos$$
CREATE FUNCTION contarProductos() RETURNS INT 
BEGIN
	DECLARE num_productos INT DEFAULT 0;
	SELECT COUNT(codigo)
	INTO num_productos
	FROM producto;
	RETURN num_productos;
END$$
DELIMITER ;

/*2. Escribe una función para la base de datos tienda que devuelva el valor medio del precio de los productos de un determinado fabricante que se 
recibirá como parámetro de entrada. El parámetro de entrada será el nombre del fabricante.*/

DELIMITER $$
DROP FUNCTION IF EXISTS mediaFabricante$$
CREATE FUNCTION mediaFabricante(nombre_fabr VARCHAR(100)) RETURNS DOUBLE 
BEGIN

	DECLARE media INT DEFAULT 0;
	SELECT AVG(producto.precio)
	INTO media
	FROM producto, fabricante
	WHERE producto.codigo_fabricante=fabricante.codigo AND fabricante.nombre=nombre_fabr;
	RETURN media;
END$$
DELIMITER ;

/*3. Escribe una función para la base de datos tienda que devuelva el valor máximo del precio de los productos de un determinado fabricante 
que se recibirá como parámetro de entrada. El parámetro de entrada será el nombre del fabricante.*/

DELIMITER $$
DROP FUNCTION IF EXISTS maximoFabricante$$
CREATE FUNCTION maximoFabricante(nombre_fabr VARCHAR(100)) RETURNS INT 
BEGIN

	DECLARE maximo INT DEFAULT 0;
	SELECT MAX(producto.precio)
	INTO maximo
	FROM producto, fabricante
	WHERE producto.codigo_fabricante=fabricante.codigo AND fabricante.nombre=nombre_fabr;
	RETURN maximo;
END$$
DELIMITER ;

/*4. Escribe una función para la base de datos tienda que devuelva el valor mínimo del precio de los productos de un determinado fabricante que se 
recibirá como parámetro de entrada. El parámetro de entrada será el nombre del fabricante.*/

DELIMITER $$
DROP FUNCTION IF EXISTS minimoFabricante$$
CREATE FUNCTION minimoFabricante(nombre_fabr VARCHAR(20)) RETURNS INT 
BEGIN

	DECLARE minimo INT DEFAULT 0;
	SELECT MIN(producto.precio)
	INTO minimo
	FROM producto, fabricante
	WHERE producto.codigo_fabricante=fabricante.codigo AND fabricante.nombre=nombre_fabr;
	
	RETURN minimo;
END$$
DELIMITER ;