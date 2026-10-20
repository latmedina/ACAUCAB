-- =============================================================================
-- FUNCIONES PARA MANEJO DE MÉTODOS DE PAGO Y PUNTOS
-- =============================================================================

-- Función para registrar un nuevo método de pago
CREATE OR REPLACE FUNCTION public.registrar_metodo_pago(
    p_usuario_id INTEGER,
    p_tipo_pago VARCHAR(50),
    p_tar_deb_numero BIGINT DEFAULT NULL,
    p_tar_deb_vencimiento DATE DEFAULT NULL,
    p_tar_deb_banco VARCHAR(50) DEFAULT NULL,
    p_tar_cre_numero BIGINT DEFAULT NULL,
    p_tar_cre_vencimiento DATE DEFAULT NULL,
    p_efe_denominacion INTEGER DEFAULT NULL,
    p_che_num_cheque VARCHAR(50) DEFAULT NULL,
    p_his_pre_pun_id INTEGER DEFAULT NULL
) RETURNS INTEGER AS $$
DECLARE
    nuevo_metodo_id INTEGER;
BEGIN
    -- Insertar el nuevo método de pago
    INSERT INTO metodo_pago (
        fk_usuario,
        met_pag_tipo_pago,
        tar_deb_numero,
        tar_deb_vencimiento,
        tar_deb_banco,
        tar_cre_numero,
        tar_cre_vencimiento,
        efe_denominacion,
        che_num_cheque,
        fk_his_pre_pun
    ) VALUES (
        p_usuario_id,
        p_tipo_pago,
        p_tar_deb_numero,
        p_tar_deb_vencimiento,
        p_tar_deb_banco,
        p_tar_cre_numero,
        p_tar_cre_vencimiento,
        p_efe_denominacion,
        p_che_num_cheque,
        p_his_pre_pun_id
    ) RETURNING met_pag_id INTO nuevo_metodo_id;
    
    -- Retornar el ID del método creado
    RETURN nuevo_metodo_id;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error al registrar método de pago: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- Función para descontar puntos del cliente
CREATE OR REPLACE FUNCTION public.descontar_puntos_cliente(
    p_usuario_id INTEGER,
    p_puntos_a_descontar INTEGER
) RETURNS RECORD AS $$
DECLARE
    cliente_id INTEGER;
    puntos_actuales INTEGER;
    puntos_restantes INTEGER;
    resultado_final RECORD;
BEGIN
    -- Buscar el cliente asociado al usuario
    SELECT c.cli_id, c.cli_cantidad_puntos INTO cliente_id, puntos_actuales
    FROM usuario u
    INNER JOIN cliente c ON u.fk_cliente = c.cli_id
    WHERE u.id = p_usuario_id;
    
    -- Si no se encuentra cliente por FK directa, buscar por username/CI
    IF NOT FOUND THEN
        SELECT c.cli_id, c.cli_cantidad_puntos INTO cliente_id, puntos_actuales
        FROM usuario u
        INNER JOIN cliente c ON u.username = c.cli_nat_ci
        WHERE u.id = p_usuario_id;
    END IF;
    
    -- Verificar que se encontró el cliente
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Cliente no encontrado para el usuario ID: %', p_usuario_id;
    END IF;
    
    puntos_actuales := COALESCE(puntos_actuales, 0);
    
    -- Verificar que tiene suficientes puntos
    IF puntos_actuales < p_puntos_a_descontar THEN
        RAISE EXCEPTION 'Puntos insuficientes. Disponibles: %, Necesarios: %', 
                       puntos_actuales, p_puntos_a_descontar;
    END IF;
    
    -- Calcular puntos restantes
    puntos_restantes := puntos_actuales - p_puntos_a_descontar;
    
    -- Actualizar la cantidad de puntos del cliente
    UPDATE cliente 
    SET cli_cantidad_puntos = puntos_restantes
    WHERE cli_id = cliente_id;
    
    -- Preparar el resultado final
    SELECT cliente_id as cliente_id,
           puntos_actuales as puntos_anteriores,
           p_puntos_a_descontar as puntos_descontados,
           puntos_restantes as puntos_finales
    INTO resultado_final;
    
    RETURN resultado_final;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error al descontar puntos: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- Función para registrar un pago completo venta física o online
