/*1.4.4 Consultas sobre una tabla

/*Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.*/
SELECT codigo_oficina, ciudad
FROM oficina;

/*Devuelve un listado con la ciudad y el teléfono de las oficinas de España.*/
SELECT ciudad, telefono
FROM oficina
WHERE pais='España';

/*Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7.*/
SELECT nombre, apellido1, apellido2, email
FROM empleado
WHERE codigo_jefe=7;

/*Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.*/
SELECT puesto, nombre, apellido1, apellido2, email
FROM empleado
WHERE codigo_jefe IS NULL;

/*Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean representantes de ventas.*/
SELECT nombre, apellido1, apellido2, puesto
FROM empleado
WHERE puesto NOT LIKE 'Representante Ventas';

/*Devuelve un listado con el nombre de los todos los clientes españoles.*/
SELECT nombre_cliente
FROM cliente
WHERE pais='Spain';

/*Devuelve un listado con los distintos estados por los que puede pasar un pedido.*/
SELECT estado
FROM pedido
GROUP BY estado;

/*Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2008. Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan repetidos. Resuelva la consulta:
	Utilizando la función YEAR de MySQL.*/
SELECT DISTINCT codigo_cliente
FROM pago
WHERE YEAR(fecha_pago)=2008;

	/*Utilizando la función DATE_FORMAT de MySQL.*/
SELECT DISTINCT codigo_cliente
FROM pago
WHERE DATE_FORMAT(fecha_pago, '%Y')=2008;

	/*Sin utilizar ninguna de las funciones anteriores.*/
SELECT DISTINCT codigo_cliente
FROM pago
WHERE fecha_pago BETWEEN '2008-01-01' AND '2008-12-31' ;

/*Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos que no han sido entregados a tiempo.*/
SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
FROM pedido
WHERE fecha_entrega>fecha_esperada;

/*Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada.
Utilizando la función ADDDATE de MySQL.*/
SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
FROM pedido
WHERE ADDDATE(fecha_entrega, 2) <= fecha_esperada;

/*Utilizando la función DATEDIFF de MySQL.*/
SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
FROM pedido
WHERE DATEDIFF(fecha_esperada, fecha_entrega) >= 2;

/*Devuelve un listado de todos los pedidos que fueron rechazados en 2009.*/
SELECT *
FROM pedido
WHERE estado='Rechazado' AND YEAR(fecha_entrega)=2009;

/*Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de cualquier año.*/
SELECT *
FROM pedido
WHERE estado='Entregado' AND MONTH(fecha_entrega)=01;

/*Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal. Ordene el resultado de mayor a menor.*/
SELECT total
FROM pago
WHERE YEAR(fecha_pago)=2008 AND forma_pago='PayPal'
ORDER BY total DESC;

/*Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. Tenga en cuenta que no deben aparecer formas de pago repetidas.*/
SELECT forma_pago
FROM pago
GROUP BY forma_pago;

/*Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que tienen más de 100 unidades en stock. El listado deberá estar ordenado por su precio de venta, mostrando en primer lugar los de mayor precio.*/
SELECT *
FROM producto
WHERE gama='Ornamentales' AND cantidad_en_stock>100
ORDER BY precio_venta DESC;

/*Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo representante de ventas tenga el código de empleado 11 o 30.*/
SELECT codigo_cliente, nombre_cliente, ciudad
FROM cliente
WHERE ciudad='Madrid' AND (codigo_empleado_rep_ventas=11 OR codigo_empleado_rep_ventas=30);

/*1.4.5 Consultas multitabla (Composición interna)
Resuelva todas las consultas utilizando la sintaxis de SQL1 y SQL2. Las consultas con sintaxis de SQL2 se deben resolver con INNER JOIN y NATURAL JOIN.*/

/*Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas.*/
/*SQL1*/
SELECT nombre_cliente, nombre, apellido1, apellido2
FROM cliente, empleado
WHERE cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado;

/*SQL2*/
SELECT nombre_cliente, nombre, apellido1, apellido2
FROM cliente INNER JOIN empleado
ON cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado;

/*Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas.*/
/*SQL1*/
SELECT nombre_cliente, nombre
FROM cliente, pago, empleado
WHERE cliente.codigo_cliente = pago.codigo_cliente AND cliente.codigo_empleado_rep_ventas=empleado.codigo_empleado;

