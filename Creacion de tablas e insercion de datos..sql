DROP DATABASE estudio_juridico;

CREATE DATABASE IF NOT exists estudio_juridico;

USE estudio_juridico;

-- (1) TABLA DE PAISES 
CREATE TABLE paises (
	id_pais INT NOT NULL UNIQUE	AUTO_INCREMENT,
    nombre VARCHAR(70) NOT NULL UNIQUE,
	CONSTRAINT PK_paises PRIMARY KEY (id_pais)
	);

-- (2) TABLA DE PROVINCIAS 
CREATE TABLE provincias (
	id_provincia INT NOT NULL UNIQUE AUTO_INCREMENT,
    pais INT NOT NULL,
    nombre	VARCHAR(70) NOT NULL UNIQUE,
	CONSTRAINT PK_provincias PRIMARY KEY (id_provincia),
	CONSTRAINT FK_pais_provincias
    FOREIGN KEY (pais)
    REFERENCES paises (id_pais)
    );

-- (3) TABLA DE LOCALIDADES
CREATE TABLE localidades (
	id_localidad INT NOT NULL UNIQUE auto_increment,
	nombre VARCHAR(70)	NOT NULL,
	provincia INT NOT NULL,
	CONSTRAINT PK_localidades PRIMARY KEY (id_localidad),
	CONSTRAINT FK_provincia_localidades
    FOREIGN KEY (provincia)
    REFERENCES provincias (id_provincia)
    );

-- (4) TABLA DE DOMICILIOS 
CREATE TABLE domicilios (
	id_domicilio INT NOT NULL UNIQUE AUTO_INCREMENT,
    localidad INT NOT NULL,
	calle VARCHAR(80) NOT NULL,
	altura VARCHAR(10) NOT NULL,
    piso VARCHAR(4), 
    departamento VARCHAR(4),
    CONSTRAINT PK_domicilios PRIMARY KEY (id_domicilio),
    CONSTRAINT FK_localidad_domicilios
    FOREIGN KEY (localidad)
    REFERENCES localidades (id_localidad)
	);

-- (5) TABLA TIPOS DE DOCUMENTOS 
CREATE TABLE tipos_de_documentos (
	id_tipo_documento INT NOT NULL UNIQUE auto_increment,
    nombre VARCHAR(30) NOT NULL,
    CONSTRAINT PK_tipos_de_documento PRIMARY KEY (id_tipo_documento)
    );

-- (6) TABLA DE PERSONAS 
CREATE table personas (
	id_persona INT NOT NULL UNIQUE auto_increment,
	domicilio INT NOT NULL,
    nombre VARCHAR (50) NOT NULL,
    apellido VARCHAR (50) NOT NULL,
    email VARCHAR (200) NOT NULL,
    no_telefono INT NOT NULL,
    tipo_documento INT NOT NULL,
    no_documento VARCHAR(30) NOT NULL,
    CONSTRAINT PK_personas PRIMARY KEY (id_persona),
    CONSTRAINT FK_domicilio_personas
    FOREIGN KEY (domicilio)
    REFERENCES domicilios (id_domicilio),
    CONSTRAINT FK_tipo_documento_personas
    FOREIGN KEY (tipo_documento)
    REFERENCES tipos_de_documentos (id_tipo_documento)
    );
    
-- (7) TABLA DE CLIENTES 
CREATE TABLE clientes (
	id_cliente INT NOT NULL UNIQUE auto_increment,
    persona INT NOT NULL UNIQUE,
    CONSTRAINT PK_clientes PRIMARY KEY (id_cliente),
    CONSTRAINT FK_persona_clientes
    FOREIGN KEY (persona)
    REFERENCES personas (id_persona)
    );

-- (8) TABLA DE PROFESIONALES 
CREATE TABLE profesionales  (
	id_profesional INT NOT NULL UNIQUE auto_increment,
    persona INT NOT NULL UNIQUE,
    CONSTRAINT PK_profesionales PRIMARY KEY (id_profesional),
	CONSTRAINT FK_persona_profesionales
    FOREIGN KEY (persona)
    REFERENCES personas (id_persona)
    );