CREATE OR REPLACE FUNCTION public.registrar_pago(
    p_monto DECIMAL(12,2),
    p_metodo_pago_id INTEGER,
    p_venta_fisica_id INTEGER DEFAULT NULL,
    p_venta_online_id INTEGER DEFAULT NULL,
    p_moneda_id INTEGER DEFAULT 1
) RETURNS INTEGER AS $$
DECLARE
    nuevo_pago_id INTEGER;
BEGIN
    -- Insertar el registro de pago
    INSERT INTO pago (
        pag_monto,
        pag_fecha,
        fk_metodo_pago,
        fk_venta_fisica,
        fk_venta_online,
        fk_moneda
    ) VALUES (
        p_monto,
        NOW(),
        p_metodo_pago_id,
        p_venta_fisica_id,
        p_venta_online_id,
        p_moneda_id
    ) RETURNING pag_id INTO nuevo_pago_id;
    
    -- Retornar el ID del pago creado
    RETURN nuevo_pago_id;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error al registrar pago: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener información de puntos del usuario
CREATE OR REPLACE FUNCTION public.obtener_info_puntos_usuario(
    p_usuario_id INTEGER
) RETURNS RECORD AS $$
DECLARE
    info_puntos RECORD;
    cliente_id INTEGER;
    puntos_disponibles INTEGER;
    valor_punto INTEGER;
BEGIN
    -- Buscar el cliente asociado al usuario
    SELECT c.cli_id, c.cli_cantidad_puntos INTO cliente_id, puntos_disponibles
    FROM usuario u
    INNER JOIN cliente c ON u.fk_cliente = c.cli_id
    WHERE u.id = p_usuario_id;
    
    -- Si no se encuentra cliente por FK directa, buscar por username/CI
    IF NOT FOUND THEN
        SELECT c.cli_id, c.cli_cantidad_puntos INTO cliente_id, puntos_disponibles
        FROM usuario u
        INNER JOIN cliente c ON u.username = c.cli_nat_ci
        WHERE u.id = p_usuario_id;
    END IF;
    
    -- Si aún no se encuentra, establecer valores por defecto
    IF NOT FOUND THEN
        cliente_id := NULL;
        puntos_disponibles := 0;
    END IF;
    
    -- Obtener el último valor del punto
    SELECT hpp.his_pre_pun_valor INTO valor_punto
    FROM historico_precio_punto hpp
    ORDER BY hpp.his_pre_pun_fecha_hora DESC
    LIMIT 1;
    
    -- Si no hay valor del punto, establecer por defecto
    IF NOT FOUND THEN
        valor_punto := 1000; -- Valor por defecto
    END IF;
    
    -- Preparar el resultado
    SELECT cliente_id as cliente_id,
           COALESCE(puntos_disponibles, 0) as puntos_disponibles,
           valor_punto as valor_punto
    INTO info_puntos;
    
    RETURN info_puntos;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error al obtener información de puntos: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- Función para procesar pago con puntos (transacción completa)
CREATE OR REPLACE FUNCTION public.procesar_pago_puntos(
    p_usuario_id INTEGER,
    p_puntos_necesarios INTEGER,
    p_venta_fisica_id INTEGER DEFAULT NULL,
    p_venta_online_id INTEGER DEFAULT NULL
) RETURNS RECORD AS $$
DECLARE
    resultado RECORD;
    metodo_pago_id INTEGER;
    pago_id INTEGER;
    monto_pago DECIMAL(12,2);
    ultimo_precio_punto_id INTEGER;
    valor_punto INTEGER;
    cliente_id_resultado INTEGER;
    puntos_anteriores_resultado INTEGER;
    puntos_descontados_resultado INTEGER;
    puntos_finales_resultado INTEGER;
    moneda_bolivares_id INTEGER := 1; -- Asumiendo que ID 1 es bolívares