/*SQL2*/
SELECT nombre_cliente, nombre
FROM cliente INNER JOIN pago
ON cliente.codigo_cliente = pago.codigo_cliente
INNER JOIN empleado
ON cliente.codigo_empleado_rep_ventas=empleado.codigo_empleado;

/*Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de sus representantes de ventas.*/
/*SQL1*/
SELECT nombre_cliente, nombre
FROM cliente, empleado
WHERE cliente.codigo_empleado_rep_ventas=empleado.codigo_empleado AND cliente.codigo_cliente NOT IN
(
	SELECT codigo_cliente
	FROM pago
);

/*SQL2*/
SELECT nombre_cliente, nombre
FROM cliente INNER JOIN empleado
ON cliente.codigo_empleado_rep_ventas=empleado.codigo_empleado AND cliente.codigo_cliente NOT IN
(
	SELECT codigo_cliente
	FROM pago
);

/*Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.*/
/*SQL1*/
SELECT cliente.nombre_cliente, empleado.nombre, oficina.ciudad
FROM cliente, pago, empleado, oficina
WHERE cliente.codigo_cliente=pago.codigo_cliente AND cliente.codigo_empleado_rep_ventas=empleado.codigo_empleado AND empleado.codigo_oficina=oficina.codigo_oficina;

/*SQL2*/
SELECT cliente.nombre_cliente, empleado.nombre, oficina.ciudad
FROM cliente INNER JOIN pago
ON cliente.codigo_cliente=pago.codigo_cliente
INNER JOIN empleado
ON cliente.codigo_empleado_rep_ventas=empleado.codigo_empleado
INNER JOIN oficina
ON empleado.codigo_oficina=oficina.codigo_oficina;

/*Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.*/
/*SQL1*/
SELECT cliente.nombre_cliente, empleado.nombre, oficina.ciudad
FROM cliente, pago, empleado, oficina
WHERE cliente.codigo_empleado_rep_ventas=empleado.codigo_empleado AND empleado.codigo_oficina=oficina.codigo_oficina AND cliente.codigo_cliente NOT IN
(
	SELECT codigo_cliente
	FROM pago
);

/*SQL2*/
SELECT cliente.nombre_cliente, empleado.nombre, oficina.ciudad
FROM empleado INNER JOIN oficina
ON empleado.codigo_oficina=oficina.codigo_oficina
INNER JOIN cliente
ON cliente.codigo_empleado_rep_ventas=empleado.codigo_empleado AND cliente.codigo_cliente NOT IN
(
	SELECT codigo_cliente
	FROM pago
);

/*Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.*/
/*SQL1*/
SELECT oficina.linea_direccion1, oficina.linea_direccion2
FROM cliente, oficina, empleado
WHERE cliente.ciudad='Fuenlabrada' AND oficina.codigo_oficina=empleado.codigo_oficina AND empleado.codigo_empleado=cliente.codigo_empleado_rep_ventas;

/*SQL2*/
SELECT oficina.linea_direccion1, oficina.linea_direccion2
FROM cliente INNER JOIN  oficina
ON cliente.ciudad='Fuenlabrada' 
INNER JOIN empleado
ON oficina.codigo_oficina=empleado.codigo_oficina AND empleado.codigo_empleado=cliente.codigo_empleado_rep_ventas;

/*Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.*/
/*SQL1*/
SELECT cliente.nombre_cliente, empleado.nombre, oficina.ciudad
FROM cliente, empleado, oficina
WHERE cliente.codigo_empleado_rep_ventas=empleado.codigo_empleado AND empleado.codigo_oficina=oficina.codigo_oficina;

/*SQL2*/
SELECT cliente.nombre_cliente, empleado.nombre, oficina.ciudad
FROM cliente INNER JOIN empleado
ON cliente.codigo_empleado_rep_ventas=empleado.codigo_empleado 
INNER JOIN oficina
ON empleado.codigo_oficina=oficina.codigo_oficina;

/*Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.*/
/*SQL1*/
SELECT e.nombre, j.nombre AS NombreJefe
FROM empleado e, empleado j
WHERE e.codigo_jefe=j.codigo_empleado;

/*SQL2*/
SELECT e.nombre, j.nombre AS NombreJefe
FROM empleado e INNER JOIN empleado j
ON e.codigo_jefe=j.codigo_empleado;

