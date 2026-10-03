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
-- Datos de prueba (sector agropecuario)
-- 4 canales, 29 campanias, 25 clientes, 24 interacciones, 13 conversiones.
-- El orden respeta las llaves foraneas: canal, campania, cliente,
-- interaccion y conversion.
-- ---------------------------------------------------------------------
-- TABLA CANAL
INSERT INTO canal (can_nombre, can_tipo) VALUES 
('Facebook Ads', 'Red Social'),
('WhatsApp Business', 'Buscador'),
('Email Marketing', 'Email'),
('Valla', 'Buscador');

-- TABLA CAMPAÑAS
INSERT INTO campania (cam_nombre, cam_presupuesto, cam_fecha_inicio, cam_fecha_final, canal_can_id_canal) VALUES 
('Remate de Novillos 2026', 250000, '2026-01-15', '2026-02-15', 1),
('Promoción Inseminación Artificial', 1200000, '2026-02-01', '2026-03-30', 2),
('Boletín Técnico Agro', 450000, '2026-01-01', '2026-12-31', 3),
('Lanzamiento Potrero Sur', 800000, '2026-03-01', '2026-04-15', 4), 
('Subasta Elite Cauca', 450000, '2026-04-10', '2026-04-20', 1),
('Plan Vacunación Aftosa Ciclo I', 300000, '2026-05-01', '2026-06-15', 3),
('Descuento Fertilizantes Mayo', 120000, '2026-05-10', '2026-05-30', 2),
('Seminario Ganadería Sostenible', 850000, '2026-06-05', '2026-06-06', 1),
('Promo Inseminación Holstein', 2100000, '2026-06-15', '2026-07-15', 2),
('Venta Terneros de Levante', 3500000, '2026-07-01', '2026-08-01', 4),
('Día de Campo - Hacienda La Paz', 60000, '2026-07-20', '2026-07-21', 2),
('Oferta Silo de Maíz Premium', 180000, '2026-08-05', '2026-09-05', 1),
('Equipos de Ordeño Alfa', 5000000, '2026-08-15', '2026-09-30', 3),
('Genética Angus de Exportación', 750000, '2026-09-01', '2026-10-15', 1),
('Cursos Manejo de Pasturas', 400000, '2026-09-10', '2026-09-25', 3),
('Gran Remate de Estrellas', 1000000, '2026-10-01', '2026-10-10', 4),
('ExpoCebú 2026 - Stand Principal', 650000, '2026-11-15', '2026-11-25', 1),
('Alimento Balanceado Invierno', 280000, '2026-11-01', '2026-12-15', 2),
('Software de Gestión Agro 360', 150000, '2026-01-10', '2026-03-10', 3),
('Créditos Línea Blanca Agro', 900000, '2026-02-15', '2026-04-15', 2),
('Taurinas de Media Montaña', 320000, '2026-03-20', '2026-05-20', 4),
('Sal Mineralizada Plus', 110000, '2026-04-01', '2026-04-30', 1),
('Ruedas de Negocio Regional', 200000, '2026-05-15', '2026-05-17', 2),
('Festival del Queso y Leche', 130000, '2026-06-10', '2026-06-12', 3),
('Trazabilidad Animal 360', 700000, '2026-07-15', '2026-08-15', 1),
('Implementos para Cerca Eléctrica', 2400000, '2026-08-20', '2026-09-20', 4),
('Subasta Online Novillas', 4800000, '2026-09-15', '2026-09-16', 1),
('Renovación de Praderas', 160000, '2026-10-10', '2026-11-10', 2),
('Gran Cierre de Año Ganadero', 900000, '2026-12-01', '2026-12-31', 1);

-- TABLA CLIENTES
INSERT INTO cliente (cli_nombre, cli_apellido, cli_correo, cli_telefono, cli_ciudad, cli_fecha_registro) VALUES 
('Roberto', 'Sánchez', 'roberto.s@ganadero.com', '3157778899', 'Popayán', '2026-01-20'),
('Elena', 'Restrepo', 'elena_agro@hacienda.co', '3104445566', 'Medellín', '2026-02-05'),
('Marco', 'Tulio', 'marcot@veterinaria.net', '3002223344', 'Cali', '2026-02-18'),
('Patricia', 'Duarte', 'p.duarte@finca.com', '3128889900', 'Buga', '2026-03-01'),
('Ganadería San José', 'LTDA', 'gerencia@sanjose.com', '6015554433', 'Bogotá', '2026-03-05'), 
('Andrés', 'García', 'andres.garcia@ganado.co', '3109988771', 'Montería', '2026-01-05'),
('Marta', 'Lucía', 'mlucia@hacienda.com', '3152233445', 'Pereira', '2026-01-12'),
('Javier', 'Hernández', 'j.hernandez@finca.net', '3201122334', 'Villavicencio', '2026-01-18'),
('Isabel', 'Castaño', 'isabel.c@agro.com', '3115566778', 'Manizales', '2026-01-22'),
('Ricardo', 'Pérez', 'ricardo.p@lecheria.co', '3189900112', 'Sonsón', '2026-01-28'),
('Sofía', 'Ramírez', 'sofia_r@export.com', '3143344556', 'Barranquilla', '2026-02-01'),
('Fernando', 'Torres', 'f.torres@carne.net', '3006677889', 'Bucaramanga', '2026-02-03'),
('Gloria', 'Valencia', 'gvalencia@campo.org', '3124455667', 'Armenia', '2026-02-07'),
('Diego', 'Mejía', 'diego.mejia@progan.co', '3178899001', 'Sincelejo', '2026-02-10'),
('Adriana', 'Orozco', 'a.orozco@tierras.com', '3102233445', 'Espinal', '2026-02-14'),
('Luis', 'Bernal', 'lbernal@veterinaria.co', '3156677889', 'Duitama', '2026-02-16'),
('Paola', 'Guzmán', 'paola.g@feria.net', '3113344556', 'Pasto', '2026-02-20'),
('Oscar', 'Muñoz', 'omunoz@agroz.com', '3215566778', 'Tuluá', '2026-02-22'),
('Beatriz', 'López', 'b.lopez@pasto.co', '3139900112', 'Yopal', '2026-02-25'),
('Gabriel', 'Ruiz', 'gruiz@ganaderia.co', '3162233445', 'Florencia', '2026-02-28'),
('Camila', 'Vargas', 'cvargas@bio.com', '3196677889', 'Neiva', '2026-03-02'),
('Héctor', 'Salazar', 'hsalazar@campo.net', '3103344556', 'Fusagasugá', '2026-03-04'),
('Tatiana', 'Suárez', 't.suarez@semillas.co', '3155566778', 'Ibagué', '2026-03-06'),
('Juan', 'Quintero', 'jquintero@fincas.com', '3128899001', 'Cartago', '2026-03-08'),
('Mónica', 'Ríos', 'mrios@agronegocios.co', '3142233445', 'Valledupar', '2026-03-09');

