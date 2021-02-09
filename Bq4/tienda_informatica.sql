/* EJERCICIOS TIENDA DE INFORMÁTICA MYSQL */
/*1.1.4 Consultas multitabla (Composición interna)
Resuelva todas las consultas utilizando la sintaxis de SQL1 y SQL2.*/

/*Devuelve una lista con el nombre del producto, precio y nombre de fabricante de todos los productos de la base de datos.*/
SELECT producto.nombre, producto.precio, fabricante.nombre
FROM producto, fabricante
WHERE producto.codigo_fabricante = fabricante.codigo;

SELECT producto.nombre, producto.precio, fabricante.nombre
FROM producto
INNER JOIN fabricante
ON producto.codigo_fabricante = fabricante.codigo;

/*Devuelve una lista con el nombre del producto, precio y nombre de fabricante de todos los productos de la base de datos. Ordene el resultado por el nombre del fabricante, por orden alfabético.*/
SELECT producto.nombre, producto.precio, fabricante.nombre
FROM producto, fabricante
WHERE producto.codigo_fabricante = fabricante.codigo
ORDER BY fabricante.nombre ASC;

SELECT producto.nombre, producto.precio, fabricante.nombre
FROM producto
INNER JOIN fabricante
ON producto.codigo_fabricante = fabricante.codigo
ORDER BY fabricante.nombre ASC;

/*Devuelve una lista con el código del producto, nombre del producto, código del fabricante y nombre del fabricante, de todos los productos de la base de datos.*/
SELECT producto.codigo, producto.nombre, fabricante.codigo, fabricante.nombre
FROM producto, fabricante
WHERE producto.codigo_fabricante = fabricante.codigo;

SELECT producto.codigo, producto.nombre, fabricante.codigo, fabricante.nombre
FROM producto
INNER JOIN fabricante
ON producto.codigo_fabricante = fabricante.codigo;

/*Devuelve el nombre del producto, su precio y el nombre de su fabricante, del producto más barato.*/
SELECT producto.nombre, producto.precio, fabricante.nombre
FROM producto, fabricante
WHERE producto.codigo_fabricante = fabricante.codigo
AND precio =	(
					SELECT MIN(precio)
					FROM producto
				);

SELECT producto.nombre, producto.precio, fabricante.nombre
FROM producto
INNER JOIN fabricante
ON producto.codigo_fabricante = fabricante.codigo
WHERE precio =	(
						SELECT MIN(precio)
						FROM producto
					);

/*Devuelve el nombre del producto, su precio y el nombre de su fabricante, del producto más caro.*/
SELECT producto.nombre, producto.precio, fabricante.nombre
FROM producto, fabricante
WHERE producto.codigo_fabricante = fabricante.codigo
AND precio =	(
					SELECT MAX(precio)
					FROM producto
				);

SELECT producto.nombre, producto.precio, fabricante.nombre
FROM producto
INNER JOIN fabricante
ON producto.codigo_fabricante = fabricante.codigo
WHERE precio =	(
						SELECT MAX(precio)
						FROM producto
					);

/*Devuelve una lista de todos los productos del fabricante Lenovo.*/
SELECT producto.*
FROM producto, fabricante
WHERE producto.codigo_fabricante = fabricante.codigo AND fabricante.nombre = 'Lenovo';

SELECT producto.*
FROM producto
INNER JOIN fabricante
ON producto.codigo_fabricante = fabricante.codigo
WHERE fabricante.nombre = 'Lenovo';

/*Devuelve una lista de todos los productos del fabricante Crucial que tengan un precio mayor que 200€.*/
SELECT producto.*
FROM producto, fabricante
WHERE producto.codigo_fabricante = fabricante.codigo AND fabricante.nombre = 'Crucial' AND producto.precio > 200;

SELECT producto.*
FROM producto
INNER JOIN fabricante
ON producto.codigo_fabricante = fabricante.codigo
WHERE fabricante.nombre = 'Crucial' AND producto.precio > 200;

/*Devuelve un listado con todos los productos de los fabricantes Asus, Hewlett-Packard y Seagate. Sin utilizar el operador IN.*/
SELECT producto.*
FROM producto, fabricante
WHERE producto.codigo_fabricante = fabricante.codigo AND (fabricante.nombre = 'Asus' OR fabricante.nombre = 'Hewlett-Packard' OR fabricante.nombre = 'Seagate');

SELECT producto.*
FROM producto
INNER JOIN fabricante
ON producto.codigo_fabricante = fabricante.codigo
WHERE fabricante.nombre = 'Asus' OR fabricante.nombre = 'Hewlett-Packard' OR fabricante.nombre = 'Seagate';