/*Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.*/
/*SQL1*/
SELECT cliente.nombre_cliente
FROM cliente, pedido
WHERE pedido.codigo_cliente=cliente.codigo_cliente AND pedido.fecha_entrega > pedido.fecha_esperada;

/*SQL2*/
SELECT cliente.nombre_cliente
FROM cliente INNER JOIN pedido
ON pedido.codigo_cliente=cliente.codigo_cliente AND pedido.fecha_entrega > pedido.fecha_esperada;

/*Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.*/
/*SQL1*/
SELECT gama_producto.gama
FROM gama_producto, cliente, pedido, detalle_pedido, producto
WHERE cliente.codigo_cliente=pedido.codigo_cliente AND pedido.codigo_pedido=detalle_pedido.codigo_pedido AND detalle_pedido.codigo_producto=producto.codigo_producto AND producto.gama=gama_producto.gama;

/*SQL2*/
SELECT gama_producto.gama
FROM pedido INNER JOIN cliente 
ON cliente.codigo_cliente=pedido.codigo_cliente 
INNER JOIN detalle_pedido
ON pedido.codigo_pedido=detalle_pedido.codigo_pedido
INNER JOIN producto
ON detalle_pedido.codigo_producto=producto.codigo_producto
INNER JOIN gama_producto
ON producto.gama=gama_producto.gama;

/*1.4.7 Consultas resumen*/
/*¿Cuántos empleados hay en la compañía?*/
SELECT COUNT(codigo_empleado)
FROM empleado;

/*¿Cuántos clientes tiene cada país?*/
SELECT COUNT(codigo_cliente) AS NumClientes, pais
FROM cliente
GROUP BY pais;

/*¿Cuál fue el pago medio en 2009?*/
SELECT AVG(total) AS PagoMedio
FROM pago
WHERE YEAR(fecha_pago)='2009';

/*¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el número de pedidos.*/
SELECT COUNT(codigo_pedido) AS NumPedidos, estado
FROM pedido
GROUP BY estado
ORDER BY NumPedidos;

/*Calcula el precio de venta del producto más caro y más barato en una misma consulta.*/
SELECT MAX(precio_venta) AS PrecioMax, MIN(precio_venta) AS PrecioMin
FROM producto;

/*Calcula el número de clientes que tiene la empresa.*/
SELECT COUNT(codigo_cliente) AS NumClientes
FROM cliente ;

/*¿Cuántos clientes tiene la ciudad de Madrid?*/
SELECT COUNT(codigo_cliente) AS NumClientes
FROM cliente 
WHERE ciudad='Madrid';

/*¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M?*/
SELECT COUNT(codigo_cliente) AS NumClientes, ciudad
FROM cliente 
WHERE ciudad LIKE'M%'
GROUP BY ciudad;

/*Devuelve el nombre de los representantes de ventas y el número de clientes al que atiende cada uno.*/
SELECT cliente.codigo_empleado_rep_ventas, COUNT(cliente.codigo_cliente) AS NumCliente
FROM cliente
GROUP BY cliente.codigo_empleado_rep_ventas;

/*Calcula el número de clientes que no tiene asignado representante de ventas.*/
SELECT COUNT(cliente.codigo_cliente) AS NumClientes
FROM cliente
WHERE cliente.codigo_empleado_rep_ventas NOT IN (
												SELECT empleado.codigo_empleado
												FROM empleado
												);

/*Calcula la fecha del primer y último pago realizado por cada uno de los clientes. 
El listado deberá mostrar el nombre y los apellidos de cada cliente.*/
SELECT cliente.nombre_contacto, cliente.apellido_contacto, MAX(pago.fecha_pago) AS UltimoPago, MIN(pago.fecha_pago) AS PrimerPago
FROM cliente, pago
WHERE cliente.codigo_cliente = pago.codigo_cliente
GROUP BY cliente.nombre_contacto;

/*Calcula el número de productos diferentes que hay en cada uno de los pedidos.*/
SELECT detalle_pedido.codigo_pedido, COUNT(detalle_pedido.codigo_producto) AS NumProductos
FROM detalle_pedido
GROUP BY detalle_pedido.codigo_pedido;

/*Calcula la suma de la cantidad total de todos los productos que aparecen en cada uno de los pedidos.*/
SELECT SUM(detalle_pedido.cantidad) AS CantidadTotal
FROM detalle_pedido
GROUP BY detalle_pedido.codigo_pedido;

