USE tienda10;
/*CONSULTAS*/
/*1. Lista el nombre de todos los productos que hay en la tabla producto.*/
SELECT nombre
FROM producto;

/*2. Lista los nombres y los precios de todos los productos de la tabla producto.*/
SELECT nombre, precio
FROM producto;

/*3. Lista todas las columnas de la tabla producto.*/
SELECT *
FROM producto;

/*4. Lista el nombre de los productos, el precio en euros y el precio en dólares
estadounidenses (USD).*/
SELECT nombre, precio, precio*1.21 AS PrecioDolar
FROM producto;

/*5. Lista el nombre de los productos, el precio en euros y el precio en dólares
estadounidenses (USD). Utiliza los siguientes alias para las columnas: nombre de
producto, euros, dólares.*/
SELECT nombre AS NombreDeProducto, precio AS Euros, precio*1.21 AS Dolares
FROM producto;

/*6. Lista los nombres y los precios de todos los productos de la tabla producto,
convirtiendo los nombres a mayúscula.*/
SELECT UPPER(nombre) AS NOMBRE, precio
FROM producto;

/*7. Lista los nombres y los precios de todos los productos de la tabla producto,
convirtiendo los nombres a minúscula.*/
SELECT LOWER(nombre) AS nombre, precio
FROM producto;

/*8. Lista el nombre de todos los fabricantes en una columna, y en otra columna obtenga
en mayúsculas los dos primeros caracteres del nombre del fabricante.*/
SELECT nombre, UPPER(SUBSTRING(nombre, 1,2)) 
FROM fabricante;

/*9. Lista los nombres y los precios de todos los productos de la tabla producto,
redondeando el valor del precio.*/
SELECT nombre, ROUND(precio)
FROM producto;

/*10. Lista los nombres y los precios de todos los productos de la tabla producto,
truncando el valor del precio para mostrarlo sin ninguna cifra decimal.*/
SELECT nombre, TRUNCATE(precio, 0)
FROM producto;

/*11. Lista el código de los fabricantes que tienen productos en la tabla producto.*/
SELECT codigo_fabricante
FROM producto;

/*12. Lista el código de los fabricantes que tienen productos en la tabla producto,
eliminando los códigos que aparecen repetidos.*/
SELECT codigo
FROM fabricante
WHERE codigo IN
				(SELECT codigo_fabricante
				FROM producto
				)
;

/*o*/

SELECT codigo_fabricante
FROM producto
GROUP BY codigo_fabricante;

/*13. Lista los nombres de los fabricantes ordenados de forma ascendente.*/
SELECT nombre
FROM fabricante
ORDER BY nombre;

/*14. Lista los nombres de los fabricantes ordenados de forma descendente.*/
SELECT nombre
FROM fabricante
ORDER BY nombre DESC;

/*15. Lista los nombres de los productos ordenados en primer lugar por el nombre de
forma ascendente y en segundo lugar por el precio de forma descendente.*/
SELECT nombre 
FROM producto
ORDER BY nombre, precio;

/*16. Devuelve una lista con las 5 primeras filas de la tabla fabricante.*/
SELECT nombre 
FROM fabricante
LIMIT 0,5;

/*17. Devuelve una lista con 2 filas a partir de la cuarta fila de la tabla fabricante. La cuarta
fila también se debe incluir en la respuesta.*/
SELECT nombre 
FROM fabricante
LIMIT 4,2;

/*18. Lista el nombre y el precio del producto más barato. (Utilice solamente las cláusulas
ORDER BY y LIMIT)*/
SELECT nombre, precio
FROM producto
ORDER BY precio 
LIMIT 0,1;

/*19. Lista el nombre y el precio del producto más caro. (Utilice solamente las cláusulas
ORDER BY y LIMIT)*/
SELECT nombre, precio
FROM producto
ORDER BY precio DESC
LIMIT 0,1;

/*20. Lista el nombre de todos los productos del fabricante cuyo código de fabricante es
igual a 2.*/
SELECT nombre
FROM producto
WHERE codigo_fabricante=2;

/*21. Lista el nombre de los productos que tienen un precio menor o igual a 120€.*/
SELECT nombre
FROM producto
WHERE precio<=120;

/*22. Lista el nombre de los productos que tienen un precio mayor o igual a 400€.*/
SELECT nombre
FROM producto
WHERE precio>=400;

/*23. Lista el nombre de los productos que no tienen un precio mayor o igual a 400€.*/
SELECT nombre
FROM producto
WHERE precio<400;

/*24. Lista todos los productos que tengan un precio entre 80€ y 300€. Sin utilizar el
operador BETWEEN.*/
SELECT nombre
FROM producto
WHERE precio>80 AND precio<300;

/*25. Lista todos los productos que tengan un precio entre 60€ y 200€. Utilizando el
operador BETWEEN.*/
SELECT nombre
FROM producto
WHERE precio BETWEEN 60 AND 200;

/*26. Lista todos los productos que tengan un precio mayor que 200€ y que el código de
fabricante sea igual a 6.*/
SELECT nombre
FROM producto
WHERE precio >200 AND codigo_fabricante=6

/*27. Lista todos los productos donde el código de fabricante sea 1, 3 o 5. Sin utilizar el
operador IN.*/
SELECT nombre
FROM producto
WHERE codigo_fabricante=1 OR codigo_fabricante=3 OR codigo_fabricante=5;

