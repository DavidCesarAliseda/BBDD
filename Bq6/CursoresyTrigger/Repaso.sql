/*Crear un disparador que cada vez que se inserta un empleado sustituya su nombre
por “Pepe”.*/
DELIMITER $$
DROP TRIGGER IF EXISTS cambiar_nombre_por_pepe$$
CREATE TRIGGER cambiar_nombre_por_pepe
BEFORE INSERT 
ON empleados FOR EACH ROW
BEGIN
  SET NEW.nombre = 'Pepe';
END$$
/* Escribir un disparador, que cada vez que se modifique un empleado, añada “Don” al
principio de su nombre.*/
DELIMITER $$
DROP TRIGGER IF EXISTS añadir_don_nombre_v1$$
CREATE TRIGGER añadir_don_nombre_v1
BEFORE UPDATE 
ON empleados FOR EACH ROW
BEGIN
	IF (NEW.nombre NOT LIKE 'Don %') THEN
  		SET NEW.nombre = CONCAT('Don ', NEW.nombre);	
   END IF;
END$$
/*Realizar una versión mejorada del ejercicio anterior donde se compruebe que se
desea modificar el campo nombre.*/
DELIMITER $$
DROP TRIGGER IF EXISTS añadir_don_nombre_v2$$
CREATE TRIGGER añadir_don_nombre_v2
BEFORE UPDATE 
ON empleados FOR EACH ROW
BEGIN
	IF (NEW.nombre <> OLD.nombre) THEN
  		SET NEW.nombre = CONCAT('Don ', NEW.nombre);	
   END IF;
END$$
/*En Empresa, diseñar un disparador que compruebe cada vez que insertamos un
empleado que su edad esté comprendida entre 16 –edad mínima para trabajar– y 67
–edad de jubilación–.*/
DELIMITER $$
DROP TRIGGER IF EXISTS edad_minima_maxima$$
CREATE TRIGGER edad_minima_maxima
BEFORE INSERT
ON empleados FOR EACH ROW
BEGIN
    IF (NEW.edad<16) THEN
      SET NEW.edad=16;
    ELSEIF (NEW.edad>67) THEN
      SET NEW.edad=67;
    END IF;
END
$$
/*Escribir un disparador que supervise los traslados de los empleados. Éstos pueden
moverse a otra oficina, pero el traslado ha de cumplir que sea a una oficina dentro
de la misma región a la que están asignados. Es decir, si un empleado trabaja en
una oficina del ‘Este’ podrá trasladarse a cualquier otra oficina, pero siempre dentro
de la región ‘Este’.
*/
DELIMITER $$
DROP TRIGGER IF EXISTS cambiar_ofi$$
CREATE TRIGGER cambiar_ofi
BEFORE UPDATE
ON empleados FOR EACH ROW
BEGIN
	DECLARE ofi1 INT DEFAULT 0;
	DECLARE ofi2 INT DEFAULT 0;
	DECLARE region1 VARCHAR(20);
	DECLARE region2 VARCHAR(20);
	
	SET ofi1 = OLD.oficina;
	SET ofi2 = NEW.oficina;

	SELECT oficinas.region
	INTO region1
	FROM oficinas
	WHERE oficinas.oficina=ofi1;
	
	SELECT oficinas.region
	INTO region2
	FROM oficinas
	WHERE oficinas.oficina=ofi2;
	
	IF (region1<>region2) THEN
		SET NEW.oficina=OLD.oficina;
	END IF;

END$$

/*6. Crear un trigger para gestionar una copia de seguridad de todos los clientes:
actuales y eliminados. Para cada uno especificaremos el nombre, el límite de crédito
y la fecha de alta. Para almacenar estos datos dispondremos de la tabla «backupClientes». 
Crear también un procedimiento almacenado que cree la nueva
tabla y haga una copia de los clientes actuales.
*/

