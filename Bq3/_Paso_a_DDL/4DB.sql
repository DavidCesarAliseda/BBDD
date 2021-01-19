/*Paso a DDL Videos*/
DROP DATABASE IF EXISTS david_videos ;
CREATE DATABASE david_videos;
USE david_videos;

CREATE TABLE usuario 
(
	id_user INT(10) AUTO_INCREMENT PRIMARY KEY,
	email VARCHAR(50) NOT NULL,
	contraseña VARCHAR(25) NOT NULL,
	nombre_user VARCHAR(35) NOT NULL,
	fecha_nac DATE NOT NULL
);

INSERT INTO usuario (id_user, email, contraseña, nombre_user, fecha_nac) 
VALUES ('123','primercorreo@example.exp','123ABC','Vilma','1986-5-28');
INSERT INTO usuario (id_user, email, contraseña, nombre_user, fecha_nac) 
VALUES ('649','correito@example.exp','a_b_c_d','Kase','1982-7-6');
INSERT INTO usuario (id_user, email, contraseña, nombre_user, fecha_nac) 
VALUES ('25','ejemplo@organizacion.org','8462SE','Rels','2005-8-24');
INSERT INTO usuario (id_user, email, contraseña, nombre_user, fecha_nac) 
VALUES ('14','otrocorreito@organizacion.org','369258147','Scoby','1996-11-3');
INSERT INTO usuario (id_user, email, contraseña, nombre_user, fecha_nac) 
VALUES ('9','elultimocorreito@example.exp','aguacate123','Aramis','1997-12-25');

CREATE TABLE usuario_free 
(
	id_user INT(10) PRIMARY KEY,
	CONSTRAINT fk_user_free FOREIGN KEY (id_user) REFERENCES usuario (id_user) ON DELETE CASCADE ON UPDATE CASCADE 
);

INSERT INTO usuario_free (id_user) 
VALUES ('649');

CREATE TABLE usuario_premium 
(
	id_user INT(10) PRIMARY KEY,
	n_telefono INT(9) NOT NULL,
	fech_renovacion DATE NOT NULL,
	CONSTRAINT fk_user_prem FOREIGN KEY (id_user) REFERENCES usuario (id_user) ON DELETE CASCADE ON UPDATE CASCADE 
);

INSERT INTO usuario_premium (id_user, n_telefono, fech_renovacion) 
VALUES ('123','612345678','2021-2-4');
INSERT INTO usuario_premium (id_user, n_telefono, fech_renovacion) 
VALUES ('25','600896475','2021-12-30');
INSERT INTO usuario_premium (id_user, n_telefono, fech_renovacion) 
VALUES ('14','765432189','2021-10-25');
INSERT INTO usuario_premium (id_user, n_telefono, fech_renovacion) 
VALUES ('9','666258741','2021-12-12');

CREATE TABLE playlist
(
	id_playlist INT(10) PRIMARY KEY,
	id_user INT(10),
	titulo_playlist VARCHAR(25) NOT NULL,
	n_videos INT NOT NULL,
	CONSTRAINT fk_user_play FOREIGN KEY (id_user) REFERENCES usuario (id_user) ON DELETE CASCADE ON UPDATE CASCADE 
);

INSERT INTO playlist (id_playlist, id_user, titulo_playlist, n_videos) 
VALUES ('3','123','Chill', '23');
INSERT INTO playlist (id_playlist, id_user, titulo_playlist, n_videos) 
VALUES ('42','123','Domingo', '19');
INSERT INTO playlist (id_playlist, id_user, titulo_playlist, n_videos) 
VALUES ('102','14','Weekend', '59');
INSERT INTO playlist (id_playlist, id_user, titulo_playlist, n_videos) 
VALUES ('489','9','Relax', '4');