-- TABLA INTERACCIONES
INSERT INTO interaccion (int_tipo, int_fecha, campania_cam_id_campania, cliente_cli_id_cliente) VALUES 
('clic', '2026-01-25', 1, 1), -- Roberto vio el Remate en FB
('comentario', '2026-02-10', 2, 2), -- Elena preguntó por WhatsApp
('descarga', '2026-02-20', 3, 3), -- Marco leyó el boletín
('visita', '2026-03-02', 4, 4), 
('clic', '2026-04-12', 5, 6),   -- Andrés interactúa con Subasta Elite
('comentario', '2026-05-15', 7, 7),   -- Marta pregunta por fertilizantes
('descarga', '2026-06-05', 8, 8),   -- Javier llama por el seminario
('clic', '2026-01-20', 3, 9),     -- Isabel abre el boletín técnico
('comentario', '2026-04-15', 5, 10),   -- Ricardo comenta en la Subasta
('visita', '2026-11-20', 17, 11),   -- Sofía visita en ExpoCebú
('descarga', '2026-09-12', 15, 12), -- Fernando descarga info de genética
('clic', '2026-08-10', 12, 13), -- Gloria ve oferta de Silo
('comentario', '2026-02-15', 2, 14),   -- Diego pregunta por inseminación
('descarga', '2026-07-20', 11, 15), -- Adriana consulta por levante
('clic', '2026-10-02', 16, 16),  -- Luis ve equipos de ordeño
('comentario', '2026-05-12', 7, 17),       -- Paola se registra para fertilizantes
('clic', '2026-03-05', 19, 18),    -- Oscar abre correo de software agro
('comentario', '2026-09-20', 14, 19),  -- Beatriz pregunta por genética Angus
('descarga', '2026-12-05', 29, 20),  -- Gabriel llama por el cierre de año
('visita', '2026-03-15', 4, 21), -- Camila reacciona a valla/lanzamiento
('clic', '2026-06-25', 9, 22),   -- Héctor ve equipos Alfa
('descarga', '2026-08-05', 12, 23),  -- Tatiana descarga guía de pasturas
('comentario', '2026-01-28', 1, 24),   -- Juan pregunta por remate de novillos
('clic', '2026-09-15', 15, 25);    -- Mónica ve genética de exportación

-- TABLA CONVERSIONES
INSERT INTO conversion (con_tipo, con_valor, con_fecha, cliente_cli_id_cliente) VALUES 
('compra', 1550000, '2026-02-12', 1), -- Roberto compró tras ver FB
('registro', 120000, '2026-02-25', 2), -- Elena reservó tras WhatsApp
('suscripcion', 35000, '2026-03-05', 5),
('registro', 1250000, '2026-04-18', 6),   -- Andrés compró tras la Subasta Elite
('compra', 240000, '2026-05-20', 7),  -- Marta cerró tras preguntar por WhatsApp
('suscripcion', 150000, '2026-06-05', 8),   -- Javier pagó su cupo al seminario
('suscripcion', 45000, '2026-03-10', 18), -- Oscar adquirió el software agro
('compra', 320000, '2026-02-25', 14), -- Diego contrató tras el mensaje de WhatsApp
('registro', 890000, '2026-07-28', 15), -- Adriana compró el lote de levante
('compra', 1570000, '2026-10-15', 16), -- Luis compró los equipos de ordeño
('compra', 580000, '2026-09-25', 19), -- Beatriz invirtió en genética premium
('compra', 110000, '2026-08-15', 13),     -- Gloria compró el alimento para su ganado
('suscripcion', 120000, '2026-01-25', 9);    -- Isabel se volvió cliente premium del boletín

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