-- (9) TABLA DE RAMAS 
CREATE TABLE ramas (
	id_rama INT NOT NULL UNIQUE auto_increment,
    denominacion VARCHAR(50) NOT NULL UNIQUE,
    CONSTRAINT PK_ramas PRIMARY KEY (id_rama)
    );

-- (10) TABLA DE CONSULTAS 
CREATE TABLE consultas (
	id_consulta INT NOT NULL UNIQUE auto_increment,
    jurisdiccion INT NOT NULL,
    descripcion VARCHAR(500),
    CONSTRAINT PK_consultas PRIMARY KEY (id_consulta),
    CONSTRAINT FK_jurisdiccion_consultas
    FOREIGN KEY (jurisdiccion)
    REFERENCES provincias (id_provincia)
    );
 
 -- (11) TABLA MONEDAS 
CREATE TABLE monedas (
	id_moneda INT NOT NULL UNIQUE	AUTO_INCREMENT,
    nombre VARCHAR(70) NOT NULL UNIQUE,
	CONSTRAINT PK_monedas PRIMARY KEY (id_moneda)
	); 
  
-- (12) TABLA DE CONTRATOS 
CREATE TABLE contratos (
	id_contrato INT NOT NULL UNIQUE auto_increment,
    consulta INT NOT NULL,
    profesional INT NOT NULL,
    moneda INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NULL,
    valor DECIMAL(10.2) NOT NULL,
    cobrado boolean NOT NULL,
    CONSTRAINT PK_contratos PRIMARY KEY (id_contrato),
    CONSTRAINT FK_consulta_contratos
    FOREIGN KEY (consulta)
    REFERENCES consultas (id_consulta),
    CONSTRAINT FK_profesional_contratos
    FOREIGN KEY (profesional)
    REFERENCES profesionales (id_profesional),
    CONSTRAINT FK_moneda_contratos
    FOREIGN KEY (moneda)
    REFERENCES monedas (id_moneda)
    );

-- (13) TABLA DE HONORARIOS 
CREATE TABLE honorarios (
	id_honorario INT NOT NULL UNIQUE auto_increment,
    contrato INT NOT NULL,
    moneda INT NOT NULL,
    resolucion VARCHAR(80),
    valor DECIMAL(10.2) NOT NULL,
    cobrado BOOLEAN NOT NULL,
	CONSTRAINT PK_honorarios PRIMARY KEY (id_honorario),
    CONSTRAINT FK_contrato_honorarios
    FOREIGN KEY (contrato)
    REFERENCES contratos (id_contrato),
    CONSTRAINT FK_moneda_honorarios
    FOREIGN KEY (moneda)
    REFERENCES monedas (id_moneda)
    );

-- (14) TABLA DE COMPROBANTES 
 CREATE TABLE comprobantes (
	id_comprobante INT NOT NULL UNIQUE auto_increment,
    no_comprobante VARCHAR(50) NOT NULL UNIQUE,
    persona INT NULL, -- SE AGREGA ESTE ATRIBUTO PORQUE LOS HONORARIOS EN OCACIONES NO LOS PAGA EL CLIENTE --
    moneda INT NOT NULL,
    valor DECIMAL (10,2) NOT NULL,
    honorario INT NULL, 
	contrato INT NULL,
   CONSTRAINT PK_comprobantes PRIMARY KEY (id_comprobante),
    CONSTRAINT FK_persona_comprobantes
    FOREIGN KEY (persona)
    REFERENCES personas (id_persona),
    CONSTRAINT FK_moneda_comprobantes
    FOREIGN KEY (moneda)
    REFERENCES monedas (id_moneda),
    CONSTRAINT FK_honorario_comprobantes
    FOREIGN KEY (honorario)
    REFERENCES honorarios (id_honorario),
    CONSTRAINT FK_contrato_comprobantes
    FOREIGN KEY (contrato)
    REFERENCES contratos (id_contrato)
	);
 
