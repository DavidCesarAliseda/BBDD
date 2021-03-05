/*Base de datos jardineria*/
/*1. Crear un procedimiento que sirva para listar los códigos y nombres de los clientes*/

USE jardineria;
DROP PROCEDURE IF EXISTS getListaCodNomClientes;
DELIMITER $$
CREATE PROCEDURE getListaCodNomClientes ()
BEGIN
		SELECT cliente.codigo_cliente, cliente.nombre_cliente
		FROM cliente
		; 
	END$$
DELIMITER ;

/*2. Mostrar el procedimiento del apartado 1*/

SHOW PROCEDURE STATUS WHERE Db = 'jardineria';

/*3. Invocar al procedimiento del apartado 1*/

CALL getListaCodNomClientes;

/*4. Modificar el procedimiento (comentario)*/

ALTER PROCEDURE getListaCodNomClientes
COMMENT 'Muestra codigo y nombre de los clientes';

/*5. Crear un procedimiento de prueba y borrarlo*/

DROP PROCEDURE IF EXISTS getPagosSuperiorA;
DELIMITER $$
CREATE PROCEDURE getPagosSuperiorA (x INT)
BEGIN
		SELECT pago.*
		FROM pago
		WHERE pago.total>x
		; 
	END$$
DELIMITER ;

DROP PROCEDURE getPagosSuperiorA;

/*6. Crea un procedimiento que muestre cuántos productos pertenecen a la gama
‘Herbáceas’*/

DROP PROCEDURE IF EXISTS getProductosHerbaceas;
DELIMITER $$
CREATE PROCEDURE getProductosHerbaceas ()
BEGIN
		SELECT COUNT(producto.codigo_producto) AS NumProductos
		FROM producto
		WHERE gama='Herbaceas'
		; 
	END$$
DELIMITER ;

/*a. Modifica el procedimiento anterior y añádele un comentario que describa lo
que devuelve el procedimiento.*/

ALTER PROCEDURE getProductosHerbaceas
COMMENT 'Muestra numero de productos de la gama Herbaceas';

/*b. Ejecuta el procedimiento para comprobar que funciona*/

CALL getProductosHerbaceas;

/*c. Muestra con una orden SQL, el contenido del procedimiento*/

SHOW PROCEDURE STATUS WHERE Db = 'jardineria';

/*7. Crea un procedimiento que muestre el nombre de los empleados que estén
trabajando en la oficina de Barcelona*/

DROP PROCEDURE IF EXISTS getEmpleadosBarcelona;
DELIMITER $$
CREATE PROCEDURE getEmpleadosBarcelona ()
BEGIN
		SELECT empleado.nombre
		FROM empleado, oficina
		WHERE empleado.codigo_oficina=oficina.codigo_oficina AND oficina.ciudad='Barcelona';
	END$$
DELIMITER ;

/*a. Ejecuta el procedimiento para comprobar que funciona*/

CALL getEmpleadosBarcelona;

/*8. Crea un procedimiento que muestre el listado de los productos cuyo stock supere los 100*/

DROP PROCEDURE IF EXISTS getProdStockSup100;
DELIMITER $$
CREATE PROCEDURE getProdStockSup100 ()
BEGIN
		SELECT producto.*
		FROM producto
		WHERE producto.cantidad_en_stock>100;
	END$$
DELIMITER ;

/*a. Ejecuta el procedimiento para comprobar que funciona*/

CALL getProdStockSup100;

/*9. Crea y muestra un procedimiento que nos de todos los datos de los productos que
tienen un precio mayor a x (x se va a recibir por parámetro en el procedimiento)*/

DROP PROCEDURE IF EXISTS PrecioMayorX;
DELIMITER $$
CREATE PROCEDURE PrecioMayorX (x INT)
BEGIN
		SELECT producto.*
		FROM producto
		WHERE producto.precio_venta > x;
	END$$
DELIMITER ;

/*10. Crea un procedimiento al que se le pase como parámetro la ciudad del cliente y nos
muestre el nombre y teléfono de esos clientes*/

DROP PROCEDURE IF EXISTS getClientesDe;
DELIMITER $$
CREATE PROCEDURE getClientesDe (x VARCHAR(30))
BEGIN
		SELECT cliente.nombre_cliente, cliente.telefono
		FROM cliente
		WHERE cliente.ciudad=x;
	END$$
