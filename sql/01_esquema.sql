-- =====================================================================
-- 01_esquema.sql
-- Base de datos: empresa_retail
-- Motor: MySQL 8.0+
-- =====================================================================

DROP DATABASE IF EXISTS empresa_retail;
CREATE DATABASE empresa_retail
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE empresa_retail;

-- ---------------------------------------------------------------------
-- Clientes
-- ---------------------------------------------------------------------
CREATE TABLE Clientes (
    id_cliente      INT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL,
    apellido        VARCHAR(100) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    telefono        VARCHAR(30),
    ciudad          VARCHAR(80),
    fecha_registro  DATE NOT NULL DEFAULT (CURRENT_DATE)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Canales (web, tienda fisica, redes sociales, correo, etc.)
-- ---------------------------------------------------------------------
CREATE TABLE Canales (
    id_canal    INT AUTO_INCREMENT PRIMARY KEY,
    nombre      VARCHAR(80) NOT NULL UNIQUE,
    tipo        ENUM('digital','fisico') NOT NULL,
    activo      TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Campanas
-- ---------------------------------------------------------------------
CREATE TABLE Campanas (
    id_campana      INT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(120) NOT NULL,
    id_canal        INT NOT NULL,
    fecha_inicio    DATE NOT NULL,
    fecha_fin       DATE,
    presupuesto     DECIMAL(12,2) NOT NULL DEFAULT 0,
    CONSTRAINT fk_campana_canal
        FOREIGN KEY (id_canal) REFERENCES Canales (id_canal)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Interacciones (contactos entre la empresa y el cliente)
-- ---------------------------------------------------------------------
CREATE TABLE Interacciones (
    id_interaccion  INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente      INT NOT NULL,
    id_canal        INT NOT NULL,
    fecha_hora      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo            ENUM('consulta','reclamo','venta','seguimiento') NOT NULL,
    detalle         VARCHAR(255),
    CONSTRAINT fk_inter_cliente
        FOREIGN KEY (id_cliente) REFERENCES Clientes (id_cliente),
    CONSTRAINT fk_inter_canal
        FOREIGN KEY (id_canal) REFERENCES Canales (id_canal)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Conversiones (compra, registro, suscripcion)
-- ---------------------------------------------------------------------
CREATE TABLE Conversiones (
    id_conversion   INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente      INT NOT NULL,
    id_campana      INT NOT NULL,
    tipo            ENUM('compra','registro','suscripcion') NOT NULL,
    valor           DECIMAL(12,2) NOT NULL DEFAULT 0,
    fecha           DATE NOT NULL,
    CONSTRAINT fk_conv_cliente
        FOREIGN KEY (id_cliente) REFERENCES Clientes (id_cliente),
    CONSTRAINT fk_conv_campana
        FOREIGN KEY (id_campana) REFERENCES Campanas (id_campana)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Datos de ejemplo
-- ---------------------------------------------------------------------
INSERT INTO Clientes (nombre, apellido, email, telefono, ciudad, fecha_registro) VALUES
('Laura',  'Gomez',    'laura.gomez@correo.com',   '3001112233', 'Popayan', '2026-01-15'),
('Carlos', 'Rivera',   'carlos.rivera@correo.com', '3004445566', 'Cali',    '2026-02-03'),
('Sofia',  'Mendoza',  'sofia.mendoza@correo.com', '3007778899', 'Bogota',  '2026-03-20'),
('Andres', 'Torres',   'andres.torres@correo.com', '3010001122', 'Medellin','2026-04-11');

INSERT INTO Canales (nombre, tipo) VALUES
('Sitio web',       'digital'),
('Redes sociales',  'digital'),
('Correo masivo',   'digital'),
('Tienda fisica',   'fisico');

INSERT INTO Campanas (nombre, id_canal, fecha_inicio, fecha_fin, presupuesto) VALUES
('Lanzamiento primavera', 1, '2026-03-01', '2026-03-31', 5000000.00),
('Descuento de temporada', 2, '2026-06-01', '2026-06-30', 3200000.00),
('Fidelizacion clientes',  3, '2026-08-01', NULL,         1800000.00);

INSERT INTO Interacciones (id_cliente, id_canal, tipo, detalle) VALUES
(1, 1, 'consulta',    'Pregunta por disponibilidad de producto'),
(2, 4, 'venta',       'Compra en tienda'),
(3, 2, 'seguimiento', 'Respuesta a mensaje directo'),
(4, 3, 'reclamo',     'Reclamo por demora en entrega');

INSERT INTO Conversiones (id_cliente, id_campana, tipo, valor, fecha) VALUES
(1, 1, 'registro',    0.00,      '2026-03-05'),
(2, 1, 'compra',      280000.00, '2026-03-12'),
(3, 2, 'compra',      150000.00, '2026-06-10'),
(4, 3, 'suscripcion', 30000.00,  '2026-08-15'),
(1, 2, 'compra',      95000.00,  '2026-06-18');