/*28. Lista todos los productos donde el código de fabricante sea 1, 3 o 5. Utilizando el
operador IN.*/
SELECT nombre
FROM producto
WHERE codigo_fabricante IN (1, 3, 5);

/*29. Lista el nombre y el precio de los productos en céntimos (Habrá que multiplicar por
100 el valor del precio). Cree un alias para la columna que contiene el precio que se
llame céntimos.*/
SELECT nombre, precio*100 AS Centimos
FROM producto;

/*30. Lista los nombres de los fabricantes cuyo nombre empiece por la letra S.*/
SELECT nombre
FROM fabricante
WHERE nombre LIKE 'S%';

/*31. Lista los nombres de los fabricantes cuyo nombre termine por la vocal e.*/
SELECT nombre
FROM fabricante
WHERE nombre LIKE '%e';

/*32. Lista los nombres de los fabricantes cuyo nombre contenga el carácter w.*/
SELECT nombre
FROM fabricante
WHERE nombre LIKE '%w%';

/*33. Lista los nombres de los fabricantes cuyo nombre sea de 4 caracteres.*/
SELECT nombre
FROM fabricante
WHERE nombre LIKE '%e';

/*34. Devuelve una lista con el nombre de todos los productos que contienen la cadena
Portátil en el nombre.*/
SELECT nombre
FROM fabricante
WHERE nombre LIKE '____';

/*35. Devuelve una lista con el nombre de todos los productos que contienen la cadena
Monitor en el nombre y tienen un precio inferior a 215 €.*/
SELECT nombre
FROM producto
WHERE precio<215 AND nombre LIKE '%MONITOR%' ;

/*36. Lista el nombre y el precio de todos los productos que tengan un precio mayor o
igual a 180€. Ordene el resultado en primer lugar por el precio (en orden
descendente) y en segundo lugar por el nombre (en orden ascendente).*/
SELECT nombre, precio
FROM producto
WHERE precio<=180
ORDER BY precio DESC, nombre;

SUBCONSULTAS;
/*1. Devuelve todos los productos del fabricante Lenovo.*/
SELECT nombre
FROM producto
WHERE codigo_fabricante=
					(SELECT codigo
					FROM fabricante
					WHERE nombre='Lenovo')
;

/*2. Devuelve todos los datos de los productos que tienen el mismo precio que el
producto más caro del fabricante Lenovo.*/
SELECT *
FROM producto
WHERE precio=
					(SELECT MAX(precio) AS PrecioMAx
					FROM producto
					WHERE codigo_fabricante=
													(SELECT codigo
													FROM fabricante
													WHERE nombre='Lenovo')
					)
;

/*o*/

SELECT *
FROM producto
WHERE precio=
					(SELECT MAX(precio) AS PrecioMAx
					FROM producto
					WHERE codigo_fabricante=2
													
					)
;

/*3. Lista el nombre del producto más caro del fabricante Lenovo.*/
SELECT nombre
FROM producto
WHERE precio=
					(SELECT MAX(precio) AS PercioMaximo
					FROM producto
					WHERE codigo_fabricante=2
					)
;
           
/*4. Lista el nombre del producto más barato del fabricante Hewlett-Packard.*/
SELECT nombre
FROM producto
WHERE precio=
					(SELECT MIN(precio) AS PercioMaximo
					FROM producto
					WHERE codigo_fabricante=3
					)
;               

/*5. Devuelve todos los productos de la base de datos que tienen un precio mayor o igual
al producto más caro del fabricante Lenovo.*/
SELECT *
FROM producto
WHERE precio>=
					(SELECT MAX(precio) AS PrecioMAx
					FROM producto
					WHERE codigo_fabricante=2
													
					)
;


/*6. Lista todos los productos del fabricante Asus que tienen un precio superior al precio
medio de todos sus productos.*/
SELECT *
FROM producto
WHERE codigo_fabricante=1 AND precio>
					                      (SELECT AVG(precio) 
					                       FROM producto
					                       WHERE codigo_fabricante=1
													
					)
;

AGRUPACIONES;
/*1. Calcula el número total de productos que hay en la tabla productos.*/
SELECT COUNT(codigo)
FROM producto;

/*2. Calcula el número total de fabricantes que hay en la tabla fabricante.*/
SELECT COUNT(codigo)
FROM fabricante;

/*3. Calcula el número de valores distintos de código de fabricante aparecen en la tabla
productos.*/
SELECT COUNT(codigo_fabricante)
FROM producto
GROUP BY codigo_fabricante;

/*4. Calcula la media del precio de todos los productos.*/
SELECT AVG(precio)
FROM producto;

/*5. Calcula el precio más barato de todos los productos.*/
SELECT MIN(precio)
FROM producto;

/*6. Calcula el precio más caro de todos los productos.*/
SELECT MAX(precio)
FROM producto;

/*7. Lista el nombre y el precio del producto más barato.*/
SELECT MIN(precio), nombre
FROM producto;

/*8. Lista el nombre y el precio del producto más caro.*/
SELECT MAX(precio), nombre
FROM producto;

/*9. Calcula la suma de los precios de todos los productos.*/
SELECT SUM(precio)
FROM producto;