DELIMITER ;

/*11. Crea e invoca a un procedimiento que salude con la frase “Hola, buenos días”,
tantas veces como indique el parámetro num que recibe por parámetro.*/

DELIMITER $$
DROP PROCEDURE IF EXISTS ReapeatHola $$
CREATE PROCEDURE ReapeatHola(num INT) 
BEGIN
	REPEAT
		SET num=num-1;
		SELECT 'Hola, buenos días';
		
	UNTIL num=0 END REPEAT;
END
$$

/*Base de datos robotica*/
/*1. Diseñar un procedimiento que muestre todos los empleados.*/

USE robotica;
DROP PROCEDURE IF EXISTS getEmpleados;
DELIMITER $$
CREATE PROCEDURE getEmpleados ()
BEGIN
		SELECT empleados.*
		FROM empleados
		;
	END$$
DELIMITER ;

/*2. Mostrar todos los empleados mayores de una edad determinada, ésta se pasará
como parámetro al procedimiento*/

USE robotica;
DROP PROCEDURE IF EXISTS getEmpleadosMayores;
DELIMITER $$
CREATE PROCEDURE getEmpleadosMayores (x INT)
BEGIN
		SELECT empleados.*
		FROM empleados
		WHERE (YEAR(SYSDATE())-YEAR(empleados.fechanac))>x
		;
	END$$
DELIMITER ;

/*3. Diseñar un procedimiento que según el número de empleados nos muestre:
“Pequeña o mediana empresa” si el número de empleados es menor o igual que 10.
En caso contrario debe mostrar: “Gran empresa”.*/

DROP PROCEDURE IF EXISTS getTamanioEmpresa;
DELIMITER $$
CREATE PROCEDURE getTamanioEmpresa ()
BEGIN
		DECLARE Tamanio VARCHAR(30);
		DECLARE numEmp INT DEFAULT 0;
		
		SELECT COUNT(empleados.dni) 
		 INTO numEmp
		FROM empleados;
		
		IF (numEmp<=10) THEN
			SET Tamanio='Pequeña o mediana empresa';
		ELSE 
			SET Tamanio='Gran empresa';
		END IF;
		SELECT Tamanio
		;
	END$$
DELIMITER ;

/*4. Diseñar un procedimiento que según el número total de horas de trabajo de todos
los proyectos (en Robótica) muestre:*/
/*a. Si el número total de horas de trabajo es menor que 25: debe mostrar el
nombre de todos los empleados (para notificarles que el rendimiento es muy
bajo).*/

/*b. Si el número total de horas se encuentra entre 25 y 100: debe mostrar un
mensaje indicado que todo es normal.*/

/*c. Y otro caso: (como el número de horas es elevado) premiar a los empleados
incrementando su sueldo en un 10 %.*/

USE robotica;
DROP PROCEDURE IF EXISTS getHorasProyecto;
DELIMITER $$
CREATE PROCEDURE getHorasProyecto ()
BEGIN
		DECLARE NumP INT DEFAULT 0;
		DECLARE Horas INT DEFAULT 0;
		DECLARE S VARCHAR(60);
		DECLARE PMax INT DEFAULT 0;
		
		SELECT MAX(trabaja_en.nump)
		INTO PMax
		FROM trabaja_en;
				
		REPEAT
			SET NumP = NumP+1;
			SET Horas = 0;
			SELECT SUM(trabaja_en.horas)
			INTO Horas
			FROM trabaja_en
			WHERE trabaja_en.nump=NumP;
			
			IF (Horas<25) THEN
				SELECT CONCAT(empleados.nombre)
				INTO S
				FROM empleados, trabaja_en
				WHERE empleados.dni=trabaja_en.dni AND trabaja_en.nump=NumP;
			ELSEIF (Horas>=25 AND Horas<100) THEN 
				SET S = 'Todo es normal';
			ELSE
				SELECT empleados.nombre, (empleados.salario+empleados.salario*10/100) AS NuevoSalario
				FROM empleados, trabaja_en
				WHERE empleados.dni=trabaja_en.dni AND trabaja_en.nump=NumP;
			END IF;
			SELECT S;
		UNTIL NumP>Pmax END REPEAT;
		
			
	END$$
DELIMITER ;

CALL robotica.getHorasProyecto();