-- (15) TABLA DE PRODUCTOS
CREATE TABLE productos (
	id_producto INT NOT NULL UNIQUE AUTO_INCREMENT,
    nombre VARCHAR(60) NOT NULL,
    moneda INT NOT NULL,
    valor DECIMAL(10.2) NOT NULL,
    CONSTRAINT PK_productos PRIMARY KEY (id_producto),
    CONSTRAINT FK_moneda_productos
    FOREIGN KEY (moneda)
    REFERENCES monedas (id_moneda)
    );

-- TABLAS DE HECHO. NORMALIZACION    
-- (16) TABLA PROVINCIAS_PROFESIONALES 
CREATE TABLE provincias_profesionales (
	id_profesional INT NOT NULL,
    id_provincia INT NOT NULL,
    matricula VARCHAR(30) NOT NULL,
    CONSTRAINT PK_provincias_profesionales PRIMARY KEY (id_profesional, id_provincia),
    CONSTRAINT FK_id_profesional_provincias_profesionales
    FOREIGN KEY (id_profesional)
    REFERENCES profesionales (id_profesional),
    CONSTRAINT FK_id_provincia_provincias_profesionales
    FOREIGN KEY (id_provincia)
    REFERENCES provincias (id_provincia)
    );

-- (17) TABLA RAMAS_PROFESIONALES 
CREATE TABLE ramas_profesionales (
	id_profesional INT NOT NULL,
    id_rama INT NOT NULL,
    CONSTRAINT PK_ramas_profesionales PRIMARY KEY  (id_profesional, id_rama),
    CONSTRAINT FK_id_profesional_ramas_profesionales
    FOREIGN KEY (id_profesional)
    REFERENCES profesionales (id_profesional),
    CONSTRAINT FK_id_rama_ramas_profesionales
    FOREIGN KEY (id_rama)
    REFERENCES ramas (id_rama)
    );

-- (18) TABLA CONSULTAS_RAMAS 
CREATE TABLE consultas_ramas (
	id_consulta INT NOT NULL,
    id_rama INT NOT NULL,
    CONSTRAINT PK_consulta_ramas PRIMARY KEY  (id_consulta, id_rama),
    CONSTRAINT FK_id_rama_consultas_ramas
    FOREIGN KEY (id_rama)
    REFERENCES ramas (id_rama),
    CONSTRAINT FK_id_consulta_consultas_ramas
    FOREIGN KEY (id_consulta)
    REFERENCES consultas (id_consulta)
    );

-- (19) TABLA CLIENTES_CONSULTAS
CREATE TABLE consultas_clientes (
	id_cliente INT NOT NULL,
    id_consulta INT NOT NULL,
    CONSTRAINT PK_clientes_consulta PRIMARY KEY  (id_cliente, id_consulta),
    CONSTRAINT FK_id_consulta_consultas_clientes
    FOREIGN KEY (id_consulta)
    REFERENCES consultas (id_consulta),
    CONSTRAINT FK_id_cliente_consultas_clientes
    FOREIGN KEY (id_cliente)
    REFERENCES clientes (id_cliente)
    );
    
-- (20) TABLA PRODUCTOS_CONTRATOS 
CREATE TABLE productos_contratos (
	id_producto INT NOT NULL,
    id_contrato INT NOT NULL,
    CONSTRAINT PK_productos_contratos PRIMARY KEY  (id_producto, id_contrato),
    CONSTRAINT FK_id_producto_productos_contratos
    FOREIGN KEY (id_producto)
    REFERENCES productos (id_producto),
    CONSTRAINT FK_id_contrato_productos_contratos
    FOREIGN KEY (id_contrato)
    REFERENCES contratos (id_contrato)
    );
    
    
-- INSERCION DE DATOS 
INSERT INTO paises (nombre)
    VALUES ('Argentina'), 
    ('Uruguay'),
    ('Brasil'),
    ('Paraguay'),
    ('Bolivia'),
    ('Chile');