BEGIN
    -- Obtener el último precio del punto
    SELECT hpp.his_pre_pun_id, hpp.his_pre_pun_valor 
    INTO ultimo_precio_punto_id, valor_punto
    FROM historico_precio_punto hpp
    ORDER BY hpp.his_pre_pun_fecha_hora DESC
    LIMIT 1;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'No hay precio de puntos configurado';
    END IF;
    
    -- Calcular el monto del pago
    monto_pago := p_puntos_necesarios * valor_punto;
    
    -- Descontar puntos del cliente
    SELECT cliente_id, puntos_anteriores, puntos_descontados, puntos_finales
    INTO cliente_id_resultado, puntos_anteriores_resultado, puntos_descontados_resultado, puntos_finales_resultado
    FROM descontar_puntos_cliente(p_usuario_id, p_puntos_necesarios) 
    AS (cliente_id INTEGER, puntos_anteriores INTEGER, puntos_descontados INTEGER, puntos_finales INTEGER);
    
    -- Crear método de pago con puntos
    SELECT registrar_metodo_pago(
        p_usuario_id,
        'puntos',
        NULL, NULL, NULL, NULL, NULL, NULL, NULL,
        ultimo_precio_punto_id
    ) INTO metodo_pago_id;
    
    -- Registrar el pago
    SELECT registrar_pago(
        monto_pago,
        metodo_pago_id,
        p_venta_fisica_id,
        p_venta_online_id,
        moneda_bolivares_id
    ) INTO pago_id;
    
    -- Preparar resultado
    SELECT pago_id as pago_id,
           metodo_pago_id as metodo_pago_id,
           p_puntos_necesarios as puntos_utilizados,
           puntos_finales_resultado as puntos_restantes,
           monto_pago as monto_pago
    INTO resultado;
    
    RETURN resultado;
    
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error al procesar pago con puntos: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_historial_compras_cliente(p_cliente_id INTEGER)
RETURNS JSON AS $$
DECLARE
    resultado JSON;
BEGIN
    SELECT json_agg(h.* ORDER BY h.fecha DESC) INTO resultado
    FROM (
        -- Ventas físicas
        SELECT 
            'Venta Física' AS tipo,
            vf.ven_fis_fecha AS fecha,
            vf.ven_fis_total AS monto,
            CONCAT('Compra en tienda física - #', vf.ven_fis_id) AS descripcion,
            vf.ven_fis_id AS venta_id,
            'fisica' AS tipo_url
        FROM venta_fisica vf
        WHERE vf.fk_cliente = p_cliente_id

        UNION ALL

        -- Ventas online
        SELECT 
            'Venta Online' AS tipo,
            vo.ven_onl_fecha AS fecha,
            vo.ven_onl_total AS monto,
            CONCAT('Compra en tienda online - #', vo.ven_onl_id) AS descripcion,
            vo.ven_onl_id AS venta_id,
            'online' AS tipo_url
        FROM venta_online vo
        WHERE vo.fk_usuario IN (
            SELECT id FROM usuario WHERE fk_cliente = p_cliente_id
        )

        UNION ALL

        -- Ventas de eventos
        SELECT 
            'Evento' AS tipo,
            vbe.ven_bol_eve_fecha_hora AS fecha,
            vbe.ven_bol_eve_monto_total AS monto,
            vbe.ven_bol_eve_descripcion AS descripcion,
            vbe.ven_bol_eve_id AS venta_id,
            'evento' AS tipo_url
        FROM venta_boleto_evento vbe
        WHERE vbe.fk_usuario IN (
            SELECT id FROM usuario WHERE fk_cliente = p_cliente_id
        )
    ) h;

    RETURN resultado;
END;
$$ LANGUAGE plpgsql;
