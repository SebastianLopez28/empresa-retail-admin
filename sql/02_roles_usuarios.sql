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
