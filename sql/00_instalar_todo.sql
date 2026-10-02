-- =====================================================================
-- 00_instalar_todo.sql
-- Ejecuta en orden: esquema, roles y usuarios, permisos y procedimientos.
-- ADVERTENCIA: borra y vuelve a crear la base `empresa-retail-db`.
-- Ejecutar con la cuenta root, una sola vez, con el rayo de Workbench.
-- =====================================================================

-- ----------------------------- 01_esquema.sql -----------------------------
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

-- ----------------------------- 02_roles_usuarios.sql -----------------------------
-- =====================================================================
-- 02_roles_usuarios.sql
-- Creacion de roles y usuarios.
-- Ejecutar como administrador (root).
--
-- NOTA: las contrasenas son de practica academica. En produccion deben
-- generarse de forma segura y no almacenarse en el repositorio.
-- =====================================================================

-- ---------------------------------------------------------------------
-- Roles (un rol por perfil de trabajo)
-- ---------------------------------------------------------------------
CREATE ROLE IF NOT EXISTS 'rol_ana';
CREATE ROLE IF NOT EXISTS 'rol_pedro';
CREATE ROLE IF NOT EXISTS 'rol_marta';

-- ---------------------------------------------------------------------
-- Usuarios
-- ---------------------------------------------------------------------
CREATE USER IF NOT EXISTS 'ana_crm'@'localhost'
    IDENTIFIED BY 'Retail2026!Caja';

CREATE USER IF NOT EXISTS 'pedro_mkt'@'localhost'
    IDENTIFIED BY 'Retail2026!Stock';

CREATE USER IF NOT EXISTS 'marta_auditoria'@'localhost'
    IDENTIFIED BY 'Retail2026!Admin';

-- ---------------------------------------------------------------------
-- Asignar cada rol a su usuario
-- ---------------------------------------------------------------------
GRANT 'rol_ana'   TO 'ana_crm'@'localhost';
GRANT 'rol_pedro' TO 'pedro_mkt'@'localhost';
GRANT 'rol_marta' TO 'marta_auditoria'@'localhost';

-- Activar el rol automaticamente al iniciar sesion
SET DEFAULT ROLE 'rol_ana'   TO 'ana_crm'@'localhost';
SET DEFAULT ROLE 'rol_pedro' TO 'pedro_mkt'@'localhost';
SET DEFAULT ROLE 'rol_marta' TO 'marta_auditoria'@'localhost';

-- ----------------------------- 03_permisos.sql -----------------------------
-- =====================================================================
-- 03_permisos.sql
-- Permisos por rol sobre la base de datos `empresa-retail-db`.
-- Principio de minimo privilegio: solo lo necesario, sin DELETE ni DDL.
-- =====================================================================

-- ---------------------------------------------------------------------
-- rol_ana (ana_crm): gestiona Clientes e Interacciones
-- Lectura y escritura.
-- ---------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE ON `empresa-retail-db`.cliente     TO 'rol_ana';
GRANT SELECT, INSERT, UPDATE ON `empresa-retail-db`.interaccion TO 'rol_ana';

-- ---------------------------------------------------------------------
-- rol_pedro (pedro_mkt): gestiona Canales y Campanias
-- Solo puede VER Clientes (sin modificar).
-- ---------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE ON `empresa-retail-db`.canal    TO 'rol_pedro';
GRANT SELECT, INSERT, UPDATE ON `empresa-retail-db`.campania TO 'rol_pedro';
GRANT SELECT                 ON `empresa-retail-db`.cliente  TO 'rol_pedro';

-- ---------------------------------------------------------------------
-- rol_marta (marta_auditoria): solo consulta de Conversiones
-- y ejecucion de procedimientos almacenados de consulta.
-- ---------------------------------------------------------------------
GRANT SELECT ON `empresa-retail-db`.conversion TO 'rol_marta';

-- El permiso EXECUTE sobre los procedimientos se otorga en
-- 04_procedimientos.sql, una vez que los procedimientos existen.

FLUSH PRIVILEGES;

-- ----------------------------- 04_procedimientos.sql -----------------------------
-- =====================================================================
-- 04_procedimientos.sql
-- Procedimientos almacenados de CONSULTA para el rol de auditoria.
-- SQL SECURITY DEFINER: el procedimiento se ejecuta con los permisos de
-- quien lo crea, por lo que marta solo necesita EXECUTE.
-- Todos consultan unicamente la tabla conversion.
-- =====================================================================

USE `empresa-retail-db`;

DROP PROCEDURE IF EXISTS sp_conversiones_por_tipo;
DROP PROCEDURE IF EXISTS sp_conversiones_por_rango;
DROP PROCEDURE IF EXISTS sp_resumen_conversiones_mensual;

DELIMITER $$

-- Cantidad y valor total de conversiones agrupadas por tipo
CREATE PROCEDURE sp_conversiones_por_tipo()
    SQL SECURITY DEFINER
    READS SQL DATA
BEGIN
    SELECT con_tipo          AS tipo,
           COUNT(*)          AS cantidad,
           SUM(con_valor)    AS valor_total
    FROM conversion
    GROUP BY con_tipo
    ORDER BY cantidad DESC;
END$$

-- Conversiones dentro de un rango de fechas
CREATE PROCEDURE sp_conversiones_por_rango(
    IN p_desde DATE,
    IN p_hasta DATE
)
    SQL SECURITY DEFINER
    READS SQL DATA
BEGIN
    SELECT con_id_conversion, con_tipo, con_valor, con_fecha,
           cliente_cli_id_cliente
    FROM conversion
    WHERE con_fecha BETWEEN p_desde AND p_hasta
    ORDER BY con_fecha;
END$$

-- Resumen mensual de conversiones
CREATE PROCEDURE sp_resumen_conversiones_mensual()
    SQL SECURITY DEFINER
    READS SQL DATA
BEGIN
    SELECT DATE_FORMAT(con_fecha, '%Y-%m') AS mes,
           COUNT(*)                        AS conversiones,
           SUM(con_valor)                  AS valor_total
    FROM conversion
    GROUP BY DATE_FORMAT(con_fecha, '%Y-%m')
    ORDER BY mes;
END$$

DELIMITER ;

-- ---------------------------------------------------------------------
-- Permiso de ejecucion para el rol de auditoria
-- ---------------------------------------------------------------------
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_conversiones_por_tipo
    TO 'rol_marta';
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_conversiones_por_rango
    TO 'rol_marta';
GRANT EXECUTE ON PROCEDURE `empresa-retail-db`.sp_resumen_conversiones_mensual
    TO 'rol_marta';

FLUSH PRIVILEGES;

