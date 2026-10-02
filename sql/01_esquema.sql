-- =====================================================================
-- 01_esquema.sql
-- Base de datos: empresa-retail-db
-- Motor: MySQL 8.0+
-- Fuente: modelo entidad-relacion empresa-retail-bd.mwb (MySQL Workbench)
--
-- NOTA: el nombre de la base de datos contiene guiones, por lo que en
-- todas las sentencias se escribe entre comillas invertidas (`).
-- =====================================================================

DROP DATABASE IF EXISTS `empresa-retail-db`;
CREATE DATABASE `empresa-retail-db`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE `empresa-retail-db`;

-- ---------------------------------------------------------------------
-- cliente
-- ---------------------------------------------------------------------
CREATE TABLE cliente (
    cli_id_cliente      INT          NOT NULL AUTO_INCREMENT,
    cli_nombre          VARCHAR(100) NOT NULL,
    cli_apellido        VARCHAR(100) NOT NULL,
    cli_correo          VARCHAR(100) NOT NULL,
    cli_telefono        VARCHAR(25)  NOT NULL,
    cli_ciudad          VARCHAR(45)  NOT NULL,
    cli_fecha_registro  DATE         NOT NULL,
    PRIMARY KEY (cli_id_cliente),
    UNIQUE KEY cli_correo_UNIQUE (cli_correo)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- canal
-- ---------------------------------------------------------------------
CREATE TABLE canal (
    can_id_canal  INT         NOT NULL AUTO_INCREMENT,
    can_nombre    VARCHAR(80) NOT NULL,
    can_tipo      ENUM('Red Social','Buscador','Email') NOT NULL,
    PRIMARY KEY (can_id_canal)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- campania
-- ---------------------------------------------------------------------
CREATE TABLE campania (
    cam_id_campania     INT           NOT NULL AUTO_INCREMENT,
    cam_nombre          VARCHAR(120)  NOT NULL,
    cam_presupuesto     DECIMAL(12,2) NOT NULL,
    cam_fecha_inicio    DATE          NOT NULL,
    cam_fecha_final     DATE          NOT NULL,
    canal_can_id_canal  INT           NOT NULL,
    PRIMARY KEY (cam_id_campania),
    KEY fk_campania_canal1_idx (canal_can_id_canal),
    CONSTRAINT fk_campania_canal1
        FOREIGN KEY (canal_can_id_canal) REFERENCES canal (can_id_canal)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- interaccion (clic, visita, comentario, descarga de un cliente en una campania)
-- ---------------------------------------------------------------------
CREATE TABLE interaccion (
    int_id_interaccion        INT  NOT NULL AUTO_INCREMENT,
    int_tipo                  ENUM('clic','visita','comentario','descarga') NOT NULL,
    int_fecha                 DATE NOT NULL,
    campania_cam_id_campania  INT  NOT NULL,
    cliente_cli_id_cliente    INT  NOT NULL,
    PRIMARY KEY (int_id_interaccion),
    KEY fk_interaccion_campania1_idx (campania_cam_id_campania),
    KEY fk_interaccion_cliente1_idx  (cliente_cli_id_cliente),
    CONSTRAINT fk_interaccion_campania1
        FOREIGN KEY (campania_cam_id_campania) REFERENCES campania (cam_id_campania)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_interaccion_cliente1
        FOREIGN KEY (cliente_cli_id_cliente) REFERENCES cliente (cli_id_cliente)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- conversion (compra, registro, suscripcion)
-- ---------------------------------------------------------------------
CREATE TABLE conversion (
    con_id_conversion       INT           NOT NULL AUTO_INCREMENT,
    con_tipo                ENUM('compra','registro','suscripcion') NOT NULL,
    con_valor               DECIMAL(12,2) NOT NULL,
    con_fecha               DATE          NOT NULL,
    cliente_cli_id_cliente  INT           NOT NULL,
    PRIMARY KEY (con_id_conversion),
    KEY fk_conversacion_cliente1_idx (cliente_cli_id_cliente),
    CONSTRAINT fk_conversacion_cliente1
        FOREIGN KEY (cliente_cli_id_cliente) REFERENCES cliente (cli_id_cliente)
        ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Datos de ejemplo (el modelo no incluye datos; se agregan para pruebas)
-- ---------------------------------------------------------------------
INSERT INTO cliente
    (cli_nombre, cli_apellido, cli_correo, cli_telefono, cli_ciudad, cli_fecha_registro) VALUES
('Laura',  'Gomez',   'laura.gomez@correo.com',   '3001112233', 'Popayan',  '2026-01-15'),
('Carlos', 'Rivera',  'carlos.rivera@correo.com', '3004445566', 'Cali',     '2026-02-03'),
('Sofia',  'Mendoza', 'sofia.mendoza@correo.com', '3007778899', 'Bogota',   '2026-03-20'),
('Andres', 'Torres',  'andres.torres@correo.com', '3010001122', 'Medellin', '2026-04-11');

INSERT INTO canal (can_nombre, can_tipo) VALUES
('Instagram',        'Red Social'),
('Google Ads',       'Buscador'),
('Boletin semanal',  'Email');

INSERT INTO campania
    (cam_nombre, cam_presupuesto, cam_fecha_inicio, cam_fecha_final, canal_can_id_canal) VALUES
('Lanzamiento primavera',  5000000.00, '2026-03-01', '2026-03-31', 1),
('Descuento de temporada', 3200000.00, '2026-06-01', '2026-06-30', 2),
('Fidelizacion clientes',  1800000.00, '2026-08-01', '2026-09-30', 3);

INSERT INTO interaccion
    (int_tipo, int_fecha, campania_cam_id_campania, cliente_cli_id_cliente) VALUES
('clic',       '2026-03-04', 1, 1),
('visita',     '2026-03-10', 1, 2),
('comentario', '2026-06-08', 2, 3),
('descarga',   '2026-08-12', 3, 4);

INSERT INTO conversion
    (con_tipo, con_valor, con_fecha, cliente_cli_id_cliente) VALUES
('registro',    0.00,      '2026-03-05', 1),
('compra',      280000.00, '2026-03-12', 2),
('compra',      150000.00, '2026-06-10', 3),
('suscripcion', 30000.00,  '2026-08-15', 4),
('compra',      95000.00,  '2026-06-18', 1);