/*Devuelve un listado de los 20 productos más vendidos y el número total de unidades que se han vendido de cada uno. 
El listado deberá estar ordenado por el número total de unidades vendidas.*/
SELECT detalle_pedido.codigo_producto, SUM(detalle_pedido.cantidad) AS CantidadTotal
FROM detalle_pedido
GROUP BY detalle_pedido.codigo_producto
ORDER BY CantidadTotal DESC
LIMIT 20;

/*La facturación que ha tenido la empresa en toda la historia, indicando la base imponible, el IVA y el total facturado. 
La base imponible se calcula sumando el coste del producto por el número de unidades vendidas de la tabla detalle_pedido. 
El IVA es el 21 % de la base imponible, y el total la suma de los dos campos anteriores.*/
SELECT (SUM(detalle_pedido.cantidad)*detalle_pedido.precio_unidad ) AS BaseImponible,
		 (SUM(detalle_pedido.cantidad)*detalle_pedido.precio_unidad*21/100) AS IVA, 
		 (SUM(detalle_pedido.cantidad)*detalle_pedido.precio_unidad+SUM(detalle_pedido.cantidad)*detalle_pedido.precio_unidad*21/100) AS Total
FROM detalle_pedido;

/*La misma información que en la pregunta anterior, pero agrupada por código de producto.*/
SELECT (SUM(detalle_pedido.cantidad)*detalle_pedido.precio_unidad ) AS BaseImponible,
		 (SUM(detalle_pedido.cantidad)*detalle_pedido.precio_unidad*21/100) AS IVA, 
		 (SUM(detalle_pedido.cantidad)*detalle_pedido.precio_unidad+SUM(detalle_pedido.cantidad)*detalle_pedido.precio_unidad*21/100) AS Total
FROM detalle_pedido
GROUP BY detalle_pedido.codigo_producto;

/*La misma información que en la pregunta anterior, pero agrupada por código de producto filtrada por los códigos que empiecen por OR.*/
SELECT (SUM(detalle_pedido.cantidad)*detalle_pedido.precio_unidad ) AS BaseImponible,
		 (SUM(detalle_pedido.cantidad)*detalle_pedido.precio_unidad*21/100) AS IVA, 
		 (SUM(detalle_pedido.cantidad)*detalle_pedido.precio_unidad+SUM(detalle_pedido.cantidad)*detalle_pedido.precio_unidad*21/100) AS Total
FROM detalle_pedido
WHERE detalle_pedido.codigo_producto LIKE 'OR%'
GROUP BY detalle_pedido.codigo_producto;

/*Lista las ventas totales de los productos que hayan facturado más de 3000 euros. Se mostrará el nombre, unidades vendidas, total facturado y total facturado con impuestos (21% IVA)*/
SELECT producto.nombre, SUM(detalle_pedido.cantidad) AS UnidadesVendidas, SUM(detalle_pedido.cantidad)*detalle_pedido.precio_unidad AS TotalFAct, SUM(detalle_pedido.cantidad)*detalle_pedido.precio_unidad*21/100 AS TotalFactIva
FROM producto, detalle_pedido
WHERE producto.codigo_producto=detalle_pedido.codigo_producto
GROUP BY producto.nombre
HAVING TotalFact>3000;
/*
1.4.8 Subconsultas
1.4.8.1 Con operadores básicos de comparación
Devuelve el nombre del cliente con mayor límite de crédito.*/
/*Devuelve el nombre del producto que tenga el precio de venta más caro.*/
SELECT producto.nombre
FROM producto
WHERE producto.precio_venta=(
							SELECT MAX(producto.precio_venta)
							FROM producto
							);

/*Devuelve el nombre del producto del que se han vendido más unidades. (Tenga en cuenta que tendrá que calcular cuál es el número total de unidades que se han vendido de cada producto a partir de los datos de la tabla detalle_pedido. Una vez que sepa cuál es el código del producto, puede obtener su nombre fácilmente.)*/
SELECT nombre
FROM producto
WHERE codigo_producto=(
								SELECT detalle_pedido.codigo_producto
								FROM detalle_pedido
								GROUP BY detalle_pedido.codigo_producto
								ORDER BY SUM(cantidad) DESC
								LIMIT 1
								);