/*Devuelve un listado con todos los productos de los fabricantes Asus, Hewlett-Packard y Seagate. Utilizando el operador IN.*/
SELECT producto.*
FROM producto, fabricante
WHERE producto.codigo_fabricante = fabricante.codigo AND fabricante.nombre IN ('Asus', 'Hewlett-Packard', 'Seagate');

SELECT producto.*
FROM producto
INNER JOIN fabricante
ON producto.codigo_fabricante = fabricante.codigo
WHERE fabricante.nombre IN ('Asus', 'Hewlett-Packard', 'Seagate');

/*Devuelve un listado con el nombre y el precio de todos los productos de los fabricantes cuyo nombre termine por la vocal e.*/
SELECT producto.nombre, producto.precio
FROM producto, fabricante
WHERE producto.codigo_fabricante = fabricante.codigo AND fabricante.nombre LIKE '%e';

SELECT producto.nombre, producto.precio
FROM producto
INNER JOIN fabricante
ON producto.codigo_fabricante = fabricante.codigo
WHERE fabricante.nombre LIKE '%e';

/*Devuelve un listado con el nombre y el precio de todos los productos cuyo nombre de fabricante contenga el carácter w en su nombre.*/
SELECT producto.nombre, producto.precio
FROM producto, fabricante
WHERE producto.codigo_fabricante = fabricante.codigo AND fabricante.nombre LIKE '%w%';

SELECT producto.nombre, producto.precio
FROM producto
INNER JOIN fabricante
ON producto.codigo_fabricante = fabricante.codigo
WHERE fabricante.nombre LIKE '%w%';

/*Devuelve un listado con el nombre de producto, precio y nombre de fabricante, de todos los productos que tengan un precio mayor o igual a 180€. Ordene el resultado en primer lugar por el precio (en orden descendente) y en segundo lugar por el nombre (en orden ascendente)*/
SELECT producto.nombre, producto.precio, fabricante.nombre
FROM producto, fabricante
WHERE producto.codigo_fabricante = fabricante.codigo AND producto.precio >= 180
ORDER BY producto.precio DESC, producto.nombre ASC;

SELECT producto.nombre, producto.precio, fabricante.nombre
FROM producto
INNER JOIN fabricante
ON producto.codigo_fabricante = fabricante.codigo
WHERE producto.precio >= 180
ORDER BY producto.precio DESC, producto.nombre ASC;

/*Devuelve un listado con el código y el nombre de fabricante, solamente de aquellos fabricantes que tienen productos asociados en la base de datos.*/
SELECT DISTINCT fabricante.codigo, fabricante.nombre
FROM producto, fabricante
WHERE producto.codigo_fabricante = fabricante.codigo AND fabricante.codigo IN	(
																				SELECT codigo_fabricante
																				FROM producto
																				);


SELECT DISTINCT fabricante.codigo, fabricante.nombre
FROM producto
INNER JOIN fabricante
ON producto.codigo_fabricante = fabricante.codigo
WHERE fabricante.codigo IN	(
								SELECT codigo_fabricante
								FROM producto
							);

/*1.1.7 Subconsultas (En la cláusula WHERE)
1.1.7.1 Con operadores básicos de comparación*/
/*Devuelve todos los productos del fabricante Lenovo. (Sin utilizar INNER JOIN).*/
SELECT *
FROM producto
WHERE codigo_fabricante =	(
								SELECT codigo
								FROM fabricante
								WHERE nombre = 'Lenovo'
							);

/*Devuelve todos los datos de los productos que tienen el mismo precio que el producto más caro del fabricante Lenovo. (Sin utilizar INNER JOIN).*/
SELECT *
FROM producto
WHERE precio = ( 	SELECT MAX(precio) 
					FROM producto, fabricante
					WHERE producto.codigo_fabricante = fabricante.codigo
					AND fabricante.nombre = 'Lenovo'
				);

/*Lista el nombre del producto más caro del fabricante Lenovo.*/
SELECT nombre
FROM producto
WHERE precio = ( 	SELECT MAX(precio) 
					FROM producto
					INNER JOIN fabricante
					ON producto.codigo_fabricante = fabricante.codigo
					WHERE fabricante.nombre = 'Lenovo'
				);

SELECT nombre
FROM producto
WHERE codigo_fabricante=
	(
		SELECT codigo
		FROM fabricante 
		WHERE nombre='Lenovo'
	)
ORDER BY precio DESC
LIMIT 1;

/*Lista el nombre del producto más barato del fabricante Hewlett-Packard.*/
SELECT *
FROM producto INNER JOIN fabricante
ON producto.codigo_fabricante = fabricante.codigo
WHERE precio = ( 	SELECT MIN(precio) 
					FROM producto, fabricante
					WHERE producto.codigo_fabricante = fabricante.codigo
					AND fabricante.nombre = 'Hewlett-Packard'
				)
AND fabricante.nombre = 'Hewlett-Packard';