INSERT INTO provincias (nombre, pais)
    VALUES ('Rio Negro', 1),
    ('Neuquen', 1),
    ('Buenos Aires', 1);

INSERT INTO localidades (nombre, provincia)
    VALUES ('Cinco Saltos', 1),
    ('Neuquen', 2),
    ('Cipolletti', 1),
    ('Bahia Blanca', 3);

-- INSERTAR EN TABLA DOMICILIOS 
INSERT INTO domicilios (localidad, calle, altura, piso, departamento)
	VALUES (1, 'Oscar Eduardo Cordoba', 150, 1, 'a'),
	(3, 'Hugo Benjamin Ibarra', 445, null, null),
	(3, 'Jorge Hernan Bermudez', 687, 2, 'c'),
	(3, 'Cristian Alberto Traverso', 121, 13, 'a'),
	(3, 'Anibal Samuel Matellan', 339, 6, 'c'),
	(2, 'Sebastian Alejandro Battaglia', 21, 22, null),
	(2, 'Mauricio Alberto Serna', 158, 5, 'a'),
    (2, 'Jose Horacio Basualdo', 476, null, null),
	(2,'Juan Roman Riquelme', 98, 10, 'c'),
	(4,'Marcelo Alejandro Delgado', 156, 16, 'b'),
	(4, 'Martin Palermo' , 478, 9, 'd'),
	(4, 'Virrey Carlos Bianchi', 258, 'PB', null);

-- INSERTAR EN TABLA TIPOS_DE_DOCUMENTOS 
INSERT INTO tipos_de_documentos (nombre)
	VALUES ('DNI'),
    ('CUIT'),
    ('LC'),
    ('PASAPORTE');
    
-- INSERTAR EN TABLA PERSONAS 
INSERT INTO personas (domicilio, nombre, apellido, email, no_telefono, tipo_documento, no_documento)
	VALUES (12, 'Maria', 'Gomez', 'ewferfe@email.com', 324987549, 1, 15748987),
	(11, 'Mariana', 'Perez', 'gbfgb@email.com', 9845617, 1, 12457899),
	(10, 'Jorge', 'Gimenez', 'trprrt@email.com', 216587463, 1, 30249879),
	(1, 'Jose', 'Molina', 'ertetpw@email.com', 168746241, 1, 38778741),
	(2, 'Juan', 'Martino', 'qwqqwer@email.com', 158798, 1, 11487996),
	(3, 'Pedro', 'Sosa', 'pppoew@email.com', 216542132, 1, 9214668),
	(9, 'Martina', 'Rodriguez', 'ergp@email.com', 1717116, 1, 24154983),
	(8, 'Josefa', 'Luna', 'mmffe@email.com', 331557, 1, 10233578),
	(7, 'Ernesto', 'Soto', 'eewg@email.com', 24178965, 2, 40335874),
	(4, 'Julio', 'Lopez','kkkwef@email.com', 115499871, 1, 5549999),
	(5, 'Claudia', 'Romero', 'mmer@email.com', 6654446, 2, 11248367),
	(6, 'Antonio', 'Sepulveda', 'rororo@email.com', 33187, 1, 25489335);


INSERT INTO clientes (persona)
    VALUES (2),
    (4),
    (5),
    (9),
    (10),
    (8),
    (6),
    (7);

INSERT INTO profesionales (persona)
    VALUES (11),
    (12),
    (1),
    (3);

INSERT INTO ramas (denominacion)
    VALUES ('derecho laboral'),
    ('derecho de familia'),
    ('derecho civil'),
    ('derecho general');

INSERT INTO consultas (jurisdiccion, descripcion)
    VALUES (2, 'sucesion'),
    (1, 'divorcio'),
    (2, 'despido'),
    (3, 'reparacion patrimonial'),
    (1, 'ejecucion de pagare'),
    (1, 'despido indirecto'),
    (1, 'alimentos'),
    (2, 'filiacion'),
    (3, 'sucesion');

INSERT INTO monedas (nombre)
	VALUES ('peso argentino'),
    ('dolar estadounidense'),
    ('ius federal');