/*Los clientes cuyo límite de crédito sea mayor que los pagos que haya realizado. (Sin utilizar INNER JOIN).*/
SELECT cliente.nombre_cliente
FROM cliente
WHERE limite_credito>(
							SELECT SUM(pago.total)
							FROM pago 
							);

/*Devuelve el producto que más unidades tiene en stock.*/
SELECT *
FROM producto
WHERE producto.cantidad_en_stock=(
											SELECT MAX(cantidad_en_stock)
											FROM producto
											)

/*Devuelve el producto que menos unidades tiene en stock.*/
SELECT *
FROM producto
WHERE producto.cantidad_en_stock=(
											SELECT MIN(cantidad_en_stock)
											FROM producto
											)

/*Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de Alberto Soria.*/
SELECT empleado.nombre, empleado.apellido1, empleado.apellido2, empleado.email
FROM empleado
WHERE empleado.codigo_jefe=(
										SELECT empleado.codigo_empleado
										FROM empleado
										WHERE empleado.nombre='Alberto' AND empleado.apellido1='Soria'
										);

/*1.4.8.2 Subconsultas con ALL y ANY*/
/*Devuelve el nombre del cliente con mayor límite de crédito.*/
SELECT cliente.nombre_cliente
FROM cliente
WHERE cliente.limite_credito = ALL(
												SELECT MAX(cliente.limite_credito)
												FROM cliente
												);

/*Devuelve el nombre del producto que tenga el precio de venta más caro.*/
SELECT producto.nombre
FROM producto
WHERE producto.precio_venta = ALL(
										SELECT MAX(producto.precio_venta)
										FROM producto
										);

/*Devuelve el producto que menos unidades tiene en stock.*/
SELECT producto.nombre
FROM producto
WHERE producto.cantidad_en_stock = ALL (
													SELECT MIN(producto.cantidad_en_stock)
													FROM producto
													);

/*1.4.8.3 Subconsultas con IN y NOT IN*/
/*Devuelve el nombre, apellido1 y cargo de los empleados que no representen a ningún cliente.*/
SELECT empleado.nombre, empleado.apellido1, empleado.puesto
FROM empleado
WHERE empleado.codigo_empleado NOT IN (
													SELECT cliente.codigo_empleado_rep_ventas
													FROM cliente
													);

/*Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.*/
SELECT *
FROM cliente
WHERE cliente.codigo_cliente NOT IN (
													SELECT pago.codigo_cliente
													FROM pago
													);

/*Devuelve un listado que muestre solamente los clientes que sí han realizado ningún pago.*/
SELECT *
FROM cliente
WHERE cliente.codigo_cliente IN (
													SELECT pago.codigo_cliente
													FROM pago
													);

/*Devuelve un listado de los productos que nunca han aparecido en un pedido.*/
SELECT *
FROM producto
WHERE producto.codigo_producto NOT IN (
													SELECT detalle_pedido.codigo_producto
													FROM detalle_pedido
													);

/*Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representante de ventas de ningún cliente.*/
SELECT empleado.nombre, empleado.apellido1, empleado.apellido2, empleado.puesto, empleado.extension
FROM empleado
WHERE empleado.codigo_empleado NOT IN (
													SELECT cliente.codigo_empleado_rep_ventas
													FROM cliente
													);

/*Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.*/
SELECT *
FROM oficina
WHERE oficina.codigo_oficina NOT IN (
												SELECT empleado.codigo_oficina
												FROM empleado
												WHERE empleado.codigo_empleado IN (
																								SELECT cliente.codigo_empleado_rep_ventas
																								FROM cliente
																								WHERE cliente.codigo_cliente IN (
																																			SELECT pedido.codigo_cliente
																																			FROM pedido
																																			WHERE pedido.codigo_pedido IN (
																																													SELECT detalle_pedido.codigo_pedido
																																													FROM detalle_pedido
																																													WHERE detalle_pedido.codigo_producto IN (
																																																										SELECT producto.codigo_producto
																																																										FROM producto
																																																										WHERE producto.gama = 'Frutales'
																																																							)	
																																											)
																																)
																					)
									)		

/*Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.*/
SELECT *
FROM cliente
WHERE cliente.codigo_cliente IN(						
								SELECT pedido.codigo_cliente
								FROM pedido
								)
