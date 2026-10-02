-- =====================================================================
-- 05_verificacion.sql
-- Verificacion de permisos. Parte A la ejecuta el administrador (root);
-- la parte B se ejecuta iniciando sesion con cada usuario.
-- =====================================================================

-- ---------------------------------------------------------------------
-- PARTE A (como root): revisar los privilegios concedidos
-- ---------------------------------------------------------------------
SHOW GRANTS FOR 'rol_ana';
SHOW GRANTS FOR 'rol_pedro';
SHOW GRANTS FOR 'rol_marta';

SHOW GRANTS FOR 'ana_crm'@'localhost'         USING 'rol_ana';
SHOW GRANTS FOR 'pedro_mkt'@'localhost'       USING 'rol_pedro';
SHOW GRANTS FOR 'marta_auditoria'@'localhost' USING 'rol_marta';

-- ---------------------------------------------------------------------
-- PARTE B: pruebas funcionales
-- Resultado esperado indicado en cada caso.
-- ---------------------------------------------------------------------

-- ===== Sesion: mysql -u ana_crm -p =====
-- USE `empresa-retail-db`;
-- SELECT * FROM cliente;                                         -- OK
-- UPDATE cliente SET cli_ciudad='Cali' WHERE cli_id_cliente=1;   -- OK
-- INSERT INTO interaccion (int_tipo,int_fecha,campania_cam_id_campania,cliente_cli_id_cliente)
--        VALUES ('clic','2026-10-01',1,1);                       -- OK
-- SELECT * FROM campania;                                        -- ERROR 1142 (sin permiso)
-- DELETE FROM cliente WHERE cli_id_cliente=1;                    -- ERROR 1142 (sin DELETE)

-- ===== Sesion: mysql -u pedro_mkt -p =====
-- USE `empresa-retail-db`;
-- SELECT * FROM cliente;                                         -- OK (solo lectura)
-- UPDATE cliente SET cli_ciudad='Cali' WHERE cli_id_cliente=1;   -- ERROR 1142
-- INSERT INTO campania (cam_nombre,cam_presupuesto,cam_fecha_inicio,cam_fecha_final,canal_can_id_canal)
--        VALUES ('Prueba',100000,'2026-10-01','2026-10-31',1);   -- OK
-- UPDATE canal SET can_nombre='Instagram Ads' WHERE can_id_canal=1; -- OK
-- SELECT * FROM conversion;                                      -- ERROR 1142

-- ===== Sesion: mysql -u marta_auditoria -p =====
-- USE `empresa-retail-db`;
-- SELECT * FROM conversion;                                      -- OK
-- CALL sp_conversiones_por_tipo();                               -- OK
-- CALL sp_conversiones_por_rango('2026-01-01','2026-12-31');     -- OK
-- CALL sp_resumen_conversiones_mensual();                        -- OK
-- SELECT * FROM cliente;                                         -- ERROR 1142
-- INSERT INTO conversion (con_tipo,con_valor,con_fecha,cliente_cli_id_cliente)
--        VALUES ('compra',1000,'2026-10-01',1);                  -- ERROR 1142
