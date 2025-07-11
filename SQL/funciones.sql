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

-- Función para registrar un pago completo venta física, online o evento
CREATE OR REPLACE FUNCTION public.registrar_pago(
    p_monto DECIMAL(12,2),
    p_metodo_pago_id INTEGER,
    p_venta_fisica_id INTEGER DEFAULT NULL,
    p_venta_online_id INTEGER DEFAULT NULL,
    p_venta_evento_id INTEGER DEFAULT NULL,
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
        fk_venta_evento,
        fk_moneda
    ) VALUES (
        p_monto,
        NOW(),
        p_metodo_pago_id,
        p_venta_fisica_id,
        p_venta_online_id,
        p_venta_evento_id,
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
    p_venta_online_id INTEGER DEFAULT NULL,
    p_venta_evento_id INTEGER DEFAULT NULL
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
        p_venta_evento_id,
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

-- ============================================================================
-- FUNCIONES PARA GESTIÓN DE BOLETOS DE EVENTOS
-- ============================================================================

-- Función para calcular boletos vendidos por evento
CREATE OR REPLACE FUNCTION obtener_boletos_vendidos_evento(p_evento_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
    v_boletos_vendidos INTEGER := 0;
BEGIN
    -- Sumar boletos vendidos desde venta_boleto_evento usando el campo de cantidad
    SELECT COALESCE(SUM(ven_bol_eve_cantidad), 0)
    INTO v_boletos_vendidos
    FROM venta_boleto_evento
    WHERE fk_evento = p_evento_id;
    
    RETURN v_boletos_vendidos;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener información completa de disponibilidad de evento
CREATE OR REPLACE FUNCTION obtener_info_disponibilidad_evento(p_evento_id INTEGER)
RETURNS JSON AS $$
DECLARE
    v_evento_record RECORD;
    v_boletos_vendidos INTEGER := 0;
    v_boletos_disponibles INTEGER := 0;
    v_porcentaje_vendido DECIMAL := 0;
    v_result JSON;
BEGIN
    -- Obtener información del evento
    SELECT eve_id, eve_nombre, eve_nro_boletos
    INTO v_evento_record
    FROM evento
    WHERE eve_id = p_evento_id;
    
    -- Si el evento no existe, retornar error
    IF NOT FOUND THEN
        v_result := json_build_object(
            'error', 'Evento no encontrado',
            'evento_id', p_evento_id
        );
        RETURN v_result;
    END IF;
    
    -- Calcular boletos vendidos usando la función actualizada
    v_boletos_vendidos := obtener_boletos_vendidos_evento(p_evento_id);
    
    -- Calcular boletos disponibles
    v_boletos_disponibles := v_evento_record.eve_nro_boletos - v_boletos_vendidos;
    
    -- Calcular porcentaje vendido
    IF v_evento_record.eve_nro_boletos > 0 THEN
        v_porcentaje_vendido := ROUND((v_boletos_vendidos::DECIMAL / v_evento_record.eve_nro_boletos::DECIMAL) * 100, 2);
    END IF;
    
    -- Construir JSON de respuesta
    v_result := json_build_object(
        'evento_id', v_evento_record.eve_id,
        'evento_nombre', v_evento_record.eve_nombre,
        'boletos_totales', v_evento_record.eve_nro_boletos,
        'boletos_vendidos', v_boletos_vendidos,
        'boletos_disponibles', v_boletos_disponibles,
        'porcentaje_vendido', v_porcentaje_vendido,
        'agotado', CASE WHEN v_boletos_disponibles <= 0 THEN true ELSE false END,
        'stock_bajo', CASE WHEN v_boletos_disponibles <= 10 AND v_boletos_disponibles > 0 THEN true ELSE false END
    );
    
    RETURN v_result;
END;
$$ LANGUAGE plpgsql;

-- Función para validar si se puede comprar una cantidad específica de boletos
CREATE OR REPLACE FUNCTION validar_compra_boletos(p_evento_id INTEGER, p_cantidad_solicitada INTEGER)
RETURNS JSON AS $$
DECLARE
    v_info_evento JSON;
    v_boletos_disponibles INTEGER;
    v_result JSON;
BEGIN
    -- Obtener información actual del evento
    v_info_evento := obtener_info_disponibilidad_evento(p_evento_id);
    
    -- Verificar si hay error en la información del evento
    IF v_info_evento->>'error' IS NOT NULL THEN
        RETURN v_info_evento;
    END IF;
    
    -- Extraer boletos disponibles
    v_boletos_disponibles := (v_info_evento->>'boletos_disponibles')::INTEGER;
    
    -- Validar si se pueden comprar los boletos solicitados
    IF p_cantidad_solicitada <= 0 THEN
        v_result := json_build_object(
            'valido', false,
            'mensaje', 'La cantidad debe ser mayor a 0'
        );
    ELSIF p_cantidad_solicitada > v_boletos_disponibles THEN
        v_result := json_build_object(
            'valido', false,
            'mensaje', format('Solo hay %s boletos disponibles. No se pueden comprar %s boletos.', 
                             v_boletos_disponibles, p_cantidad_solicitada),
            'boletos_disponibles', v_boletos_disponibles,
            'cantidad_solicitada', p_cantidad_solicitada
        );
    ELSE
        v_result := json_build_object(
            'valido', true,
            'mensaje', 'Compra válida',
            'boletos_disponibles', v_boletos_disponibles,
            'cantidad_solicitada', p_cantidad_solicitada,
            'boletos_restantes_despues', v_boletos_disponibles - p_cantidad_solicitada
        );
    END IF;
    
    RETURN v_result;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener estadísticas de boletos de todos los eventos
CREATE OR REPLACE FUNCTION obtener_estadisticas_boletos_eventos()
RETURNS JSON AS $$
DECLARE
    v_evento RECORD;
    v_estadisticas JSON[] := ARRAY[]::JSON[];
    v_info_evento JSON;
    v_result JSON;
BEGIN
    -- Iterar por todos los eventos
    FOR v_evento IN 
        SELECT eve_id, eve_nombre, eve_fecha_hora, eve_nro_boletos
        FROM evento 
        ORDER BY eve_fecha_hora DESC
    LOOP
        -- Obtener información de disponibilidad para cada evento
        v_info_evento := obtener_info_disponibilidad_evento(v_evento.eve_id);
        
        -- Agregar información adicional del evento
        v_info_evento := v_info_evento || json_build_object(
            'fecha_hora', v_evento.eve_fecha_hora
        );
        
        -- Agregar a la array de estadísticas
        v_estadisticas := v_estadisticas || v_info_evento;
    END LOOP;
    
    -- Construir resultado final
    v_result := json_build_object(
        'eventos', v_estadisticas,
        'total_eventos', array_length(v_estadisticas, 1)
    );
    
    RETURN v_result;
END;
$$ LANGUAGE plpgsql;

-- Función para actualizar disponibilidad después de una venta
CREATE OR REPLACE FUNCTION procesar_venta_boletos_evento(
    p_evento_id INTEGER,
    p_usuario_id INTEGER,
    p_cantidad_boletos INTEGER DEFAULT 1,
    p_precio_total DECIMAL DEFAULT NULL
)
RETURNS JSON AS $$
DECLARE
    v_validacion JSON;
    v_evento_obj RECORD;
    v_venta_id INTEGER;
    v_precio_boleto DECIMAL;
    v_precio_total DECIMAL;
    v_resultado JSON;
BEGIN
    -- Validar disponibilidad
    v_validacion := validar_compra_boletos(p_evento_id, p_cantidad_boletos);
    
    IF NOT (v_validacion->>'valido')::BOOLEAN THEN
        RETURN json_build_object(
            'exito', false,
            'mensaje', v_validacion->>'mensaje',
            'error_tipo', 'sin_disponibilidad'
        );
    END IF;
    
    -- Obtener información del evento
    SELECT * INTO v_evento_obj FROM evento WHERE eve_id = p_evento_id;
    
    -- Calcular precio si no se proporciona
    IF p_precio_total IS NULL THEN
        v_precio_boleto := COALESCE(v_evento_obj.eve_precio_boleto, 0);
        v_precio_total := v_precio_boleto * p_cantidad_boletos;
    ELSE
        v_precio_total := p_precio_total;
    END IF;
    
    -- Crear venta de boletos
    INSERT INTO venta_boleto_evento (
        ven_bol_eve_fecha_hora,
        ven_bol_eve_monto_total,
        ven_bol_eve_descripcion,
        fk_evento,
        fk_usuario
    ) VALUES (
        NOW(),
        v_precio_total,
        format('Compra de %s boleto(s) para %s', p_cantidad_boletos, v_evento_obj.eve_nombre),
        p_evento_id,
        p_usuario_id
    ) RETURNING ven_bol_eve_id INTO v_venta_id;
    
    -- Actualizar número de boletos disponibles del evento
    UPDATE evento 
    SET eve_nro_boletos = eve_nro_boletos - p_cantidad_boletos
    WHERE eve_id = p_evento_id;
    
    -- Retornar resultado
    v_resultado := json_build_object(
        'exito', true,
        'mensaje', 'Venta procesada exitosamente',
        'venta_id', v_venta_id,
        'cantidad_boletos', p_cantidad_boletos,
        'precio_total', v_precio_total,
        'evento_id', p_evento_id,
        'boletos_restantes', v_evento_obj.eve_nro_boletos - p_cantidad_boletos
    );
    
    RETURN v_resultado;
END;
$$ LANGUAGE plpgsql;