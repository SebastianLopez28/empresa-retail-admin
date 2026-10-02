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
