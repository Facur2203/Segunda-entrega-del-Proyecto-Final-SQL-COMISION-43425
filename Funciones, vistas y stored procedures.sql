-- CREAMOS FUNCIONES
USE estudio_juridico;

DELIMITER $$
CREATE FUNCTION comision_profesional (precio_producto DECIMAL (10.2)) RETURNS DECIMAL (10.2)
DETERMINISTIC 
BEGIN
DECLARE comision DECIMAL (10.2);
SET comision = precio_producto * 0.2;
RETURN comision;
END;
$$ 

DELIMITER ;

DELIMITER $$

CREATE FUNCTION convertir_ius (ius DECIMAL(10.2)) RETURNS DECIMAL(10.2)
DETERMINISTIC
BEGIN
DECLARE resultado DECIMAL (10.2);
DECLARE valor_ius DECIMAL(10.2);
SET valor_ius = 13000;
SET resultado = valor_ius * ius;
RETURN resultado;
END;
$$

-- CREAMOS STORED PROCEDURES

CREATE PROCEDURE insertar_cliente(
    IN nombre VARCHAR(50),
    IN apellido VARCHAR(50),
    IN tipo_documento INT,
    IN no_documento VARCHAR(50),
    IN no_telefono INT,
    IN email VARCHAR(200),
    IN calle VARCHAR(80),
    IN altura VARCHAR(10),
    IN piso VARCHAR(4),
    IN departamento VARCHAR(4),
    IN localidad INT
)
BEGIN
    -- Insertamos datos en la tabla domicilios
    INSERT INTO domicilios (localidad, calle, altura, piso, departamento)
    VALUES (localidad, calle, altura, piso, departamento);
    
    -- seteamos el id de domicilios
    SET @domicilios_id = LAST_INSERT_ID();
    
    -- Insertamos datos en la tabla personas
    INSERT INTO personas (domicilio, nombre, apellido, email, no_telefono, tipo_documento, no_documento)
    VALUES (@domicilios_id, nombre, apellido, email, no_telefono, tipo_documento, no_documento);
    
    -- declaramos y seteamos id personas
    SET @personas_id = LAST_INSERT_ID();
    
    -- Insertamos datos en la tabla clientes
    INSERT INTO clientes (persona)
    VALUES (@personas_id);
    
END;
$$

CREATE PROCEDURE insertar_profesional(
    IN nombre VARCHAR(50),
    IN apellido VARCHAR(50),
    IN tipo_documento INT,
    IN no_documento VARCHAR(50),
    IN no_telefono INT,
    IN email VARCHAR(200),
    IN calle VARCHAR(80),
    IN altura VARCHAR(10),
    IN piso VARCHAR(4),
    IN departamento VARCHAR(4),
    IN localidad INT
)
BEGIN
    -- Insertamos datos en la tabla domicilios
    INSERT INTO domicilios (localidad, calle, altura, piso, departamento)
    VALUES (localidad, calle, altura, piso, departamento);
    
    -- seteamos el id de domicilios
    SET @domicilios_id = LAST_INSERT_ID();
    
    -- Insertamos datos en la tabla personas
    INSERT INTO personas (domicilio, nombre, apellido, email, no_telefono, tipo_documento, no_documento)
    VALUES (@domicilios_id, nombre, apellido, email, no_telefono, tipo_documento, no_documento);
    
    -- declaramos y seteamos id personas
    SET @personas_id = LAST_INSERT_ID();
    
    -- Insertamos datos en la tabla clientes
    INSERT INTO profesionales (persona)
    VALUES (@personas_id);
    
END;
$$

DELIMITER ;

-- CREAMOS VISTAS

-- CREAMOS VISTAS 

CREATE OR REPLACE VIEW VW_clientes_data AS
SELECT clientes.id_cliente, personas.* FROM clientes JOIN personas ON clientes.persona = personas.id_persona;

CREATE OR REPLACE VIEW VW_profesionales_data AS
SELECT profesionales.id_profesional, personas.* FROM profesionales JOIN personas ON profesionales.persona = personas.id_persona;

CREATE OR REPLACE VIEW VW_productos_valor AS
SELECT nombre, convertir_ius(valor) AS valor_en_pesos FROM productos;

CREATE OR REPLACE VIEW VW_honorarios_sin_cobrar AS
SELECT * FROM honorarios WHERE cobrado = 0;

CREATE OR REPLACE VIEW VW_contratos_sin_cobrar AS
SELECT * FROM contratos WHERE cobrado = 0;