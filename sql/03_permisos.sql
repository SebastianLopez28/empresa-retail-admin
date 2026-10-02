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
