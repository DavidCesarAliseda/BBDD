DROP DATABASE IF EXISTS pokemon ;
CREATE DATABASE pokemon;
USE pokemon;

CREATE TABLE pokeball
(
	id_pokeball INT(1) PRIMARY KEY,
	nombre_pokeball ENUM ('Pokeball', 'Superball', 'Ultraball', 'Masterball', 'SafariBall') NOT NULL
);

CREATE TABLE tipo_pokemon
(
	id_tipo_pokemon INT(2) PRIMARY KEY,
	nombre_tipo_pokemon ENUM ('Agua', 'Bicho', 'Dragón', 'Eléctrico', 'Fantasma', 'Fuego', 'Hada', 'Hielo', 'Lucha', 'Normal', 'Planta', 'Psíquico', 'Roca', 'Tierra', 'Veneno') NOT NULL
);

CREATE TABLE pokemon
(
	id_pokemon INT(5) PRIMARY KEY,
	nombre_pokemon VARCHAR(30) NOT NULL,
	peso DECIMAL NOT NULL,
	altura DECIMAL NOT NULL,
	genero ENUM ('Masculino', 'Femenino') NOT NULL,
	nivel INT(3) NOT NULL CHECK (nivel<101) 
);

CREATE TABLE pertenecen
(
	id_pokemon INT(5),
	id_tipo_pokemon INT(2),
	CONSTRAINT fk_poke_pert FOREIGN KEY (id_pokemon) REFERENCES pokemon (id_pokemon) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_tipo_pert FOREIGN KEY (id_tipo_pokemon) REFERENCES tipo_pokemon (id_tipo_pokemon) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT pk_pert PRIMARY KEY (id_pokemon, id_tipo_pokemon)
);

CREATE TABLE estadisticas
(
	id_pokemon INT(5) PRIMARY KEY,
	Puntos_Salud INT(3) NOT NULL, 
	Ataque INT(3) NOT NULL, 
	Defensa INT(3) NOT NULL, 
	Especial INT(3) NOT NULL, 
	Velocidad INT(3) NOT NULL, 
	Puntos_Salud_Base INT(3) NOT NULL, 
	Ataque_Base INT(3) NOT NULL, 
	Defensa_Base INT(3) NOT NULL, 
	Especial_Base INT(3) NOT NULL,
	Velocidad_Base INT(3) NOT NULL,
	CONSTRAINT fk_poke_estad FOREIGN KEY (id_pokemon) REFERENCES pokemon (id_pokemon) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE evoluciona
(
	id_pokemon INT(5) PRIMARY KEY,
	id_pokemon_evo INT(5) UNIQUE,
	forma ENUM ('Nivel', 'Piedra') NOT NULL,
	CONSTRAINT fk_poke_evo FOREIGN KEY (id_pokemon) REFERENCES pokemon (id_pokemon) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_pokee_evo FOREIGN KEY (id_pokemon_evo) REFERENCES pokemon (id_pokemon) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE movimiento
(
	id_movimiento INT(3) PRIMARY KEY,
	forma_aprendizaje ENUM ('Nivel', 'MT', 'MO') NOT NULL,
	categoria_daño	ENUM ('Fisico', 'Espacial', 'Estado') NOT NULL,
	puntos_poder INT(2) NOT NULL,
	efecto_secundario VARCHAR(10) NOT NULL,
	descripcion VARCHAR(50)
);

CREATE TABLE usan 
(
	id_pokemon INT(5),
	id_movimiento INT(3),
	CONSTRAINT fk_poke_usan FOREIGN KEY (id_pokemon) REFERENCES pokemon (id_pokemon) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_mov_usan FOREIGN KEY (id_movimiento) REFERENCES movimiento (id_movimiento) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT pk_usan PRIMARY KEY (id_pokemon, id_movimiento)
);

CREATE TABLE combate
(
	id_combate INT(5) PRIMARY KEY,
	resultado ENUM ('Ganado', 'Perdido') NOT NULL,
	id_pokemon_oponente INT(5),
	CONSTRAINT fk_poke_comb FOREIGN KEY (id_pokemon_oponente) REFERENCES pokemon (id_pokemon) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE hacen
(
	id_pokemon INT(5),
	id_combate INT(5),
	CONSTRAINT fk_poke_hacen FOREIGN KEY (id_pokemon) REFERENCES pokemon (id_pokemon) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_comb_hacen FOREIGN KEY (id_combate) REFERENCES combate (id_combate) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT pk_hacen PRIMARY KEY (id_pokemon, id_combate)
);

CREATE TABLE gimnasio
(
	id_gimnasio INT(2),
	lider VARCHAR (30) NOT NULL,
	id_tipo INT(2) NOT NULL,
	pueblo VARCHAR(25) NOT NULL,
	medalla VARCHAR(25) NOT NULL,
	id_combate INT(5),
	CONSTRAINT fk_comb_gim FOREIGN KEY (id_combate) REFERENCES combate (id_combate) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT pk_gim PRIMARY KEY (id_gimnasio, id_combate)
);

CREATE TABLE mundo
(
	id_lugar INT(5),
	nombre_lugar VARCHAR(30) NOT NULL,
	id_combate INT(5),
	CONSTRAINT fk_comb_lug FOREIGN KEY (id_combate) REFERENCES combate (id_combate) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT pk_gim PRIMARY KEY (id_lugar, id_combate)
);