/*Devuelve todos los productos de la base de datos que tienen un precio mayor o igual al producto más caro del fabricante Lenovo.*/
SELECT *
FROM producto
WHERE precio >= ( 	SELECT MAX(precio) 
					FROM producto, fabricante
					WHERE producto.codigo_fabricante = fabricante.codigo
					AND fabricante.nombre = 'Lenovo'
				);

/*Lista todos los productos del fabricante Asus que tienen un precio superior al precio medio de todos sus productos.*/
SELECT producto.*
FROM producto, fabricante
WHERE producto.codigo_fabricante = fabricante.codigo AND precio > (SELECT AVG(precio) 
																	FROM producto, fabricante
																	AND fabricante.nombre = 'Asus')
AND fabricante.nombre = 'Asus';

/*1.1.7.2 Subconsultas con ALL y ANY*/
/*Devuelve el producto más caro que existe en la tabla producto sin hacer uso de MAX, ORDER BY ni LIMIT.*/
SELECT codigo, nombre 
FROM producto 
WHERE precio >= ALL
	(
		SELECT precio 
		FROM producto
	);

/*Devuelve el producto más barato que existe en la tabla producto sin hacer uso de MIN, ORDER BY ni LIMIT.*/
SELECT codigo, nombre 
FROM producto 
WHERE precio <= ALL
	(
		SELECT precio 
		FROM producto
	);

/*Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando ALL o ANY).*/
SELECT nombre
FROM fabricante
WHERE codigo = ANY (
						SELECT codigo_fabricante
						FROM producto
				   );

/*Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando ALL o ANY).*/
SELECT nombre
FROM fabricante
WHERE codigo <> ALL (
						SELECT codigo_fabricante
						FROM producto
					);

/*1.1.7.3 Subconsultas con IN y NOT IN*/
/*Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando IN o NOT IN).*/
SELECT nombre
FROM fabricante
WHERE codigo IN (
					SELECT codigo_fabricante
					FROM producto
				);

/*Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando IN o NOT IN).*/
SELECT nombre
FROM fabricante
WHERE codigo NOT IN (
					SELECT codigo_fabricante
					FROM producto
				);

/*1.1.7.4 Subconsultas con EXISTS y NOT EXISTS*/
/*Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando EXISTS o NOT EXISTS).*/
SELECT DISTINCT fabricante.nombre
FROM fabricante
WHERE EXISTS (
				SELECT codigo_fabricante
				FROM producto
				WHERE producto.codigo_fabricante = fabricante.codigo
			 );

/*Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando EXISTS o NOT EXISTS).*/
SELECT DISTINCT fabricante.nombre
FROM fabricante
WHERE NOT EXISTS (
					SELECT codigo_fabricante
					FROM producto
					WHERE producto.codigo_fabricante = fabricante.codigo
				 );

/*1.1.7.5 Subconsultas correlacionadas*/
/*Lista el nombre de cada fabricante con el nombre y el precio de su producto más caro.*/
SELECT fabricante.nombre, producto.nombre, producto.precio
FROM fabricante INNER JOIN producto
ON fabricante.precio=producto.codigo_fabricante
WHERE precio=(
				SELECT MAX(precio)
				FROM producto
				WHERE fabricante.precio=producto.codigo_fabricante
				);

/*Devuelve un listado de todos los productos que tienen un precio mayor o igual a la media de todos los productos de su mismo fabricante.*/
SELECT producto.*
FROM producto INNER JOIN fabricante
ON fabricante.precio=producto.codigo_fabricante
WHERE precio >= (
					SELECT AVG(precio)
					FROM producto
					GROUP BY codigo_fabricante)

/*Lista el nombre del producto más caro del fabricante Lenovo.*/
SELECT producto.nombre
FROM producto, fabricante		
WHERE producto.codigo_fabricante=fabricante.codigo AND fabricante.nombre='Lenovo' AND precio=(
																														SELECT MAX(producto.precio)
																														FROM producto, fabricante	
																														WHERE fabricante.nombre='Lenovo'	AND producto.codigo_fabricante=fabricante.codigo
					)

/*1.1.8 Subconsultas (En la cláusula HAVING)*/
/*Devuelve un listado con todos los nombres de los fabricantes que tienen el mismo número de productos que el fabricante Lenovo.*/
SELECT fabricante.nombre
FROM fabricante, producto
WHERE producto.codigo_fabricante = fabricante.codigo
AND NOT fabricante.nombre = 'Lenovo'
GROUP BY fabricante.codigo
HAVING COUNT(producto.codigo) = (
									SELECT COUNT(producto.codigo)
									FROM producto, fabricante
									WHERE producto.codigo_fabricante = fabricante.codigo
									AND fabricante.nombre = 'Lenovo'
								);