DELIMITER $$
DROP PROCEDURE IF EXISTS crear_backupClientes$$
CREATE PROCEDURE crear_backupClientes() 
BEGIN
	DECLARE limite_temp INT(10) DEFAULT 0;
	DECLARE nombre_temp VARCHAR(30);
	DECLARE numclie_temp INT DEFAULT 0;
	DECLARE done INT DEFAULT 0;
	DECLARE cur CURSOR FOR SELECT numclie FROM clientes; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	CREATE TABLE backupClientes
	(
	id_copiaseguridad INT(10) AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR(30), 
   limitecredito INT(10),
	fecha_alta DATE DEFAULT SYSDATE() 
	);
	
	OPEN cur;
	REPEAT 
		FETCH cur INTO numclie_temp;
		IF NOT done THEN
			SELECT clientes.nombre INTO nombre_temp
			FROM clientes
			WHERE clientes.numclie=numclie_temp;
		
			SELECT clientes.limitecredito INTO limite_temp
			FROM clientes
			WHERE clientes.numclie=numclie_temp;
		
			INSERT INTO backupClientes(nombre, limitecredito)
			VALUES (nombre_temp,limite_temp);
		END IF;
	UNTIL done END REPEAT;
	CLOSE cur;
	
END$$
/*Mediante un procedimiento, añadir el campo orden con un valor consecutivo que
ordene a los empleados según la antigüedad del contrato. Si dos empleados tienen
la misma antigüedad se ordenarán alfabéticamente. Tras añadir el nuevo campo y
asignarle valor, se elimina de la tabla el campo contrato*/

DELIMITER $$
DROP PROCEDURE IF EXISTS orden_antiguedad$$
CREATE PROCEDURE orden_antiguedad() 
BEGIN
	DECLARE numemp_temp INT DEFAULT 0;
	DECLARE contador INT DEFAULT 1;
	DECLARE done INT DEFAULT 0;
	DECLARE cur CURSOR FOR SELECT numemp FROM empleados ORDER BY contrato, nombre; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN cur;

	REPEAT 
		FETCH cur INTO numemp_temp;
		IF NOT done THEN
			UPDATE empleados
			SET orden = contador
			WHERE numemp_temp=empleados.numemp ;
			SET contador=contador+1;
		END IF;	
	UNTIL done END REPEAT;
	CLOSE cur;
END$$

/*Utilizando dos cursores (este ejercicio se podría hacer simplemente con un JOIN)
mostrar para cada empleado el importe de pedidos del que es responsable*/
DELIMITER $$
DROP PROCEDURE IF EXISTS num_pedidos$$
CREATE PROCEDURE num_pedidos() 
BEGIN
	DECLARE importe_temp INT DEFAULT 0;
	DECLARE resp_temp INT DEFAULT 0;
	DECLARE done INT DEFAULT 0;
	DECLARE cur CURSOR FOR SELECT resp, SUM(importe) FROM pedidos GROUP BY resp; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN cur;

	REPEAT 
		FETCH cur INTO resp_temp, importe_temp;
		IF NOT done THEN
			SELECT resp_temp, importe_temp;
		END IF;	
	UNTIL done END REPEAT;
	CLOSE cur;
END$$

/*La empresa ha decidido que no pueden existir oficinas sin objetivos
marcados.Mediante un cursor asignar a cada oficina sin objetivo (null) el objetivo que
tiene asignado la oficina anterior en la tabla. En el caso que la primera oficina de la
tabla no tenga objetivo asignarle por defecto 10.000 euros.*/
DELIMITER $$
DROP PROCEDURE IF EXISTS asignar_objetivo$$
CREATE PROCEDURE asignar_objetivo() 
BEGIN
	DECLARE obj_temp INT DEFAULT 0;
	DECLARE oficina_temp INT DEFAULT 0;
	DECLARE done INT DEFAULT 0;
	DECLARE cur CURSOR FOR SELECT oficina FROM oficinas; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	OPEN cur;
	FETCH cur INTO oficina_temp;
	IF (oficinas.objetivo IS NULL) THEN
		SET oficinas.objetivo=10000;
	END IF;
	SET obj_temp = oficinas.objetivo
	WHERE oficinas.oficina=oficina_temp;
	
	REPEAT 
		FETCH cur INTO oficina_temp;
		IF NOT done THEN
			IF (oficinas.objetivo IS NULL) THEN
				SET oficinas.objetivo=obj_temp
				WHERE oficinas.oficina=oficina_temp;
			END IF;
			SET obj_temp=oficinas.objetivo
			WHERE oficinas.oficina=oficina_temp;
		END IF;	
	UNTIL done END REPEAT;
	CLOSE cur;