AND cliente.codigo_cliente NOT IN(
								SELECT pago.codigo_cliente
								FROM pago
								);

/*1.4.8.4 Subconsultas con EXISTS y NOT EXISTS*/
/*Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.*/
SELECT *
FROM cliente
WHERE NOT EXISTS (
						SELECT pago.codigo_cliente
						FROM pago
						WHERE pago.codigo_cliente=cliente.codigo_cliente
						);	

/*Devuelve un listado que muestre solamente los clientes que sí han realizado ningún pago.*/
SSELECT *
FROM cliente
WHERE EXISTS (
						SELECT pago.codigo_cliente
						FROM pago
						WHERE pago.codigo_cliente=cliente.codigo_cliente
						);

/*Devuelve un listado de los productos que nunca han aparecido en un pedido.*/
SELECT *
FROM producto
WHERE NOT EXISTS (
						SELECT detalle_pedido.codigo_producto
						FROM detalle_pedido
						WHERE detalle_pedido.codigo_producto=producto.codigo_producto
						);			

/*Devuelve un listado de los productos que han aparecido en un pedido alguna vez.*/
SELECT *
FROM producto
WHERE EXISTS (
						SELECT detalle_pedido.codigo_producto
						FROM detalle_pedido
						WHERE detalle_pedido.codigo_producto=producto.codigo_producto
						);			
/*1.4.8.5 Subconsultas correlacionadas
1.4.9 Consultas variadas
Devuelve el listado de clientes indicando el nombre del cliente y cuántos pedidos ha realizado. Tenga en cuenta que pueden existir clientes que no han realizado ningún pedido.*/
SELECT cliente.nombre_contacto, COUNT(pedido.codigo_pedido) AS NumPedidos
FROM cliente, pedido
WHERE cliente.codigo_cliente=pedido.codigo_cliente
GROUP BY pedido.codigo_cliente;

/*Devuelve un listado con los nombres de los clientes y el total pagado por cada uno de ellos. Tenga en cuenta que pueden existir clientes que no han realizado ningún pago.*/
SELECT cliente.nombre_cliente, SUM(pago.total)
FROM cliente, pago
WHERE cliente.codigo_cliente=pago.codigo_cliente
GROUP BY cliente.codigo_cliente;

/*Devuelve el nombre de los clientes que hayan hecho pedidos en 2008 ordenados alfabéticamente de menor a mayor.*/
SELECT cliente.nombre_cliente
FROM cliente, pedido
WHERE cliente.codigo_cliente=pedido.codigo_cliente AND YEAR(pedido.fecha_pedido)='2008'
GROUP BY cliente.codigo_cliente
ORDER BY cliente.nombre_cliente ASC;

/*Devuelve el nombre del cliente, el nombre y primer apellido de su representante de ventas y el número de teléfono de la oficina del representante de ventas, de aquellos clientes que no hayan realizado ningún pago.*/
SELECT cliente.nombre_cliente, empleado.nombre, empleado.apellido1, oficina.telefono
FROM cliente, empleado, oficina
WHERE cliente.codigo_empleado_rep_ventas=empleado.codigo_empleado AND empleado.codigo_oficina=oficina.codigo_oficina;

/*Devuelve el listado de clientes donde aparezca el nombre del cliente, el nombre y primer apellido de su representante de ventas y la ciudad donde está su oficina.*/
SELECT cliente.nombre_cliente, empleado.nombre, empleado.apellido1, oficina.ciudad
FROM cliente, empleado, oficina
WHERE cliente.codigo_empleado_rep_ventas=empleado.codigo_empleado AND empleado.codigo_oficina=oficina.codigo_oficina;

/*Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representante de ventas de ningún cliente.*/
SELECT empleado.nombre, empleado.apellido1, empleado.puesto, oficina.telefono
FROM empleado, oficina
WHERE empleado.codigo_oficina=oficina.codigo_oficina AND empleado.codigo_empleado NOT IN (
																														SELECT cliente.codigo_empleado_rep_ventas
																														FROM cliente
																														);

/*Devuelve un listado indicando todas las ciudades donde hay oficinas y el número de empleados que tiene.*/
SELECT oficina.ciudad, COUNT(empleado.codigo_empleado)
FROM oficina, empleado
WHERE oficina.codigo_oficina=empleado.codigo_oficina
GROUP BY oficina.ciudad;
