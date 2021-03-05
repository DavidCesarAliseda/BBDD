DROP DATABASE IF EXISTS david_examen;
CREATE DATABASE david_examen;
USE david_examen;

CREATE TABLE vuelo
(
	id_vuelo INT(4) PRIMARY KEY,
	origen VARCHAR(25),
	destino VARCHAR(25),
	fecha_hora_salida DATETIME DEFAULT SYSDATE()
);

INSERT INTO vuelo (id_vuelo, origen, destino, fecha_hora_salida) 
VALUES ('86','Barcelona', 'Madrid', '2021-02-09 07:15:18');
INSERT INTO vuelo (id_vuelo, origen, destino, fecha_hora_salida) 
VALUES ('785','Malaga', 'Paris', '2021-03-09 19:04:18');
INSERT INTO vuelo (id_vuelo, origen, destino, fecha_hora_salida) 
VALUES ('8745','Berlin', 'Mallorca', '2020-02-05 20:36:18');

CREATE TABLE cliente
(
	dni INT(9) PRIMARY KEY CHECK (dni LIKE ('________')),
	nombre_apellidos VARCHAR(60)
);

INSERT INTO cliente (dni, nombre_apellidos) 
VALUES ('56987412', 'Francisco Sanchez');
INSERT INTO cliente (dni, nombre_apellidos) 
VALUES ('36521478', 'Paco Sanz');

CREATE TABLE reservan
(
	dni INT(9),
	id_vuelo INT(4), 
	fecha_hora_reserva DATETIME DEFAULT SYSDATE(),
	CONSTRAINT fk_vuel_res FOREIGN KEY (id_vuelo) REFERENCES vuelo (id_vuelo) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_clien_res FOREIGN KEY (dni) REFERENCES cliente (dni) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT pk_reservan PRIMARY KEY (id_vuelo, dni, fecha_hora_reserva)
	
);

INSERT INTO reservan (dni, id_vuelo, fecha_hora_reserva) 
VALUES ('36521478', '785', '2020-01-04 17:36:18');
INSERT INTO reservan (dni, id_vuelo, fecha_hora_reserva) 
VALUES ('36521478', '86', '2021-01-01 12:42:18');
INSERT INTO reservan (dni, id_vuelo, fecha_hora_reserva) 
VALUES ('56987412', '8745', '2021-01-03 19:16:18');


CREATE TABLE sucursal
(
	id_sucursal INT(4) PRIMARY KEY,
	ciudad VARCHAR(25) DEFAULT 'Sevilla',
	poblacion VARCHAR(25)
);

INSERT INTO sucursal (id_sucursal, ciudad, poblacion) 
VALUES ('32', 'Malaga', 'Malaga');
INSERT INTO sucursal (id_sucursal, ciudad, poblacion) 
VALUES ('7865', 'Sevilla', 'Mairena');
INSERT INTO sucursal (id_sucursal, ciudad, poblacion) 
VALUES ('5', 'Sevilla', 'Bollullos');


CREATE TABLE disponen
(
	id_vuelo INT(4), 
	id_sucursal INT(4),
	CONSTRAINT fk_vuel_disp FOREIGN KEY (id_vuelo) REFERENCES vuelo (id_vuelo) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_sucur_disp FOREIGN KEY (id_sucursal) REFERENCES sucursal (id_sucursal) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT pk_disponen PRIMARY KEY (id_vuelo, id_sucursal)
);

INSERT INTO disponen (id_vuelo, id_sucursal) 
VALUES ('8745', '32');
INSERT INTO disponen (id_vuelo, id_sucursal) 
VALUES ('785', '32');
INSERT INTO disponen (id_vuelo, id_sucursal) 
VALUES ('86', '7865');

CREATE TABLE referencia
(
	id_sucursal INT(4),
	id_sucursal_referenciada INT(4) PRIMARY KEY,
	CONSTRAINT fk_sucur_refe FOREIGN KEY (id_sucursal) REFERENCES sucursal (id_sucursal) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_sucur_referenc FOREIGN KEY (id_sucursal_referenciada) REFERENCES sucursal (id_sucursal) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO referencia (id_sucursal, id_sucursal_referenciada) 
VALUES ('32', '7865');
INSERT INTO referencia (id_sucursal, id_sucursal_referenciada) 
VALUES ('32', '5');

CREATE TABLE hotel
(
	id_hotel INT(4),
	ciudad VARCHAR(25) DEFAULT ('Sevilla'),
	poblacion VARCHAR(25),
	id_sucursal INT(4),
	CONSTRAINT fk_sucur_hotel FOREIGN KEY (id_sucursal) REFERENCES sucursal (id_sucursal) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT pk_disponen PRIMARY KEY (id_hotel, id_sucursal)
);

INSERT INTO hotel (id_hotel, ciudad, poblacion, id_sucursal) 
VALUES ('8750', 'Sevilla', 'Tomares', '5');
INSERT INTO hotel (id_hotel, ciudad, poblacion, id_sucursal) 
VALUES ('8750', 'Sevilla', 'Gines', '32');

