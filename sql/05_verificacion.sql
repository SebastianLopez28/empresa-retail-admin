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
-- USE empresa_retail;
-- SELECT * FROM Clientes;                                  -- OK
-- UPDATE Clientes SET ciudad='Cali' WHERE id_cliente=1;    -- OK
-- INSERT INTO Interacciones (id_cliente,id_canal,tipo,detalle)
--        VALUES (1,1,'consulta','Prueba');                 -- OK
-- SELECT * FROM Campanas;                                  -- ERROR 1142 (sin permiso)
-- DELETE FROM Clientes WHERE id_cliente=1;                 -- ERROR 1142 (sin DELETE)

-- ===== Sesion: mysql -u pedro_mkt -p =====
-- USE empresa_retail;
-- SELECT * FROM Clientes;                                  -- OK (solo lectura)
-- UPDATE Clientes SET ciudad='Cali' WHERE id_cliente=1;    -- ERROR 1142
-- INSERT INTO Campanas (nombre,id_canal,fecha_inicio,presupuesto)
--        VALUES ('Prueba',1,'2026-10-01',100000);          -- OK
-- UPDATE Canales SET activo=0 WHERE id_canal=4;            -- OK
-- SELECT * FROM Conversiones;                              -- ERROR 1142

-- ===== Sesion: mysql -u marta_auditoria -p =====
-- USE empresa_retail;
-- SELECT * FROM Conversiones;                              -- OK
-- CALL sp_conversiones_por_tipo();                         -- OK
-- CALL sp_conversiones_por_rango('2026-01-01','2026-12-31'); -- OK
-- CALL sp_resumen_conversiones_campana();                  -- OK
-- SELECT * FROM Clientes;                                  -- ERROR 1142
-- INSERT INTO Conversiones (id_cliente,id_campana,tipo,valor,fecha)
--        VALUES (1,1,'compra',1000,'2026-10-01');          -- ERROR 1142