INSERT INTO contratos (consulta, profesional, moneda, valor, fecha_inicio, fecha_fin, cobrado)
	VALUES (1, 3, 1, 100000, '2022-10-03', '2023-02-16', 1),
	(2, 1, 1, 23000, '2022-10-03', '2023-03-02', 1),
	(3, 3, 1, 50000, '2022-10-04', null, 1),
	(4, 4, 1, 5000, '2022-10-20', null, 1),
	(5, 2, 1, 14500, '2022-11-14', '2023-03-07', 1),
	(6, 1, 1, 5000, '2022-11-17', null, 1),
	(7, 2, 1, 32500, '2022-11-24', '2023-06-13', 1),
	(8, 1, 1, 18700, '2022-12-01', null, 1),
	(9, 4, 1, 50000, '2022-12-20', null, 0);

INSERT INTO honorarios (contrato, resolucion, moneda, valor, cobrado)
	VALUES (1,	'sentencia xxxxx', 1, 15000, '0'),
	(2,	'sentencia xx122', 1, 13000, '0'),
	(5,	'resolucion xxx', 1, 25000, '0'),
	(7, 'resolucion xx232', 1,22000, '0');

INSERT INTO comprobantes (no_comprobante, moneda, valor, contrato)
	VALUES ('FA0001 00000009', 1, 100000, 1),
	('FB0001 00000034', 1, 23000, 2),
	('FB0001 00000035', 1, 50000, 3),
	('FB0001 00000036', 1, 5000, 4),
	('FB0001 00000037', 1, 14500, 5),
	('FB0001 00000038', 1, 5000, 6),
	('FA0001 00000010', 1, 32500, 7),
	('FA0001 00000011', 1, 18700, 8),
	('FB0001 00000039', 1, 23000, 9);

INSERT INTO productos (nombre, moneda, valor)
	VALUES ('sucesion',3,5),
	('divorcio',3,10),
	('consulta',3,1),
	('despido_de_empleado',3,4),
	('carta_documento',3,1),
	('despido_por_empleador',3,7),
	('usucapion',3,5),
	('desalojo',3,5),
	('filiacion',3,3),
	('dyp',3,6);

INSERT INTO provincias_profesionales (id_profesional, id_provincia, matricula)
	VALUES (1,	1, 'T XI F 234'),
	(2,	1, 'T IX F 12'),
	(3,	2, 'T X F 66'),
	(4,	3, 'T VIII F 43'),
	(1,	2, 'T XII F 176');

INSERT INTO ramas_profesionales (id_rama, id_profesional)
	VALUES (4,	1),
	(4,	2),
	(4,	3),
	(4,	4),
	(3,	3),
	(3,	2),
	(2,	3),
	(2,	4),
	(1,	1);

INSERT INTO consultas_ramas (id_consulta, id_rama)
	VALUES (1,	4),
	(2,	4),
	(3,	4),
	(4,	4),
	(5,	4),
	(6,	4),
	(7,	4),
	(8,	4),
	(9,	4),
	(1,	2),
	(2,	1),
	(3, 1),
	(4,	2),
	(5,	3),
	(6,	3),
	(7,	2),
	(8,	2),
	(9,	3);
    
INSERT INTO consultas_clientes (id_consulta, id_cliente)
	VALUES (1,	1),
	(2,	2),
	(3,	3),
	(4,	4),
	(5,	5),
	(6,	6),
	(7,	7),
	(8,	8),
	(9,	1);
    
INSERT INTO productos_contratos (id_contrato, id_producto)
	VALUES (1, 3),
    (1, 1),
    (2, 3),
    (2, 5),
    (2, 6),
    (3, 3),
	(3, 2),
	(4, 3),
    (4, 1),
    (5, 3),
    (5, 1),
    (6, 3),
    (6, 10),
    (7, 3),
    (7, 7),
	(8, 3),
	(8, 9),
    (9, 3),
    (9, 4);
    
-- end of file 


