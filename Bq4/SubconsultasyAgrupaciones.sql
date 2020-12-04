
/*SUBCONSULTAS*/

/*1 Muestra el empleado de mayor salario del departamento 20*/
SELECT apellidos
FROM emple
WHERE salario=
					(SELECT MAX(salario)
					 FROM emple
					 WHERE dept_no=20)
;

/*2 Muestra todos los empleados del departamento 20 que tienen una comisión mayor a la media de este departamento*/
SELECT apellidos
FROM emple
WHERE  comision>
					(SELECT AVG(comision)
					FROM emple
					WHERE dept_no=20)
;

/*3 Muestra todos los empleados del departamento 20 que tienen una comisión menor a la media de toda la empresa*/
SELECT apellidos
FROM emple
WHERE  comision<
					(SELECT AVG(comision)
					FROM emple)
;

/*4 Muestra el salario del empleado que tiene la mayor comisión*/
SELECT salario
FROM emple
WHERE  comision=
					(SELECT MAX(comision)
					FROM emple)
;

/*5 Lista el empleado con menor salario del oficio VENDEDOR*/
SELECT apellidos
FROM emple
WHERE  salario=
					(SELECT MIN(salario)
					FROM emple
					WHERE oficio='VENDEDOR')
;

/*AGRUPACIONES
PARA ESTAS CONSULTAS DEBES USAR ALIAS QUE SEAN DESCRIPTIVOS DEL RESULTADO E INLCUIR EN LA CLÁUSULA SELECT LA COLUMNA POR LA QUE SE AGRUPAN LAS FILAS, EJEMPLO:

MEDIA_SALARIO		DEPARTAMENTO
	20.000				10
	25.000				20
*/

/*1 Calcular el número de empleados que tiene cada departamento. */
SELECT COUNT(emp_no) AS NumEmpleados
FROM emple
GROUP BY dept_no;

/*2 Calcular cuántos empleados se corresponden con cada oficio*/
SELECT COUNT(emp_no) AS NumEmpleados
FROM emple
GROUP BY oficio;

/*3 Calcular el salario medio de los empleados según su oficio*/
SELECT AVG(salario) AS SalarioMedio
FROM emple
GROUP BY oficio;

/*4 Calcular el salario medio de los empleados según su departamento*/
SELECT AVG(salario) AS SalarioMedio
FROM emple
GROUP BY dept_no;

/*5 Calcular la comisión máxima de los empleados según su oficio*/
SELECT MAX(comision) AS SComisionMaxima
FROM emple
GROUP BY oficio;

/*6 Calcular la comisión máxima de los empleados según su departamento*/
SELECT MAX(comision) AS SComisionMaxima
FROM emple
GROUP BY dept_no;

/*7 Calcular el salario medio de cada departamento*/
SELECT AVG(salario) AS SalarioMedio
FROM emple
GROUP BY dept_no;


/*8 Calcular la media de las comisiones que cobran los empleados según sus oficios*/
SELECT AVG(comision) AS MediaComisiones
FROM emple
GROUP BY oficio;