CREATE TABLE video
(
	cod_video INT(10) PRIMARY KEY,
	titulo_video VARCHAR(35) NOT NULL,
	imagen VARCHAR(50) NOT NULL, 
	video_ VARCHAR(50) NOT NULL,
	duracion TIME NOT NULL
);

INSERT INTO video (cod_video, titulo_video, imagen, video_, duracion ) 
VALUES ('1234','Interestellar', 'imagen1234', 'video1234', '2:12:54');
INSERT INTO video (cod_video, titulo_video, imagen, video_, duracion ) 
VALUES ('752','Unpause', 'imagen754', 'video754', '0:20:21');
INSERT INTO video (cod_video, titulo_video, imagen, video_, duracion ) 
VALUES ('12','El espejo', 'imagen12', 'video12', '0:57:14');
INSERT INTO video (cod_video, titulo_video, imagen, video_, duracion ) 
VALUES ('87','Batman', 'imagen87', 'video87', '2:7:18');


CREATE TABLE ven
(
	cod_video INT(10),
	id_user INT(10),
	fecha_hora_visionado DATETIME DEFAULT SYSDATE(),
	CONSTRAINT fk_video_ven FOREIGN KEY (cod_video) REFERENCES video (cod_video) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_user_ven FOREIGN KEY (id_user) REFERENCES usuario (id_user) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT pk_ven PRIMARY KEY (cod_video, id_user, fecha_hora_visionado)

);

INSERT INTO ven (cod_video, id_user, fecha_hora_visionado ) 
VALUES ('1234','649','2021-1-14 12:05:27');
INSERT INTO ven (cod_video, id_user, fecha_hora_visionado ) 
VALUES ('752','123','2019-9-22 09:06:55');
INSERT INTO ven (cod_video, id_user, fecha_hora_visionado ) 
VALUES ('12','9','2021-1-1 22:05:46');
INSERT INTO ven (cod_video, id_user, fecha_hora_visionado ) 
VALUES ('87','14','2020-14-7 16:32:25');

CREATE TABLE pelicula
(
	cod_video INT(10) PRIMARY KEY,
	director VARCHAR(35) NOT NULL,
	CONSTRAINT fk_video_pelicula FOREIGN KEY (cod_video) REFERENCES video (cod_video) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO pelicula (cod_video, director) 
VALUES ('1234', 'Christopher Nolan');
INSERT INTO pelicula (cod_video, director) 
VALUES ('87', 'Christopher Nolan');

CREATE TABLE serie
(
	cod_serie INT(10) PRIMARY KEY,
	nombre_serie VARCHAR(35) NOT NULL
);

CREATE TABLE episodio
(
	cod_video INT(10),
	cod_serie INT(10),
	n_episodios INT(3) NOT NULL,
	n_temporadas INT(2) NOT NULL,
	CONSTRAINT fk_video_episodio FOREIGN KEY (cod_video) REFERENCES video (cod_video) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_serie_episodio FOREIGN KEY (cod_serie) REFERENCES serie (cod_serie) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT pk_episodio PRIMARY KEY (cod_video, cod_serie)
);

CREATE TABLE guarda
(
	id_playlist INT(10),
	cod_video INT(10),
	CONSTRAINT fk_video_guarda FOREIGN KEY (cod_video) REFERENCES video (cod_video) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_playlist_guarda FOREIGN KEY (id_playlist) REFERENCES playlist (id_playlist) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT pk_guarda PRIMARY KEY (id_playlist, cod_video)

);


CREATE TABLE genero
(
	cod_genero INT (10) PRIMARY KEY,
	nombre_genero VARCHAR(10) NOT NULL
);

CREATE TABLE pertenece 
(
	cod_video INT(10),
	cod_genero INT (10),
	CONSTRAINT fk_video_pertenece FOREIGN KEY (cod_video) REFERENCES video (cod_video) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_generopertenece FOREIGN KEY (cod_genero) REFERENCES genero (cod_genero) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT pk_genero PRIMARY KEY (cod_video, cod_genero)
);