END$$
/*------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------------------*/
/*1. Mostrar los empleados que trabajan en bares con terrazas*/
SELECT empleados.dni
FROM empleados, bares
WHERE empleados.bar=bares.nombre AND bares.tieneTerraza=1;
/*2. Mostrar los empleados que trabajan en bares donde que no tienen terrazas*/
SELECT empleados.dni
FROM empleados, bares
WHERE empleados.bar=bares.nombre AND bares.tieneTerraza=0;
/*3. Realizar una consulta que muestre el vino o los vinos más baratos que existen.*/
SELECT vinos.*
FROM vinos
WHERE vinos.precio=(
							SELECT MIN(vinos.precio)
							FROM vinos
);
/*4. Igual que la consulta anterior pero mostrando los más caros.*/
SELECT vinos.*
FROM vinos
WHERE vinos.precio=(
							SELECT MAX(vinos.precio)
							FROM vinos
);
/*5. Unir las dos consultas anteriores y mostrar lo peores y los mejores vinos*/
SELECT vinos.*
FROM vinos
WHERE vinos.precio=(
							SELECT MAX(vinos.precio)
							FROM vinos
)
OR vinos.precio=(
							SELECT MIN(vinos.precio)
							FROM vinos
);
/*6. Mostrar los bares que dispongan de los vinos obtenidos en la consulta anterior.*/
SELECT bares.*
FROM bares, bodega, vinos
WHERE bares.nombre=bodega.bar 
AND bodega.vino=vinos.cod 
AND (vinos.precio=(SELECT MIN(vinos.precio) FROM vinos) OR vinos.precio=(SELECT MAX(vinos.precio) FROM vinos));
/*7. Mostrar el número de botellas de las que dispone cada bar.*/
SELECT SUM(bodega.existencias), bares.nombre
FROM bodega
INNER JOIN bares
ON bodega.bar=bares.nombre
GROUP BY bares.nombre;
/*8. En este ejercicio no nos interesa el número concretos de botellas, en su lugar,
queremos saber cuántos vinos distintos (marcas de vinos) tiene disponible cada bar*/
SELECT COUNT(bodega.existencias), bares.nombre
FROM bodega
INNER JOIN bares
ON bodega.bar=bares.nombre
GROUP BY bares.nombre
/*9. Ahora nos interesa cuántos tipos de vino distinto (Ribera, Albariño, etc.) tiene
disponible cada bar.*/
SELECT COUNT(vinos.tipo), bodega.bar
FROM bodega, vinos
WHERE bodega.vino=vinos.cod
GROUP BY bodega.bar
/*10. Un bar de calidad es aquel que tiene un empleado por cada cliente. Mostrar los
bares que tienen más empleados que el número máximo de clientes (capacidad).
*/
SELECT bares.nombre, COUNT(empleados.dni) AS NumEmpleados, bares.capacidad
FROM bares, empleados
WHERE empleados.bar=bares.nombre
GROUP BY bares.nombre
HAVING bares.capacidad=COUNT(empleados.dni);
/*11. Mostrar los bares que no tienen empleados.*/
SELECT bares.nombre
FROM bares
WHERE bares.nombre NOT IN (SELECT empleados.bar FROM empleados)
