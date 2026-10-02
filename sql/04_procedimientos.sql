-- =====================================================================
-- 04_procedimientos.sql
-- Procedimientos almacenados de CONSULTA para el rol de auditoria.
-- SQL SECURITY DEFINER: el procedimiento se ejecuta con los permisos de
-- quien lo crea, por lo que marta solo necesita EXECUTE.
-- =====================================================================

USE empresa_retail;

DROP PROCEDURE IF EXISTS sp_conversiones_por_tipo;
DROP PROCEDURE IF EXISTS sp_conversiones_por_rango;
DROP PROCEDURE IF EXISTS sp_resumen_conversiones_campana;

DELIMITER $$

-- Total y cantidad de conversiones agrupadas por tipo
CREATE PROCEDURE sp_conversiones_por_tipo()
    SQL SECURITY DEFINER
    READS SQL DATA
BEGIN
    SELECT tipo,
           COUNT(*)   AS cantidad,
           SUM(valor) AS valor_total
    FROM Conversiones
    GROUP BY tipo
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
    SELECT id_conversion, id_cliente, id_campana, tipo, valor, fecha
    FROM Conversiones
    WHERE fecha BETWEEN p_desde AND p_hasta
    ORDER BY fecha;
END$$

-- Resumen de conversiones por campana
CREATE PROCEDURE sp_resumen_conversiones_campana()
    SQL SECURITY DEFINER
    READS SQL DATA
BEGIN
    SELECT c.id_campana,
           c.nombre       AS campana,
           COUNT(v.id_conversion) AS conversiones,
           COALESCE(SUM(v.valor), 0) AS valor_total
    FROM Campanas c
    LEFT JOIN Conversiones v ON v.id_campana = c.id_campana
    GROUP BY c.id_campana, c.nombre
    ORDER BY valor_total DESC;
END$$

DELIMITER ;

-- ---------------------------------------------------------------------
-- Permiso de ejecucion para el rol de auditoria
-- ---------------------------------------------------------------------
GRANT EXECUTE ON PROCEDURE empresa_retail.sp_conversiones_por_tipo
    TO 'rol_marta';
GRANT EXECUTE ON PROCEDURE empresa_retail.sp_conversiones_por_rango
    TO 'rol_marta';
GRANT EXECUTE ON PROCEDURE empresa_retail.sp_resumen_conversiones_campana
    TO 'rol_marta';

FLUSH PRIVILEGES;
