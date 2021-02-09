/*Paso a DDL Cursos*/
DROP DATABASE IF EXISTS david_cursos ;
CREATE DATABASE david_cursos;
USE david_cursos;

CREATE TABLE usuario
(
	id_user INT(10) PRIMARY KEY,
	email VARCHAR(40) NOT NULL
);

INSERT INTO usuario (id_user, email) 
VALUES ('123','primercorreo@example.exp');
INSERT INTO usuario (id_user, email) 
VALUES ('649','correito@example.exp');
INSERT INTO usuario (id_user, email) 
VALUES ('25','ejemplo@organizacion.org');
INSERT INTO usuario (id_user, email) 
VALUES ('14','otrocorreito@organizacion.org');
INSERT INTO usuario (id_user, email) 
VALUES ('9','elultimocorreito@example.exp');

CREATE TABLE usuario_invitado
(
	id_user_invi INT(10) PRIMARY KEY,
	CONSTRAINT fk_user_invi FOREIGN KEY (id_user_invi) REFERENCES usuario (id_user) ON DELETE CASCADE ON UPDATE CASCADE 	
);

INSERT INTO usuario_invitado (id_user_invi) 
VALUES ('123');
INSERT INTO usuario_invitado (id_user_invi) 
VALUES ('649');

CREATE TABLE profesor
(
	dni CHAR(9) PRIMARY KEY,
	num_tlf INT(9) NOT NULL CHECK (num_tlf>600000000 AND num_tlf<800000000)
);

INSERT INTO profesor (dni, num_tlf) 
VALUES ('48562458C','678945632');
INSERT INTO profesor (dni, num_tlf) 
VALUES ('45678912F','798546251');
INSERT INTO profesor (dni, num_tlf) 
VALUES ('95874621T','678945632');
INSERT INTO profesor (dni, num_tlf) 
VALUES ('26589412H','696258429');

CREATE TABLE profesor_creador
(
	dni_prof_cread CHAR(9) PRIMARY KEY,
	CONSTRAINT fk_prof_cread FOREIGN KEY (dni_prof_cread) REFERENCES profesor (dni) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO profesor_creador (dni_prof_cread) 
VALUES ('95874621T');
INSERT INTO profesor_creador (dni_prof_cread) 
VALUES ('26589412H');

CREATE TABLE profesor_eva
(
	dni_prof_eva CHAR(9) PRIMARY KEY,
	CONSTRAINT fk_prof_eva FOREIGN KEY (dni_prof_eva) REFERENCES profesor (dni) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO profesor_eva (dni_prof_eva) 
VALUES ('48562458C');
INSERT INTO profesor_eva (dni_prof_eva) 
VALUES ('45678912F');

CREATE TABLE usuario_registrado
(
	id_user_reg INT(10),
	contraseña VARCHAR(20) NOT NULL,
	nota INT(2) NOT NULL CHECK (nota >= 0 AND nota <=10),
	dni_prof_eva CHAR(9),
	CONSTRAINT fk_user_reg FOREIGN KEY (id_user_reg) REFERENCES usuario (id_user) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_prof_reg FOREIGN KEY (dni_prof_eva) REFERENCES profesor_eva (dni_prof_eva) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT pk_usuario_reg PRIMARY KEY (id_user_reg, dni_prof_eva)
);

INSERT INTO usuario_registrado (id_user_reg, contraseña, nota, dni_prof_eva) 
VALUES ('25','123ABC', '8', '48562458C');
INSERT INTO usuario_registrado (id_user_reg, contraseña, nota, dni_prof_eva)  
VALUES ('14','a_b_c_d', '4', '48562458C');
INSERT INTO usuario_registrado (id_user_reg, contraseña, nota, dni_prof_eva) 
VALUES ('9','8462SE', '10', '45678912F');

CREATE TABLE archivos
(
	codigo_arch INT(10) PRIMARY KEY,
	titulo VARCHAR(25) NOT NULL,
	contenido_archivo VARCHAR(50) NOT NULL
	
);

INSERT INTO archivos (codigo_arch, titulo, contenido_archivo) 
VALUES ('4865','titulo1', 'ruta1');
INSERT INTO archivos (codigo_arch, titulo, contenido_archivo) 
VALUES ('62985','titulo2', 'ruta2');
INSERT INTO archivos (codigo_arch, titulo, contenido_archivo) 
VALUES ('5','titulo3', 'ruta3');

CREATE TABLE consultan
(
	id_user INT(10),
	codigo_arch INT(10),
	fecha_consulta DATE DEFAULT SYSDATE(),
	CONSTRAINT fk_user_consultan FOREIGN KEY (id_user) REFERENCES usuario (id_user) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_arch_consultan FOREIGN KEY (codigo_arch) REFERENCES archivos (codigo_arch) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT pk_consultan PRIMARY KEY (id_user,codigo_arch, fecha_consulta)
	
);

INSERT INTO consultan (id_user, codigo_arch) 
VALUES ('649','4865', '2020-8-9');
INSERT INTO consultan (id_user, codigo_arch) 
VALUES ('25','62985', '2020-6-7');
INSERT INTO consultan (id_user, codigo_arch) 
VALUES ('14','4865', '2020-3-1');
INSERT INTO consultan (id_user, codigo_arch) 
VALUES ('9','5', '2020-10-11');

CREATE TABLE video
(
	cod_video INT(10) PRIMARY KEY,
	duracion TIME NOT NULL,
	titulo VARCHAR(30),
	imagen VARCHAR(50) NOT NULL,
	fecha_subida DATE DEFAULT CURDATE(),
	dni_prof_cread CHAR(9),
   CONSTRAINT fk_prof_video FOREIGN KEY (dni_prof_cread) REFERENCES profesor_creador (dni_prof_cread) ON DELETE CASCADE ON UPDATE CASCADE
		
);

INSERT INTO video (cod_video, duracion, titulo, imagen, fecha_subida, dni_prof_cread) 
VALUES ('51','00:51:36', 'primertitulo', 'RUTA1', '2020-12-25', '95874621T' );
INSERT INTO video (cod_video, duracion, titulo, imagen, fecha_subida, dni_prof_cread) 
VALUES ('963','00:27:02', 'otrotitulo', 'RUTA2', '2020-11-29', '95874621T' );
INSERT INTO video (cod_video, duracion, titulo, imagen, fecha_subida, dni_prof_cread) 
VALUES ('1150','01:10:37', 'ultimotitulo', 'RUTA3', '2020-6-9', '26589412H' );

CREATE TABLE ven
(
	id_user INT(10),
	cod_video INT(10),
	fecha_visualiz DATETIME DEFAULT SYSDATE(),
	CONSTRAINT fk_user_ven FOREIGN KEY (id_user) REFERENCES usuario (id_user) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_video_ven FOREIGN KEY (cod_video) REFERENCES video (cod_video) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT pk_ven PRIMARY KEY (id_user, cod_video, fecha_visualiz)
	
);

INSERT INTO ven (id_user, cod_video, fecha_visualiz) 
VALUES ('25','51', '2021-1-14 12:05:27');
INSERT INTO ven (id_user, cod_video, fecha_visualiz) 
VALUES ('14', '963','2019-9-22 09:06:55');
INSERT INTO ven (id_user, cod_video, fecha_visualiz) 
VALUES ('9', '1150', '2021-1-1 22:05:46');