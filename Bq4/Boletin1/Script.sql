/* Añadir drop y probar siempre a importar el archivo sql a heidi */
/* http://aulavirtual.iesalixar.org/mod/resource/view.php?id=7055 */

DROP DATABASE IF EXISTS empresa1 ;
CREATE DATABASE empresa1;
USE empresa1;
CREATE TABLE depart
(
	dept_no INTEGER,
	dnombre VARCHAR(20),
	loc     VARCHAR(20),
	PRIMARY KEY (dept_no)
);

INSERT INTO depart
VALUES ('10','CONTABILIDAD','SEVILLA');
INSERT INTO depart
VALUES ('20','INVESTIGACION','MADRID');
INSERT INTO depart
VALUES ('30','VENTAS','BARCELONA');
INSERT INTO depart
VALUES ('40','PRODUCCION','BILBAO');


CREATE TABLE emple
(
	emp_no    INTEGER,
	apellidos VARCHAR(20),
	oficio    VARCHAR(20),
	dir       INTEGER,
	fecha_alt date,
	salario   INTEGER,
	comision  INTEGER,
	dept_no   INTEGER,
	PRIMARY KEY (emp_no),
	foreign KEY (dept_no) references depart (dept_no)
);

INSERT INTO emple (emp_no, apellidos, oficio, dir, fecha_alt, salario, dept_no)
VALUES ('7369','SANCHEZ','EMPLEADO','7902','1980-02-17','104000','20');
INSERT INTO emple
VALUES ('7499','ARROYO','VENDEDOR','7698','1980-02-20','208000','39000','30');
INSERT INTO emple
VALUES ('7521','SALA','VENDEDOR','7698','1981-02-22','162500','162500','30');
INSERT INTO emple (emp_no, apellidos, oficio, dir, fecha_alt, salario, dept_no)
VALUES ('7566','JIMENEZ','DIRECTOR','7839','1981-04-02','386750','20');
INSERT INTO emple
VALUES ('7654','MARTIN','VENDEDOR','7698','1981-09-29','162500','182000','30');
INSERT INTO emple(emp_no, apellidos, oficio, dir, fecha_alt, salario, dept_no)
VALUES ('7698','NEGRO','DIRECTOR','7839','1981-05-01','370500','30');
INSERT INTO emple(emp_no, apellidos, oficio, dir, fecha_alt, salario, dept_no)
VALUES ('7788','GIL','ANALISTA','7566','1981-11-09','390000','20');
INSERT INTO emple(emp_no, apellidos, oficio, fecha_alt, salario, dept_no)
VALUES ('7839','REY','PRESIDENTE','1981-11-17','650000','10');
INSERT INTO emple
VALUES ('7844','TOVAR','VENDEDOR','7698','1981-09-08','195000','0','30');
INSERT INTO emple(emp_no, apellidos, oficio, dir, fecha_alt, salario, dept_no)
VALUES ('7876','ALONSO','EMPLEADO','7788','1981-09-23','143000','20');
INSERT INTO emple(emp_no, apellidos, oficio, dir, fecha_alt, salario, dept_no)
VALUES ('7900','JIMENO','EMPLEADO','7698','1981-12-03','1235000','30');
INSERT INTO emple(emp_no, apellidos, oficio, dir, fecha_alt, salario, dept_no)
VALUES ('7902','FERNANDEZ','ANALISTA','7566','1981-12-03','390000','20');
INSERT INTO emple(emp_no, apellidos, oficio, dir, fecha_alt, salario, dept_no)
VALUES ('7934','MUÑOZ','EMPLEADO','7782','1982-01-23','169000','10');