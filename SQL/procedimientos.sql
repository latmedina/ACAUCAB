-- ===========================================
-- PROCEDIMIENTOS SQL PARA EL SISTEMA
-- Incluye funciones para registrar usuarios y ventas físicas
-- ===========================================

-- ===========================================
-- FUNCION: registrar_venta_fisica
-- ===========================================

CREATE OR REPLACE FUNCTION public.registrar_venta_fisica(
    cliente_id INTEGER,
    tienda_id INTEGER,
    total NUMERIC
) RETURNS INTEGER AS $$
DECLARE
    nueva_venta_id INTEGER;
BEGIN
    INSERT INTO venta_fisica (ven_fis_fecha, ven_fis_total, fk_cliente, fk_tienda)
    VALUES (CURRENT_DATE, total, cliente_id, tienda_id)
    RETURNING ven_fis_id INTO nueva_venta_id;

    RETURN nueva_venta_id;
END;
$$ LANGUAGE plpgsql;

-- ===========================================
-- FUNCION: registrar_usuario
-- ===========================================

CREATE OR REPLACE FUNCTION public.registrar_usuario(
    p_username TEXT,
    p_email TEXT,
    p_password TEXT,
    p_tipo TEXT,
    p_id_entidad INTEGER,
    p_emp_car_id INTEGER,
    p_first_name TEXT,
    p_last_name TEXT
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO usuario (
        username,
        email,
        password,
        is_active,
        is_staff,
        is_superuser,
        date_joined,
        fk_cliente,
        fk_proveedor,
        fk_emp_car,
        first_name,
        last_name
    )
    VALUES (
        p_username,
        p_email,
        p_password,
        TRUE, FALSE, FALSE, NOW(),
        CASE WHEN p_tipo = 'cliente' THEN p_id_entidad ELSE NULL END,
        CASE WHEN p_tipo = 'proveedor' THEN p_id_entidad ELSE NULL END,
        CASE WHEN p_tipo = 'empleado' THEN p_emp_car_id ELSE NULL END,
        p_first_name,
        p_last_name
    );
END;
$$ LANGUAGE plpgsql;

-- Factura que maneja tanto ventas físicas como online con tipo específico
CREATE OR REPLACE FUNCTION public.obtener_datos_reporte_venta(p_venta_id INT, p_tipo_venta TEXT DEFAULT NULL)
RETURNS JSON AS $$
DECLARE
    v_reporte_data JSON;
BEGIN
    -- Si no se especifica tipo, intentar detectar automáticamente (backward compatibility)
    IF p_tipo_venta IS NULL THEN
        -- Verificar primero si existe como venta física
        IF EXISTS(SELECT 1 FROM public.venta_fisica WHERE ven_fis_id = p_venta_id) THEN
            p_tipo_venta := 'fisica';
        ELSIF EXISTS(SELECT 1 FROM public.venta_online WHERE ven_onl_id = p_venta_id) THEN
            p_tipo_venta := 'online';
        ELSE
            -- Venta no encontrada
            RETURN NULL;
        END IF;
    END IF;
    
    -- Procesar según el tipo de venta especificado
    IF p_tipo_venta = 'fisica' THEN
        -- VENTA FÍSICA
        SELECT
            json_build_object(
                -- Sección 'venta': contiene datos generales y totales de la factura
                'venta', json_build_object(
                    'id', vf.ven_fis_id,
                    'fecha', TO_CHAR(vf.ven_fis_fecha, 'DD/MM/YYYY'),
                    'tipo_venta', 'Venta Física',
                    'subtotal', vf.ven_fis_total / 1.16, -- Calcula la base imponible (asumiendo IVA 16%)
                    'iva', vf.ven_fis_total - (vf.ven_fis_total / 1.16), -- Calcula el monto del IVA
                    'total', vf.ven_fis_total
                ),
                -- Sección 'cliente': información del cliente que realizó la compra
                'cliente', json_build_object(
                    'nombre', COALESCE(c.cli_nat_pnombre || ' ' || c.cli_nat_papellido, c.cli_jur_razon_social, 'No disponible'),
                    'rif', COALESCE(c.cli_rif, 'N/A'),
                    'direccion', COALESCE(c.cli_direccion_fisica, 'N/A'),
                    'telefono', (SELECT tel_numero::text FROM public.telefono WHERE fk_cliente = c.cli_id LIMIT 1)
                ),
                -- Sección 'tienda': datos de la tienda donde se realizó la venta
                'tienda', json_build_object(
                    'nombre', COALESCE(t.tie_nombre, 'No disponible'),
                    'direccion', COALESCE(t.tie_direccion, 'N/A')
                ),
                -- Sección 'detalles': productos vendidos (desde inventario físico)
                'detalles', (
                    SELECT COALESCE(json_agg(
                        json_build_object(
                            'id', p.prese_id,
                            'producto', p.prese_nombre,
                            'cantidad', dvf.det_ven_fis_cantidad,
                            'precio_unitario', dvf.det_ven_fis_precio_unitario,
                            'total_linea', dvf.det_ven_fis_cantidad * dvf.det_ven_fis_precio_unitario
                        )
                    ), '[]'::json)
                    FROM public.detalle_venta_fisica dvf
                    JOIN public.inventario i ON dvf.fk_inventario = i.inv_id
                    JOIN public.presentacion p ON i.fk_presentacion = p.prese_id
                    WHERE dvf.fk_venta_fisica = vf.ven_fis_id
                )
            )
        INTO v_reporte_data
        FROM public.venta_fisica vf
        LEFT JOIN public.cliente c ON vf.fk_cliente = c.cli_id
        LEFT JOIN public.tienda t ON vf.fk_tienda = t.tie_id
        WHERE vf.ven_fis_id = p_venta_id;
        
    ELSIF p_tipo_venta = 'online' THEN
        -- VENTA ONLINE
        SELECT
            json_build_object(
                -- Sección 'venta': contiene datos generales y totales de la factura
                'venta', json_build_object(
                    'id', vo.ven_onl_id,
                    'fecha', TO_CHAR(vo.ven_onl_fecha, 'DD/MM/YYYY'),
                    'tipo_venta', 'Venta Online',
                    'subtotal', vo.ven_onl_total / 1.16, -- Calcula la base imponible (asumiendo IVA 16%)
                    'iva', vo.ven_onl_total - (vo.ven_onl_total / 1.16), -- Calcula el monto del IVA
                    'total', vo.ven_onl_total
                ),
                -- Sección 'cliente': información del cliente (a través del usuario)
                'cliente', json_build_object(
                    'nombre', COALESCE(c.cli_nat_pnombre || ' ' || c.cli_nat_papellido, c.cli_jur_razon_social, 'No disponible'),
                    'rif', COALESCE(c.cli_rif, 'N/A'),
                    'direccion', COALESCE(c.cli_direccion_fisica, 'N/A'),
                    'telefono', (SELECT tel_numero::text FROM public.telefono WHERE fk_cliente = c.cli_id LIMIT 1)
                ),
                -- Sección 'tienda': datos de la tienda donde se realizó la venta
                'tienda', json_build_object(
                    'nombre', COALESCE(t.tie_nombre, 'No disponible'),
                    'direccion', COALESCE(t.tie_direccion, 'N/A')
                ),
                -- Sección 'detalles': productos vendidos (desde pre_alm - tienda online)
                'detalles', (
                    SELECT COALESCE(json_agg(
                        json_build_object(
                            'id', p.prese_id,
                            'producto', p.prese_nombre,
                            'cantidad', dvo.det_ven_onl_cantidad,
                            'precio_unitario', dvo.det_ven_onl_precio,
                            'total_linea', dvo.det_ven_onl_cantidad * dvo.det_ven_onl_precio
                        )
                    ), '[]'::json)
                    FROM public.detalle_venta_online dvo
                    JOIN public.pre_alm pa ON dvo.fk_pre_alm = pa.pre_alm_id
                    JOIN public.presentacion p ON pa.fk_presentacion = p.prese_id
                    WHERE dvo.fk_venta_online = vo.ven_onl_id
                )
            )
        INTO v_reporte_data
        FROM public.venta_online vo
        LEFT JOIN public.usuario u ON vo.fk_usuario = u.id
        LEFT JOIN public.cliente c ON u.fk_cliente = c.cli_id
        LEFT JOIN public.tienda t ON vo.fk_tienda = t.tie_id
        WHERE vo.ven_onl_id = p_venta_id;
        
    ELSE
        -- Tipo de venta no válido
        v_reporte_data := NULL;
    END IF;

    RETURN v_reporte_data;
END;
$$ LANGUAGE plpgsql;

-- orden de compra
CREATE OR REPLACE FUNCTION public.obtener_datos_orden_compra(p_solicitud_id INT)
RETURNS JSON AS $$
DECLARE
    v_reporte_data JSON;
BEGIN
    SELECT
        json_build_object(
            'orden_info', json_build_object(
                'id', sc.sol_com_id,
                'fecha', TO_CHAR(sc.sol_com_fecha, 'DD/MM/YYYY')
            ),
            'proveedor_info', json_build_object(
                'nombre', COALESCE(p.pro_razon_social, 'N/A'),
                'telefono', (SELECT tel_numero::text FROM public.telefono WHERE fk_proveedor = p.pro_id LIMIT 1),
                'direccion', COALESCE(p.pro_direccion_fiscal, 'N/A')
            ),
            'enviar_a_info', json_build_object(
                'local', COALESCE(t.tie_nombre, 'Almacén Principal'),
                'telefono', '0412-1234567', -- Teléfono de la empresa (puede ser dinámico si lo tienes en la tabla tienda)
                'direccion', COALESCE(t.tie_direccion, 'Dirección de la empresa')
            ),
            'detalles', (
                SELECT COALESCE(json_agg(
                    json_build_object(
                        'id', pr.prese_id,
                        'producto', pr.prese_nombre,
                        'cantidad', dc.det_com_cantidad,
                        'precio_unitario', dc.det_com_precio_unitario,
                        'total_linea', dc.det_com_cantidad * dc.det_com_precio_unitario
                    )
                ), '[]'::json)
                FROM public.detalle_compra dc
                JOIN public.presentacion pr ON dc.fk_presentacion = pr.prese_id
                WHERE dc.fk_sol_com = sc.sol_com_id
            ),
            'totales', json_build_object(
                'subtotal', sc.sol_com_total / 1.16,
                'impuestos', sc.sol_com_total - (sc.sol_com_total / 1.16),
                'total', sc.sol_com_total
            )
        )
    INTO v_reporte_data
    FROM public.solicitud_compra sc
    LEFT JOIN public.proveedor p ON sc.fk_proveedor = p.pro_id
    LEFT JOIN public.pre_alm pa ON sc.fk_pre_alm = pa.pre_alm_id
    LEFT JOIN public.almacen a ON pa.fk_almacen = a.alm_id
    LEFT JOIN public.tienda t ON a.fk_tienda = t.tie_id
    WHERE sc.sol_com_id = p_solicitud_id;

    RETURN v_reporte_data;
END;
$$ LANGUAGE plpgsql;

-- reporte 1
CREATE OR REPLACE FUNCTION public.obtener_datos_productores_eventos()
RETURNS JSON AS $$
DECLARE
    v_reporte_data JSON;
BEGIN
    SELECT
        -- json_agg agrupa todas las filas de eventos en un solo array JSON
        COALESCE(json_agg(
            json_build_object(
                'evento_nombre', e.eve_nombre,
                'evento_fecha', TO_CHAR(e.eve_fecha_hora, 'DD/MM/YYYY'),
                'evento_lugar', l.lug_nombre,
                -- Subconsulta para obtener los proveedores de cada evento
                'proveedores', (
                    SELECT COALESCE(json_agg(
                        json_build_object(
                            'proveedor_nombre', p.pro_razon_social,
                            -- Subconsulta para obtener las cervezas de cada proveedor en este evento
                            'cervezas_presentadas', (
                                SELECT COALESCE(json_agg(
                                    json_build_object(
                                        'cerveza_nombre', pr.prese_nombre,
                                        'cantidad', ee.exi_eve_cantidad
                                    )
                                ), '[]'::json)
                                FROM public.existencia_evento ee
                                JOIN public.presentacion pr ON ee.fk_presentacion = pr.prese_id
                                -- CORRECCIÓN FINAL: Se une la existencia directamente con la tabla
                                -- de relación evento-proveedor usando la clave foránea correcta.
                                WHERE ee.fk_evento_proveedor = ep.eve_pro_id
                            )
                        )
                    ), '[]'::json)
                    FROM public.eve_pro ep
                    JOIN public.proveedor p ON ep.fk_proveedor = p.pro_id
                    WHERE ep.fk_evento = e.eve_id
                )
            )
        ), '[]'::json)
    INTO v_reporte_data
    FROM public.evento e
    LEFT JOIN public.lugar l ON e.fk_lugar = l.lug_id;

    RETURN v_reporte_data;
END;
$$ LANGUAGE plpgsql;

-- reporte 2
CREATE OR REPLACE FUNCTION public.calcular_eficiencia_despacho()
RETURNS JSON AS $$
DECLARE
    v_reporte_data JSON;
    v_avg_days NUMERIC;
BEGIN
    -- 1. Calcular el promedio de días que toma el despacho
    WITH
    -- Subconsulta para encontrar la fecha de inicio del estatus 6 para cada venta
    listo_para_entrega AS (
        SELECT
            fk_venta_online,
            MIN(ven_onl_est_fecha_inicio) as fecha_listo
        FROM public.ven_onl_est
        WHERE fk_estatus = 6
        GROUP BY fk_venta_online
    ),
    -- Subconsulta para encontrar la fecha de inicio del estatus 7 para cada venta
    entregado AS (
        SELECT
            fk_venta_online,
            MIN(ven_onl_est_fecha_inicio) as fecha_entregado
        FROM public.ven_onl_est
        WHERE fk_estatus = 7
        GROUP BY fk_venta_online
    )
    -- Se calcula el promedio de la diferencia de días para todas las órdenes que tienen ambos estatus
    SELECT
        -- Se usa COALESCE para devolver 0 si no se encuentra ninguna orden que complete el ciclo
        COALESCE(AVG(e.fecha_entregado - l.fecha_listo), 0)
    INTO v_avg_days
    FROM listo_para_entrega l
    JOIN entregado e ON l.fk_venta_online = e.fk_venta_online
    WHERE e.fecha_entregado >= l.fecha_listo; -- Condición de seguridad

    -- 2. Construir el objeto JSON con el resultado desglosado
    SELECT
        json_build_object(
            'dias', floor(v_avg_days),
            'horas', floor((v_avg_days - floor(v_avg_days)) * 24),
            'minutos', floor(((v_avg_days - floor(v_avg_days)) * 24 - floor((v_avg_days - floor(v_avg_days)) * 24)) * 60)
        )
    INTO v_reporte_data;

    RETURN v_reporte_data;
END;
$$ LANGUAGE plpgsql;

-- reporte 3
CREATE OR REPLACE FUNCTION public.obtener_historico_ofertas(
    p_fecha_inicio DATE,
    p_fecha_fin DATE
)
RETURNS JSON AS $$
DECLARE
    v_reporte_data JSON;
BEGIN
    SELECT
        COALESCE(json_agg(
            json_build_object(
                'oferta_nombre', o.ofe_nombre,
                'oferta_descripcion', o.ofe_descripcion,
                'descuento_porcentaje', o.of_procentaje,
                'fecha_inicio', TO_CHAR(o.ofe_fecha_inicio, 'DD/MM/YYYY'),
                'fecha_fin', TO_CHAR(o.ofe_fecha_fin, 'DD/MM/YYYY'),
                -- Subconsulta para obtener los productos asociados a esta oferta
                'productos_afectados', (
                    -- Se combinan productos de inventario físico y de almacén online
                    SELECT COALESCE(json_agg(DISTINCT prod.producto_nombre), '[]'::json)
                    FROM (
                        -- Productos del inventario físico
                        SELECT pr.prese_nombre AS producto_nombre
                        FROM public.inventario i
                        JOIN public.presentacion pr ON i.fk_presentacion = pr.prese_id
                        WHERE i.fk_oferta = o.ofe_id
                        UNION
                        -- Productos del almacén online
                        SELECT pr.prese_nombre AS producto_nombre
                        FROM public.pre_alm pa
                        JOIN public.presentacion pr ON pa.fk_presentacion = pr.prese_id
                        WHERE pa.fk_oferta = o.ofe_id
                    ) AS prod
                )
            )
        ), '[]'::json)
    INTO v_reporte_data
    FROM public.oferta o
    -- La condición del WHERE filtra las ofertas que estuvieron activas en el rango
    WHERE o.ofe_fecha_inicio <= p_fecha_fin AND o.ofe_fecha_fin >= p_fecha_inicio;

    RETURN v_reporte_data;
END;
$$ LANGUAGE plpgsql;

-- reporte 4
CREATE OR REPLACE FUNCTION public.obtener_reporte_incumplimiento_horario(
    p_fecha_inicio DATE,
    p_fecha_fin DATE
)
RETURNS JSON AS $$
DECLARE
    v_reporte_data JSON;
BEGIN
    WITH
    -- 1. Se obtienen todas las incidencias, convirtiendo las horas a la zona horaria local
    incidencias AS (
        SELECT
            a.fk_empleado,
            e.emp_pnombre || ' ' || e.emp_papellido AS empleado_nombre,
            h.hor_dia AS dia_semana,
            (a.asi_fecha_hora_inico AT TIME ZONE 'America/Caracas')::DATE AS fecha,
            h.hor_hora_inicio AS hora_entrada_pautada,
            (a.asi_fecha_hora_inico AT TIME ZONE 'America/Caracas')::TIME AS hora_entrada_real,
            h.hor_hora_fin AS hora_salida_pautada,
            (a.asi_fecha_hora_fin AT TIME ZONE 'America/Caracas')::TIME AS hora_salida_real,
            -- Se verifica si la entrada fue tarde usando la hora local
            CASE
                WHEN (a.asi_fecha_hora_inico AT TIME ZONE 'America/Caracas')::TIME > h.hor_hora_inicio
                THEN 'Llegada Tarde'
                ELSE NULL
            END AS tipo_incidencia_entrada,
            -- Se verifica si la salida fue temprano usando la hora local
            CASE
                WHEN a.asi_fecha_hora_fin IS NOT NULL AND (a.asi_fecha_hora_fin AT TIME ZONE 'America/Caracas')::TIME < h.hor_hora_fin
                THEN 'Salida Temprano'
                ELSE NULL
            END AS tipo_incidencia_salida,
            -- Se calcula la diferencia de tiempo para llegadas tardes
            CASE
                WHEN (a.asi_fecha_hora_inico AT TIME ZONE 'America/Caracas')::TIME > h.hor_hora_inicio
                THEN (a.asi_fecha_hora_inico AT TIME ZONE 'America/Caracas')::TIME - h.hor_hora_inicio
                ELSE '00:00:00'::INTERVAL
            END AS diferencia_entrada,
            -- Se calcula la diferencia de tiempo para salidas tempranas
            CASE
                WHEN a.asi_fecha_hora_fin IS NOT NULL AND (a.asi_fecha_hora_fin AT TIME ZONE 'America/Caracas')::TIME < h.hor_hora_fin
                THEN h.hor_hora_fin - (a.asi_fecha_hora_fin AT TIME ZONE 'America/Caracas')::TIME
                ELSE '00:00:00'::INTERVAL
            END AS diferencia_salida
        FROM public.asistencia a
        JOIN public.empleado e ON a.fk_empleado = e.emp_id
        JOIN public.emp_car_hor ech ON e.emp_id = ech.fk_empleado
        JOIN public.horario h ON ech.fk_horario = h.hor_id
        WHERE (a.asi_fecha_hora_inico AT TIME ZONE 'America/Caracas')::DATE BETWEEN p_fecha_inicio AND p_fecha_fin
          AND h.hor_dia = CASE EXTRACT(ISODOW FROM (a.asi_fecha_hora_inico AT TIME ZONE 'America/Caracas'))
                              WHEN 1 THEN 'Lunes' WHEN 2 THEN 'Martes' WHEN 3 THEN 'Miércoles'
                              WHEN 4 THEN 'Jueves' WHEN 5 THEN 'Viernes' WHEN 6 THEN 'Sábado'
                              WHEN 7 THEN 'Domingo'
                          END
    ),
    -- 2. Se procesan las incidencias para listarlas
    incumplimientos_procesados AS (
        SELECT fk_empleado, empleado_nombre, fecha, 'Llegada Tarde' AS tipo,
               json_build_object(
                   'hora_entrada_pautada', hora_entrada_pautada,
                   'hora_entrada_real', hora_entrada_real,
                   'hora_salida_pautada', hora_salida_pautada,
                   'hora_salida_real', COALESCE(hora_salida_real, NULL),
                   'detalle_texto', 'Entrada pautada: ' || hora_entrada_pautada || ', Entrada real: ' || hora_entrada_real
               ) AS detalle_info,
               diferencia_entrada AS duracion
        FROM incidencias WHERE tipo_incidencia_entrada IS NOT NULL
        UNION ALL
        SELECT fk_empleado, empleado_nombre, fecha, 'Salida Temprano' AS tipo,
               json_build_object(
                   'hora_entrada_pautada', hora_entrada_pautada,
                   'hora_entrada_real', hora_entrada_real,
                   'hora_salida_pautada', hora_salida_pautada,
                   'hora_salida_real', hora_salida_real,
                   'detalle_texto', 'Salida pautada: ' || hora_salida_pautada || ', Salida real: ' || hora_salida_real
               ) AS detalle_info,
               diferencia_salida AS duracion
        FROM incidencias WHERE tipo_incidencia_salida IS NOT NULL
    )
    -- 3. Se agrupan todos los incumplimientos por empleado en un JSON
    SELECT COALESCE(json_agg(
        json_build_object(
            'empleado_id', t.fk_empleado,
            'empleado_nombre', t.empleado_nombre,
            'incumplimientos', t.incidencias_agrupadas
        )
    ), '[]'::json)
    INTO v_reporte_data
    FROM (
        SELECT
            fk_empleado,
            empleado_nombre,
            json_agg(
                json_build_object(
                    'fecha', TO_CHAR(fecha, 'DD/MM/YYYY'),
                    'tipo', tipo,
                    'detalle', detalle_info,
                    'duracion', TO_CHAR(duracion, 'HH24:MI:SS')
                ) ORDER BY fecha
            ) AS incidencias_agrupadas
        FROM incumplimientos_procesados
        GROUP BY fk_empleado, empleado_nombre
    ) AS t;

    RETURN v_reporte_data;
END;
$$ LANGUAGE plpgsql;

-- reporte 5
-- =================================================================================
-- FUNCIÓN PARA OBTENER ÓRDENES DE COMPRA ESTRICTAMENTE PENDIENTES
-- Descripción: Devuelve una lista de solicitudes de compra cuyo único estado
--              registrado en el historial es 'PENDIENTE'.
-- Retorna:
--   JSON: Un array de objetos, donde cada objeto es una orden de compra pendiente.
-- =================================================================================
CREATE OR REPLACE FUNCTION public.obtener_ordenes_compra_pendientes()
RETURNS JSON AS $$
DECLARE
    v_reporte_data JSON;
BEGIN
    -- Se utiliza una Expresión de Tabla Común (CTE) para analizar los estados de cada solicitud.
    WITH
    -- 1. Se agrupan los estados por solicitud para verificar las condiciones.
    estados_por_solicitud AS (
        SELECT
            sce.fk_sol_com,
            -- Se cuenta el número total de registros de estado para cada solicitud.
            COUNT(*) AS total_estados,
            -- Se comprueba si el estado 'PENDIENTE' existe para esa solicitud.
            -- Usamos COUNT con FILTER para contar solo las apariciones de 'PENDIENTE'.
            COUNT(*) FILTER (WHERE UPPER(e.est_tipo_estatus) = 'PENDIENTE') AS conteo_pendiente
        FROM public.sol_com_est sce
        JOIN public.estatus e ON sce.fk_estatus = e.est_id
        GROUP BY sce.fk_sol_com
    )
    -- 2. Se construye el JSON final uniendo los resultados con la tabla principal.
    SELECT
        COALESCE(json_agg(
            json_build_object(
                'orden_id', sc.sol_com_id,
                'fecha_solicitud', TO_CHAR(sc.sol_com_fecha, 'DD/MM/YYYY'),
                'proveedor_nombre', p.pro_razon_social,
                'total_orden', sc.sol_com_total
            )
        ), '[]'::json)
    INTO v_reporte_data
    FROM public.solicitud_compra sc
    -- Se une con la CTE que contiene el análisis de los estados.
    JOIN estados_por_solicitud eps ON sc.sol_com_id = eps.fk_sol_com
    -- Se unen las tablas de proveedor (el usuario aprobador será NULL para pendientes).
    LEFT JOIN public.proveedor p ON sc.fk_proveedor = p.pro_id
    -- 3. CONDICIÓN FINAL: Se filtra para incluir solo solicitudes que:
    --    a) Tienen exactamente un (1) registro de estado en total.
    --    b) Y ese único estado es 'PENDIENTE' (conteo_pendiente = 1).
    WHERE eps.total_estados = 1 AND eps.conteo_pendiente = 1;

    RETURN v_reporte_data;
END;
$$ LANGUAGE plpgsql;


-- ===========================================
-- FUNCION: modificar_usuario
-- ===========================================
CREATE OR REPLACE FUNCTION modificar_usuario(
    p_id_usuario INTEGER,
    p_username TEXT,
    p_email TEXT,
    p_password TEXT,
    p_first_name TEXT,
    p_last_name TEXT
)
RETURNS VOID AS $$
BEGIN
    UPDATE usuario
    SET 
        username = p_username,
        email = p_email,
        first_name = p_first_name,
        last_name = p_last_name,
        password = CASE 
            WHEN p_password IS NOT NULL AND p_password != '' 
            THEN p_password
            ELSE password
        END
    WHERE id = p_id_usuario;
END;
$$ LANGUAGE plpgsql;

-- ===========================================
-- FUNCION: eliminar_usuario
-- ===========================================

CREATE OR REPLACE FUNCTION eliminar_usuario(p_id_usuario INTEGER)
RETURNS VOID AS $$
BEGIN
    UPDATE usuario
    SET is_active = FALSE
    WHERE id = p_id_usuario;
END;
$$ LANGUAGE plpgsql;

-- Asegúrate de que el dueño sea postgres
ALTER FUNCTION eliminar_usuario(INTEGER) OWNER TO postgres;

-- ===========================================
-- FUNCION: Crear_rol
-- ===========================================

CREATE OR REPLACE FUNCTION crear_rol(p_nombre VARCHAR)
RETURNS VOID AS $$
BEGIN
    INSERT INTO rol (rol_nombre) VALUES (p_nombre);
END;
$$ LANGUAGE plpgsql;

-- ===========================================
-- FUNCION: Modificar_rol
-- ===========================================

CREATE OR REPLACE FUNCTION modificar_rol(p_id INTEGER, p_nuevo_nombre VARCHAR)
RETURNS VOID AS $$
BEGIN
    UPDATE rol
    SET rol_nombre = p_nuevo_nombre
    WHERE rol_id = p_id;
END;
$$ LANGUAGE plpgsql;

-- ===========================================
-- FUNCION: Eliminar_rol
-- ===========================================

CREATE OR REPLACE FUNCTION eliminar_rol(p_id INTEGER)
RETURNS VOID AS $$
BEGIN
    DELETE FROM rol
    WHERE rol_id = p_id;
END;
$$ LANGUAGE plpgsql;

-- ===========================================
-- FUNCION: Asignar_rol_a_usuario
-- ===========================================

CREATE OR REPLACE FUNCTION asignar_rol_a_usuario(p_id_usuario INTEGER, p_id_rol INTEGER)
RETURNS VOID AS $$
BEGIN
    UPDATE usuario
    SET fk_rol = p_id_rol
    WHERE id = p_id_usuario;
END;
$$ LANGUAGE plpgsql;

-- ===========================================
-- FUNCION: Crear_Privilegio
-- ===========================================

CREATE OR REPLACE FUNCTION crear_privilegio(p_nombre VARCHAR)
RETURNS VOID AS $$
BEGIN
    INSERT INTO privilegio (privilegio_nombre) VALUES (p_nombre);
END;
$$ LANGUAGE plpgsql;

-- ===========================================
-- FUNCION: Modificar_Privilegio
-- ===========================================

CREATE OR REPLACE FUNCTION modificar_privilegio(p_id INTEGER, p_nuevo_nombre VARCHAR)
RETURNS VOID AS $$
BEGIN
    UPDATE privilegio
    SET privilegio_nombre = p_nuevo_nombre
    WHERE privilegio_id = p_id;
END;
$$ LANGUAGE plpgsql;

-- ===========================================
-- FUNCION: Eliminar_Privilegio
-- ===========================================

CREATE OR REPLACE FUNCTION eliminar_privilegio(p_id INTEGER)
RETURNS VOID AS $$
BEGIN
    DELETE FROM privilegio
    WHERE privilegio_id = p_id;
END;
$$ LANGUAGE plpgsql;

-- ===========================================
-- FUNCION: Asignar_privilegio_a_rol
-- ===========================================

CREATE OR REPLACE FUNCTION asignar_privilegio_a_rol(p_id_privilegio INTEGER, p_id_rol INTEGER)
RETURNS VOID AS $$
BEGIN
    INSERT INTO rol_privilegio (fk_privilegio, fk_rol)
    VALUES (p_id_privilegio, p_id_rol)
    ON CONFLICT DO NOTHING;
END;
$$ LANGUAGE plpgsql;

-- ===========================================
-- FUNCION: Quitar_privilegio_de_rol
-- ===========================================

CREATE OR REPLACE FUNCTION quitar_privilegio_de_rol(p_id_privilegio INTEGER, p_id_rol INTEGER)
RETURNS VOID AS $$
BEGIN
    DELETE FROM rol_privilegio
    WHERE fk_privilegio = p_id_privilegio AND fk_rol = p_id_rol;
END;
$$ LANGUAGE plpgsql;

-- ===========================================
-- FUNCION: obtener_historial_compras_cliente
-- ===========================================
CREATE OR REPLACE FUNCTION public.obtener_historial_compras_cliente(p_cliente_id INT)
RETURNS JSON AS $$
DECLARE
    v_reporte_data JSON;
BEGIN
    WITH
    todas_las_ventas AS (
        -- Ventas Físicas
        SELECT
            vf.ven_fis_id AS id_venta,
            vf.ven_fis_fecha::DATE AS fecha,
            vf.ven_fis_total AS total,
            'Venta en Tienda' AS tipo_compra,
            'fisica' AS tipo_factura
        FROM public.venta_fisica vf
        WHERE vf.fk_cliente = p_cliente_id

        UNION ALL

        -- Ventas Online
        SELECT
            vo.ven_onl_id AS id_venta,
            vo.ven_onl_fecha::DATE AS fecha,
            vo.ven_onl_total AS total,
            'Pedido Online' AS tipo_compra,
            'online' AS tipo_factura
        FROM public.venta_online vo
        JOIN public.usuario u ON vo.fk_usuario = u.id
        WHERE u.fk_cliente = p_cliente_id

        UNION ALL

        -- Ventas en Eventos
        SELECT
            ve.ven_bol_eve_id AS id_venta,
            ve.ven_bol_eve_fecha_hora::DATE AS fecha,
            ve.ven_bol_eve_monto_total AS total,
            'Compra en Evento' AS tipo_compra,
            'evento' AS tipo_factura
        FROM public.venta_boleto_evento ve
        JOIN public.usuario u ON ve.fk_usuario = u.id
        WHERE u.fk_cliente = p_cliente_id
    )
    SELECT
        COALESCE(json_agg(
            json_build_object(
                'id_venta', tv.id_venta,
                'fecha_compra', TO_CHAR(tv.fecha, 'DD/MM/YYYY'),
                'monto_total', tv.total,
                'tipo_compra', tv.tipo_compra,
                'tipo_factura', tv.tipo_factura
            )
            ORDER BY tv.fecha DESC
        ), '[]'::json)
    INTO v_reporte_data
    FROM todas_las_ventas tv;

    RETURN v_reporte_data;
END;
$$ LANGUAGE plpgsql;


-- obtener todas las ordenes de compra
CREATE OR REPLACE FUNCTION public.obtener_todas_ordenes_compra()
RETURNS JSON AS $$
DECLARE
    v_reporte_data JSON;
BEGIN
    WITH
    -- Subconsulta para encontrar el estatus más reciente de cada solicitud
    ultimo_estatus AS (
        SELECT
            fk_sol_com,
            ROW_NUMBER() OVER(PARTITION BY fk_sol_com ORDER BY sol_com_est_fecha_inicio DESC, sol_com_est_id DESC) as rn,
            fk_estatus
        FROM public.sol_com_est
    ),
    -- Subconsulta para encontrar la fecha de aprobación de cada solicitud
    fecha_aprobacion AS (
        SELECT
            fk_sol_com,
            MIN(sol_com_est_fecha_inicio) as fecha_aprob
        FROM public.sol_com_est
        JOIN public.estatus ON fk_estatus = est_id
        WHERE UPPER(est_tipo_estatus) = 'APROBADO'
        GROUP BY fk_sol_com
    )
    SELECT
        COALESCE(json_agg(
            json_build_object(
                'orden_id', sc.sol_com_id,
                'fecha_solicitud', TO_CHAR(sc.sol_com_fecha, 'DD/MM/YYYY'),
                'proveedor_nombre', p.pro_razon_social,
                'aprobado_por', u.username,
                'total_orden', sc.sol_com_total,
                'estatus_actual_id', e.est_id,
                'estatus_actual_nombre', e.est_tipo_estatus,
                'fecha_aprobacion', TO_CHAR(fa.fecha_aprob, 'DD/MM/YYYY')
            ) ORDER BY sc.sol_com_id DESC
        ), '[]'::json)
    INTO v_reporte_data
    FROM public.solicitud_compra sc
    JOIN ultimo_estatus ue ON sc.sol_com_id = ue.fk_sol_com AND ue.rn = 1
    JOIN public.estatus e ON ue.fk_estatus = e.est_id
    LEFT JOIN fecha_aprobacion fa ON sc.sol_com_id = fa.fk_sol_com
    LEFT JOIN public.proveedor p ON sc.fk_proveedor = p.pro_id
    LEFT JOIN public.usuario u ON sc.fk_usuario = u.id;

    RETURN v_reporte_data;
END;
$$ LANGUAGE plpgsql;

-- actualizar estatus de orden de compra
CREATE OR REPLACE FUNCTION public.actualizar_estatus_orden_compra(
    p_solicitud_id INT,
    p_nuevo_estatus_id INT
)
RETURNS VOID AS $$
BEGIN
    -- Se inserta el nuevo estado en el historial, asociándolo a la solicitud de compra.
    -- La fecha de inicio se establece como la fecha actual.
    INSERT INTO public.sol_com_est (fk_sol_com, fk_estatus, sol_com_est_fecha_inicio)
    VALUES (p_solicitud_id, p_nuevo_estatus_id, CURRENT_DATE);
END;
$$ LANGUAGE plpgsql;

-- obtener todas las solicitudes de reposición
CREATE OR REPLACE FUNCTION public.obtener_todas_solicitudes_reposicion()
RETURNS JSON AS $$
DECLARE
    v_reporte_data JSON;
BEGIN
    WITH
    -- Subconsulta para encontrar el estatus más reciente de cada solicitud
    ultimo_estatus AS (
        SELECT
            fk_sol_rep,
            ROW_NUMBER() OVER(PARTITION BY fk_sol_rep ORDER BY sol_rep_est_fecha_inicio DESC, sol_rep_est_id DESC) as rn,
            fk_estatus
        FROM public.sol_rep_est
    )
    SELECT
        COALESCE(json_agg(
            json_build_object(
                'solicitud_id', sr.sol_rep_id,
                'fecha_solicitud', TO_CHAR(sr.sol_rep_fecha_hora, 'DD/MM/YYYY HH24:MI:SS'),
                'descripcion', sr.sol_rep_descripcion,
                -- Campo corregido para el ID del producto
                'producto_id', p.prese_id,
                -- Campo corregido para el número de anaquel
                'anaquel', a.ana_numero,
                'estatus_actual_id', e.est_id,
                'estatus_actual_nombre', e.est_tipo_estatus
            ) ORDER BY sr.sol_rep_id DESC
        ), '[]'::json)
    INTO v_reporte_data
    FROM public.solicitud_reposicion sr
    JOIN ultimo_estatus ue ON sr.sol_rep_id = ue.fk_sol_rep AND ue.rn = 1
    JOIN public.estatus e ON ue.fk_estatus = e.est_id
    -- Se realizan las uniones para obtener la información del producto y anaquel
    LEFT JOIN public.inventario i ON sr.fk_inv = i.inv_id
    LEFT JOIN public.presentacion p ON i.fk_presentacion = p.prese_id
    LEFT JOIN public.anaquel a ON i.fk_anaquel = a.ana_id;

    RETURN v_reporte_data;
END;
$$ LANGUAGE plpgsql;

-- actualizar estatus de solicitud de reposición
CREATE OR REPLACE FUNCTION public.actualizar_estatus_solicitud_reposicion(
    p_solicitud_id INT,
    p_nuevo_estatus_id INT
)
RETURNS VOID AS $$
DECLARE
    -- Variable para guardar el ID del inventario a actualizar.
    v_inventario_id INT;
    -- ¡CONFIGURAR AQUÍ! Asigna el ID que corresponde al estatus "Finalizado" en tu tabla 'estatus'.
    v_id_estatus_finalizado INT := 5; -- ASUNCIÓN: El ID 3 corresponde a "Finalizado".
BEGIN
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    -- PASO 1: CERRAR EL ESTATUS ANTERIOR
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    UPDATE public.sol_rep_est
    SET sol_rep_est_fecha_fin = CURRENT_DATE
    WHERE fk_sol_rep = p_solicitud_id AND sol_rep_est_fecha_fin IS NULL;

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    -- PASO 2: INSERTAR EL NUEVO REGISTRO DE ESTATUS
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    INSERT INTO public.sol_rep_est (fk_sol_rep, fk_estatus, sol_rep_est_fecha_inicio, sol_rep_est_fecha_fin)
    VALUES (p_solicitud_id, p_nuevo_estatus_id, CURRENT_DATE, NULL);

    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    -- PASO 3: REPONER STOCK SI EL ESTATUS ES "FINALIZADO"
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    IF p_nuevo_estatus_id = v_id_estatus_finalizado THEN
        
        -- Mensaje de depuración 1: Confirma que la condición de "Finalizado" se cumplió.
        RAISE NOTICE 'Intento de reponer stock para la solicitud %. El estatus es "Finalizado".', p_solicitud_id;

        -- Obtiene el ID del inventario asociado a esta solicitud de reposición.
        SELECT fk_inv INTO v_inventario_id
        FROM public.solicitud_reposicion
        WHERE sol_rep_id = p_solicitud_id;

        -- Si se encontró un ID de inventario, se suma 100 a la cantidad actual.
        IF FOUND THEN
            -- Mensaje de depuración 2: Confirma que se encontró un inventario.
            RAISE NOTICE 'Inventario ID % encontrado para la solicitud %. Procediendo a sumar 100 unidades.', v_inventario_id, p_solicitud_id;
            
            UPDATE public.inventario
            SET inv_cantidad = inv_cantidad + 100
            WHERE inv_id = v_inventario_id;
        ELSE
            -- Mensaje de depuración 3: Se activa si no se encontró un inventario.
            RAISE NOTICE 'ERROR: No se encontró un ID de inventario (fk_inv) para la solicitud %.', p_solicitud_id;
        END IF;
    END IF;

END;
$$ LANGUAGE plpgsql;

-- obtener todos los proveedores
CREATE OR REPLACE FUNCTION public.obtener_proveedores()
RETURNS JSON AS $$
DECLARE
    v_proveedores JSON;
BEGIN
    SELECT COALESCE(json_agg(
        json_build_object(
            'id', p.pro_id,
            'nombre', COALESCE(p.pro_razon_social, p.pro_denominacion_comercial, 'Sin nombre'),
            'rif', p.pro_rif
        ) ORDER BY p.pro_razon_social
    ), '[]'::json)
    INTO v_proveedores
    FROM public.proveedor p;

    RETURN v_proveedores;
END;
$$ LANGUAGE plpgsql;

-- cambiar proveedor de una solicitud de compra
CREATE OR REPLACE FUNCTION public.cambiar_proveedor_solicitud(
    p_solicitud_id INT,
    p_nuevo_proveedor_id INT
)
RETURNS VOID AS $$
BEGIN
    UPDATE public.solicitud_compra
    SET fk_proveedor = p_nuevo_proveedor_id
    WHERE sol_com_id = p_solicitud_id;
END;
$$ LANGUAGE plpgsql;

-- aprobar solicitud con usuario aprobador
CREATE OR REPLACE FUNCTION public.aprobar_solicitud_compra(
    p_solicitud_id INT,
    p_usuario_aprobador_id INT
)
RETURNS VOID AS $$
BEGIN
    -- Actualizar el usuario que aprueba la solicitud
    UPDATE public.solicitud_compra
    SET fk_usuario = p_usuario_aprobador_id
    WHERE sol_com_id = p_solicitud_id;
    
    -- Insertar el nuevo estatus APROBADO (id = 2)
    INSERT INTO public.sol_com_est (fk_sol_com, fk_estatus, sol_com_est_fecha_inicio)
    VALUES (p_solicitud_id, 2, CURRENT_DATE);
END;
$$ LANGUAGE plpgsql;

-- rechazar solicitud con usuario que rechaza
CREATE OR REPLACE FUNCTION public.rechazar_solicitud_compra(
    p_solicitud_id INT,
    p_usuario_rechaza_id INT
)
RETURNS VOID AS $$
BEGIN
    -- Actualizar el usuario que rechaza la solicitud
    UPDATE public.solicitud_compra
    SET fk_usuario = p_usuario_rechaza_id
    WHERE sol_com_id = p_solicitud_id;
    
    -- Insertar el nuevo estatus RECHAZADO (id = 3)
    INSERT INTO public.sol_com_est (fk_sol_com, fk_estatus, sol_com_est_fecha_inicio)
    VALUES (p_solicitud_id, 3, CURRENT_DATE);
END;
$$ LANGUAGE plpgsql;

-- devolver solicitud rechazada a pendiente
CREATE OR REPLACE FUNCTION public.devolver_solicitud_a_pendiente(
    p_solicitud_id INT
)
RETURNS VOID AS $$
BEGIN
    -- Limpiar el usuario para indicar que vuelve a estar sin revisar
    UPDATE public.solicitud_compra
    SET fk_usuario = NULL
    WHERE sol_com_id = p_solicitud_id;
    
    -- Insertar el nuevo estatus PENDIENTE (id = 1)
    INSERT INTO public.sol_com_est (fk_sol_com, fk_estatus, sol_com_est_fecha_inicio)
    VALUES (p_solicitud_id, 1, CURRENT_DATE);
END;
$$ LANGUAGE plpgsql;

-- marcar solicitud como entregada
CREATE OR REPLACE FUNCTION public.marcar_solicitud_entregada(
    p_solicitud_id INT
)
RETURNS VOID AS $$
BEGIN
    -- Insertar el nuevo estatus ENTREGADO (id = 7)
    INSERT INTO public.sol_com_est (fk_sol_com, fk_estatus, sol_com_est_fecha_inicio)
    VALUES (p_solicitud_id, 7, CURRENT_DATE);
END;
$$ LANGUAGE plpgsql;

-- obtener solicitudes aprobadas
CREATE OR REPLACE FUNCTION public.obtener_solicitudes_aprobadas()
RETURNS JSON AS $$
DECLARE
    v_reporte_data JSON;
BEGIN
    WITH
    ultimo_estatus AS (
        SELECT
            fk_sol_com,
            ROW_NUMBER() OVER(PARTITION BY fk_sol_com ORDER BY sol_com_est_fecha_inicio DESC, sol_com_est_id DESC) as rn,
            fk_estatus
        FROM public.sol_com_est
    )
    SELECT
        COALESCE(json_agg(
            json_build_object(
                'orden_id', sc.sol_com_id,
                'fecha_solicitud', TO_CHAR(sc.sol_com_fecha, 'DD/MM/YYYY'),
                'fecha_aprobacion', TO_CHAR(sce_aprob.sol_com_est_fecha_inicio, 'DD/MM/YYYY'),
                'proveedor_nombre', p.pro_razon_social,
                'aprobado_por', u.username,
                'total_orden', sc.sol_com_total
            ) ORDER BY sc.sol_com_id DESC
        ), '[]'::json)
    INTO v_reporte_data
    FROM public.solicitud_compra sc
    JOIN ultimo_estatus ue ON sc.sol_com_id = ue.fk_sol_com AND ue.rn = 1
    JOIN public.estatus e ON ue.fk_estatus = e.est_id
    -- JOIN para obtener la fecha de aprobación específica
    LEFT JOIN public.sol_com_est sce_aprob ON sc.sol_com_id = sce_aprob.fk_sol_com AND sce_aprob.fk_estatus = 2
    LEFT JOIN public.proveedor p ON sc.fk_proveedor = p.pro_id
    LEFT JOIN public.usuario u ON sc.fk_usuario = u.id
    WHERE UPPER(e.est_tipo_estatus) = 'APROBADO';

    RETURN v_reporte_data;
END;
$$ LANGUAGE plpgsql;

-- obtener solicitudes rechazadas
CREATE OR REPLACE FUNCTION public.obtener_solicitudes_rechazadas()
RETURNS JSON AS $$
DECLARE
    v_reporte_data JSON;
BEGIN
    WITH
    ultimo_estatus AS (
        SELECT
            fk_sol_com,
            ROW_NUMBER() OVER(PARTITION BY fk_sol_com ORDER BY sol_com_est_fecha_inicio DESC, sol_com_est_id DESC) as rn,
            fk_estatus
        FROM public.sol_com_est
    )
    SELECT
        COALESCE(json_agg(
            json_build_object(
                'orden_id', sc.sol_com_id,
                'fecha_solicitud', TO_CHAR(sc.sol_com_fecha, 'DD/MM/YYYY'),
                'fecha_rechazo', TO_CHAR(sce_rech.sol_com_est_fecha_inicio, 'DD/MM/YYYY'),
                'proveedor_nombre', p.pro_razon_social,
                'rechazado_por', u.username,
                'total_orden', sc.sol_com_total
            ) ORDER BY sc.sol_com_id DESC
        ), '[]'::json)
    INTO v_reporte_data
    FROM public.solicitud_compra sc
    JOIN ultimo_estatus ue ON sc.sol_com_id = ue.fk_sol_com AND ue.rn = 1
    JOIN public.estatus e ON ue.fk_estatus = e.est_id
    -- JOIN para obtener la fecha de rechazo específica
    LEFT JOIN public.sol_com_est sce_rech ON sc.sol_com_id = sce_rech.fk_sol_com AND sce_rech.fk_estatus = 3
    LEFT JOIN public.proveedor p ON sc.fk_proveedor = p.pro_id
    LEFT JOIN public.usuario u ON sc.fk_usuario = u.id
    WHERE UPPER(e.est_tipo_estatus) = 'RECHAZADO';

    RETURN v_reporte_data;
END;
$$ LANGUAGE plpgsql;

-- obtener solicitudes entregadas con paginación
CREATE OR REPLACE FUNCTION public.obtener_solicitudes_entregadas(
    p_limite INT DEFAULT 20,
    p_offset INT DEFAULT 0
)
RETURNS JSON AS $$
DECLARE
    v_reporte_data JSON;
BEGIN
    WITH
    ultimo_estatus AS (
        SELECT
            fk_sol_com,
            ROW_NUMBER() OVER(PARTITION BY fk_sol_com ORDER BY sol_com_est_fecha_inicio DESC, sol_com_est_id DESC) as rn,
            fk_estatus,
            sol_com_est_fecha_inicio as fecha_entrega
        FROM public.sol_com_est
    )
    SELECT
        json_build_object(
            'solicitudes', COALESCE(json_agg(
                json_build_object(
                    'orden_id', sc.sol_com_id,
                    'fecha_solicitud', TO_CHAR(sc.sol_com_fecha, 'DD/MM/YYYY'),
                    'fecha_entrega', TO_CHAR(ue.fecha_entrega, 'DD/MM/YYYY'),
                    'proveedor_nombre', p.pro_razon_social,
                    'aprobado_por', u.username,
                    'total_orden', sc.sol_com_total
                ) ORDER BY ue.fecha_entrega DESC
            ), '[]'::json),
            'total_count', (
                SELECT COUNT(*)
                FROM public.solicitud_compra sc2
                JOIN ultimo_estatus ue2 ON sc2.sol_com_id = ue2.fk_sol_com AND ue2.rn = 1
                JOIN public.estatus e2 ON ue2.fk_estatus = e2.est_id
                WHERE UPPER(e2.est_tipo_estatus) = 'ENTREGADO'
            )
        )
    INTO v_reporte_data
    FROM public.solicitud_compra sc
    JOIN ultimo_estatus ue ON sc.sol_com_id = ue.fk_sol_com AND ue.rn = 1
    JOIN public.estatus e ON ue.fk_estatus = e.est_id
    LEFT JOIN public.proveedor p ON sc.fk_proveedor = p.pro_id
    LEFT JOIN public.usuario u ON sc.fk_usuario = u.id
    WHERE UPPER(e.est_tipo_estatus) = 'ENTREGADO'
    LIMIT p_limite OFFSET p_offset;

    RETURN v_reporte_data;
END;
$$ LANGUAGE plpgsql;


-- indicadores de ventas
-- Ventas Totales (por tienda)
CREATE OR REPLACE FUNCTION public.kpi_ventas_totales_por_tienda(
    p_fecha_inicio DATE,
    p_fecha_fin DATE
)
RETURNS JSON AS $$
DECLARE
    v_total_fisica NUMERIC;
    v_total_online NUMERIC;
BEGIN
    -- Calcular total para ventas físicas
    SELECT COALESCE(SUM(ven_fis_total), 0)
    INTO v_total_fisica
    FROM public.venta_fisica
    WHERE ven_fis_fecha BETWEEN p_fecha_inicio AND p_fecha_fin;

    -- Calcular total para ventas online
    SELECT COALESCE(SUM(ven_onl_total), 0)
    INTO v_total_online
    FROM public.venta_online
    WHERE ven_onl_fecha BETWEEN p_fecha_inicio AND p_fecha_fin;

    -- Construir el objeto JSON con los resultados
    RETURN json_build_object(
        'total_fisica', v_total_fisica,
        'total_online', v_total_online,
        'total_general', v_total_fisica + v_total_online
    );
END;
$$ LANGUAGE plpgsql;

--Crecimiento de ventas
CREATE OR REPLACE FUNCTION public.kpi_ventas_totales_por_tienda(
    p_fecha_inicio DATE,
    p_fecha_fin DATE
)
RETURNS JSON AS $$
DECLARE
    v_total_fisica NUMERIC;
    v_total_online NUMERIC;
BEGIN
    -- Calcular total para ventas físicas
    SELECT COALESCE(SUM(ven_fis_total), 0)
    INTO v_total_fisica
    FROM public.venta_fisica
    WHERE ven_fis_fecha BETWEEN p_fecha_inicio AND p_fecha_fin;

    -- Calcular total para ventas online
    SELECT COALESCE(SUM(ven_onl_total), 0)
    INTO v_total_online
    FROM public.venta_online
    WHERE ven_onl_fecha BETWEEN p_fecha_inicio AND p_fecha_fin;

    -- Construir el objeto JSON con los resultados
    RETURN json_build_object(
        'total_fisica', v_total_fisica,
        'total_online', v_total_online,
        'total_general', v_total_fisica + v_total_online
    );
END;
$$ LANGUAGE plpgsql;

-- crecimiento de ventas
CREATE OR REPLACE FUNCTION public.kpi_crecimiento_ventas(
    p_fecha_inicio DATE,
    p_fecha_fin DATE,
    p_intervalo TEXT
)
RETURNS JSON AS $$
DECLARE
    v_ventas_actuales NUMERIC;
    v_ventas_anteriores NUMERIC;
    v_duracion_periodo INT;
    v_fecha_inicio_anterior DATE;
    v_fecha_fin_anterior DATE;
    v_crecimiento_monto NUMERIC;
    v_crecimiento_porcentaje NUMERIC;
BEGIN
    -- Determinar el período anterior a comparar
    IF p_intervalo = 'mes' THEN
        v_fecha_inicio_anterior := p_fecha_inicio - INTERVAL '1 month';
        v_fecha_fin_anterior := p_fecha_fin - INTERVAL '1 month';
    ELSIF p_intervalo = 'ano' THEN
        v_fecha_inicio_anterior := p_fecha_inicio - INTERVAL '1 year';
        v_fecha_fin_anterior := p_fecha_fin - INTERVAL '1 year';
    -- ✅ NUEVA CONDICIÓN: Se añade la lógica para la semana anterior.
    ELSIF p_intervalo = 'semana' THEN
        v_fecha_inicio_anterior := p_fecha_inicio - INTERVAL '7 days';
        v_fecha_fin_anterior := p_fecha_fin - INTERVAL '7 days';
    ELSE 
        -- Comportamiento por defecto (período de igual duración anterior)
        v_duracion_periodo := p_fecha_fin - p_fecha_inicio;
        v_fecha_inicio_anterior := p_fecha_inicio - (v_duracion_periodo + 1) * INTERVAL '1 day';
        v_fecha_fin_anterior := p_fecha_fin - (v_duracion_periodo + 1) * INTERVAL '1 day';
    END IF;

    -- Lógica para sumar ventas del período actual (sin cambios)
    SELECT COALESCE(SUM(total_venta), 0) INTO v_ventas_actuales
    FROM (
        SELECT ven_fis_total AS total_venta FROM public.venta_fisica WHERE ven_fis_fecha BETWEEN p_fecha_inicio AND p_fecha_fin
        UNION ALL
        SELECT ven_onl_total AS total_venta FROM public.venta_online WHERE ven_onl_fecha BETWEEN p_fecha_inicio AND p_fecha_fin
    ) AS ventas;

    -- Lógica para sumar ventas del período anterior (sin cambios)
    SELECT COALESCE(SUM(total_venta), 0) INTO v_ventas_anteriores
    FROM (
        SELECT ven_fis_total AS total_venta FROM public.venta_fisica WHERE ven_fis_fecha BETWEEN v_fecha_inicio_anterior AND v_fecha_fin_anterior
        UNION ALL
        SELECT ven_onl_total AS total_venta FROM public.venta_online WHERE ven_onl_fecha BETWEEN v_fecha_inicio_anterior AND v_fecha_fin_anterior
    ) AS ventas;

    -- Calcular el crecimiento (sin cambios)
    v_crecimiento_monto := v_ventas_actuales - v_ventas_anteriores;
    IF v_ventas_anteriores > 0 THEN
        v_crecimiento_porcentaje := (v_crecimiento_monto / v_ventas_anteriores) * 100;
    ELSE
        v_crecimiento_porcentaje := 0;
    END IF;

    -- Construir el JSON de respuesta (sin cambios)
    RETURN json_build_object(
        'periodo_actual_ventas', v_ventas_actuales,
        'periodo_anterior_ventas', v_ventas_anteriores,
        'crecimiento_monto', v_crecimiento_monto,
        'crecimiento_porcentaje', v_crecimiento_porcentaje
    );
END;
$$ LANGUAGE plpgsql;


-- ticket promedio
CREATE OR REPLACE FUNCTION public.kpi_ticket_promedio(
    p_fecha_inicio DATE,
    p_fecha_fin DATE
)
RETURNS JSON AS $$
DECLARE
    v_total_ingresos NUMERIC;
    v_total_transacciones INT;
    v_ticket_promedio NUMERIC;
BEGIN
    -- 1. Calcular el total de ingresos (físicos + online)
    SELECT COALESCE(SUM(total_venta), 0) INTO v_total_ingresos
    FROM (
        SELECT ven_fis_total AS total_venta FROM public.venta_fisica WHERE ven_fis_fecha BETWEEN p_fecha_inicio AND p_fecha_fin
        UNION ALL
        SELECT ven_onl_total AS total_venta FROM public.venta_online WHERE ven_onl_fecha BETWEEN p_fecha_inicio AND p_fecha_fin
    ) AS ventas;

    -- 2. Contar el número total de transacciones (físicas + online)
    SELECT COALESCE(SUM(num_transacciones), 0) INTO v_total_transacciones
    FROM (
        SELECT COUNT(*) as num_transacciones FROM public.venta_fisica WHERE ven_fis_fecha BETWEEN p_fecha_inicio AND p_fecha_fin
        UNION ALL
        SELECT COUNT(*) as num_transacciones FROM public.venta_online WHERE ven_onl_fecha BETWEEN p_fecha_inicio AND p_fecha_fin
    ) AS transacciones;

    -- 3. Calcular el ticket promedio, evitando la división por cero
    v_ticket_promedio := v_total_ingresos / NULLIF(v_total_transacciones, 0);

    -- 4. Construir el objeto JSON con el resultado
    RETURN json_build_object(
        'ticket_promedio', v_ticket_promedio
    );
END;
$$ LANGUAGE plpgsql;


--volumen de ventas
CREATE OR REPLACE FUNCTION public.kpi_volumen_unidades_vendidas(
    p_fecha_inicio DATE,
    p_fecha_fin DATE
)
RETURNS JSON AS $$
DECLARE
    v_total_unidades INT;
BEGIN
    SELECT COALESCE(SUM(cantidad_unidades), 0) INTO v_total_unidades
    FROM (
        -- Unidades de ventas físicas
        SELECT SUM(dvf.det_ven_fis_cantidad) as cantidad_unidades
        FROM public.detalle_venta_fisica dvf
        JOIN public.venta_fisica vf ON dvf.fk_venta_fisica = vf.ven_fis_id
        WHERE vf.ven_fis_fecha BETWEEN p_fecha_inicio AND p_fecha_fin
        
        UNION ALL
        
        -- Unidades de ventas online
        SELECT SUM(dvo.det_ven_onl_cantidad) as cantidad_unidades
        FROM public.detalle_venta_online dvo
        JOIN public.venta_online vo ON dvo.fk_venta_online = vo.ven_onl_id
        WHERE vo.ven_onl_fecha BETWEEN p_fecha_inicio AND p_fecha_fin
    ) AS unidades;

    RETURN json_build_object(
        'total_unidades', v_total_unidades
    );
END;
$$ LANGUAGE plpgsql;

--venta por estilo de cerveza
CREATE OR REPLACE FUNCTION public.kpi_ventas_por_estilo(
    p_fecha_inicio DATE,
    p_fecha_fin DATE
)
RETURNS JSON AS $$
DECLARE
    v_reporte_data JSON;
BEGIN
    WITH
    -- Paso 1: Agrupar ventas FÍSICAS por estilo
    fisicas_por_estilo AS (
        SELECT
            ec.est_cer_nombre AS estilo,
            SUM(d.det_ven_fis_cantidad) AS total_unidades,
            SUM(d.det_ven_fis_cantidad * d.det_ven_fis_precio_unitario) AS total_ingresos
        FROM public.detalle_venta_fisica d
        JOIN public.venta_fisica v ON d.fk_venta_fisica = v.ven_fis_id
        JOIN public.inventario i ON d.fk_inventario = i.inv_id
        JOIN public.presentacion p ON i.fk_presentacion = p.prese_id
        JOIN public.cerveza c ON p.fk_cerveza = c.cer_id
        -- ✅ CORRECCIÓN DEFINITIVA: Se usa la ruta de unión correcta a través de "tipo_estilo_cerveza"
        JOIN public.tipo_estilo_cerveza tec ON c.fk_tipo_estilo_cerveza = tec.tip_est_cer_id
        JOIN public.estilo_cerveza ec ON tec.fk_estilo_cerveza = ec.est_cer_id
        WHERE v.ven_fis_fecha BETWEEN p_fecha_inicio AND p_fecha_fin
        GROUP BY ec.est_cer_nombre
    ),
    -- Paso 2: Agrupar ventas ONLINE por estilo
    online_por_estilo AS (
        SELECT
            ec.est_cer_nombre AS estilo,
            SUM(d.det_ven_onl_cantidad) AS total_unidades,
            SUM(d.det_ven_onl_cantidad * d.det_ven_onl_precio) AS total_ingresos
        FROM public.detalle_venta_online d
        JOIN public.venta_online v ON d.fk_venta_online = v.ven_onl_id
        JOIN public.pre_alm pa ON d.fk_pre_alm = pa.pre_alm_id
        JOIN public.presentacion p ON pa.fk_presentacion = p.prese_id
        JOIN public.cerveza c ON p.fk_cerveza = c.cer_id
        -- ✅ CORRECCIÓN DEFINITIVA: Se usa la ruta de unión correcta a través de "tipo_estilo_cerveza"
        JOIN public.tipo_estilo_cerveza tec ON c.fk_tipo_estilo_cerveza = tec.tip_est_cer_id
        JOIN public.estilo_cerveza ec ON tec.fk_estilo_cerveza = ec.est_cer_id
        WHERE v.ven_onl_fecha BETWEEN p_fecha_inicio AND p_fecha_fin
        GROUP BY ec.est_cer_nombre
    )
    -- Paso 3: Unir los resultados de ambos canales
    SELECT COALESCE(json_agg(
        json_build_object(
            'estilo', final.estilo,
            'total_unidades', final.total_unidades,
            'total_ingresos', final.total_ingresos
        ) ORDER BY final.total_ingresos DESC
    ), '[]'::json)
    INTO v_reporte_data
    FROM (
        SELECT
            COALESCE(f.estilo, o.estilo) AS estilo,
            COALESCE(f.total_unidades, 0) + COALESCE(o.total_unidades, 0) AS total_unidades,
            COALESCE(f.total_ingresos, 0) + COALESCE(o.total_ingresos, 0) AS total_ingresos
        FROM fisicas_por_estilo f
        FULL OUTER JOIN online_por_estilo o ON f.estilo = o.estilo
    ) AS final;

    RETURN v_reporte_data;
END;
$$ LANGUAGE plpgsql;


-- indicadores de clietes
-- Clientes Nuevos vs. Recurrentes
CREATE OR REPLACE FUNCTION public.kpi_clientes_nuevos_recurrentes(
    p_fecha_inicio DATE,
    p_fecha_fin DATE
)
RETURNS JSON AS $$
DECLARE
    v_reporte_data JSON;
BEGIN
    WITH
    -- 1. Se unifican todas las ventas (físicas y online) para obtener un historial completo por cliente.
    historial_ventas_cliente AS (
        SELECT fk_cliente, ven_fis_fecha AS fecha FROM public.venta_fisica
        UNION ALL
        SELECT u.fk_cliente, vo.ven_onl_fecha AS fecha FROM public.venta_online vo JOIN public.usuario u ON vo.fk_usuario = u.id WHERE u.fk_cliente IS NOT NULL
    ),
    -- 2. Se encuentra la fecha de la primera compra de cada cliente en toda la historia.
    primera_compra_por_cliente AS (
        SELECT fk_cliente, MIN(fecha) as fecha_primera_compra
        FROM historial_ventas_cliente
        GROUP BY fk_cliente
    ),
    -- 3. Se obtiene una lista de clientes únicos que compraron en el período seleccionado.
    clientes_periodo_actual AS (
        SELECT DISTINCT fk_cliente FROM historial_ventas_cliente
        WHERE fecha BETWEEN p_fecha_inicio AND p_fecha_fin
    )
    -- 4. Se cruza la información para clasificar a los clientes.
    SELECT
        json_build_object(
            -- Clientes nuevos: su primera compra está DENTRO del período seleccionado.
            'clientes_nuevos', COUNT(*) FILTER (WHERE pcp.fecha_primera_compra BETWEEN p_fecha_inicio AND p_fecha_fin),
            -- Clientes recurrentes: su primera compra fue ANTES del período seleccionado.
            'clientes_recurrentes', COUNT(*) FILTER (WHERE pcp.fecha_primera_compra < p_fecha_inicio)
        )
    INTO v_reporte_data
    FROM clientes_periodo_actual cpa
    JOIN primera_compra_por_cliente pcp ON cpa.fk_cliente = pcp.fk_cliente;

    RETURN v_reporte_data;
END;
$$ LANGUAGE plpgsql;


-- Tasa de Retención de Clientes
CREATE OR REPLACE FUNCTION public.kpi_tasa_retencion_clientes(
    p_fecha_inicio DATE,
    p_fecha_fin DATE
)
RETURNS JSON AS $$
DECLARE
    v_reporte_data JSON;
    v_duracion_periodo INT;
    v_fecha_inicio_anterior DATE;
    v_fecha_fin_anterior DATE;
    v_clientes_periodo_anterior INT;
    v_clientes_retenidos INT;
    v_tasa_retencion NUMERIC;
BEGIN
    -- 1. Calcular duración y fechas del período anterior
    v_duracion_periodo := p_fecha_fin - p_fecha_inicio;
    v_fecha_fin_anterior := p_fecha_inicio - INTERVAL '1 day';
    v_fecha_inicio_anterior := v_fecha_fin_anterior - (v_duracion_periodo || ' days')::INTERVAL;

    -- 2. Unificar todas las ventas para facilitar las consultas
    WITH historial_ventas_cliente AS (
        SELECT fk_cliente, ven_fis_fecha AS fecha FROM public.venta_fisica
        UNION ALL
        SELECT u.fk_cliente, vo.ven_onl_fecha AS fecha FROM public.venta_online vo JOIN public.usuario u ON vo.fk_usuario = u.id WHERE u.fk_cliente IS NOT NULL
    ),
    -- 3. Obtener clientes únicos del período anterior
    clientes_anteriores AS (
        SELECT DISTINCT fk_cliente
        FROM historial_ventas_cliente
        WHERE fecha BETWEEN v_fecha_inicio_anterior AND v_fecha_fin_anterior
    ),
    -- 4. Obtener clientes únicos del período actual
    clientes_actuales AS (
        SELECT DISTINCT fk_cliente
        FROM historial_ventas_cliente
        WHERE fecha BETWEEN p_fecha_inicio AND p_fecha_fin
    )
    -- 5. Calcular la cantidad de clientes del período anterior y cuántos de ellos repitieron compra
    SELECT
        COUNT(ca.fk_cliente),
        COUNT(ca.fk_cliente) FILTER (WHERE ca.fk_cliente IN (SELECT fk_cliente FROM clientes_actuales))
    INTO
        v_clientes_periodo_anterior,
        v_clientes_retenidos
    FROM clientes_anteriores ca;

    -- 6. Calcular la tasa de retención, evitando la división por cero
    v_tasa_retencion := (v_clientes_retenidos::NUMERIC / NULLIF(v_clientes_periodo_anterior, 0)) * 100;

    -- 7. Construir el objeto JSON
    SELECT
        json_build_object(
            'clientes_periodo_anterior', v_clientes_periodo_anterior,
            'clientes_retenidos', v_clientes_retenidos,
            'tasa_retencion', v_tasa_retencion
        )
    INTO v_reporte_data;

    RETURN v_reporte_data;
END;
$$ LANGUAGE plpgsql;


-- rotacion de inventario
CREATE OR REPLACE FUNCTION public.kpi_rotacion_inventario(
    p_fecha_inicio DATE,
    p_fecha_fin DATE
)
RETURNS JSON AS $$
DECLARE
    v_cogs NUMERIC;
    v_valor_inventario_actual NUMERIC;
    v_rotacion NUMERIC;
BEGIN
    -- 1. Calcular el Costo de los Productos Vendidos (COGS) en el período
    SELECT COALESCE(SUM(costo_total), 0) INTO v_cogs
    FROM (
        -- Costo de ventas físicas
        SELECT SUM(d.det_ven_fis_cantidad * i.inv_precio_unitario) as costo_total
        FROM public.detalle_venta_fisica d
        JOIN public.venta_fisica v ON d.fk_venta_fisica = v.ven_fis_id
        JOIN public.inventario i ON d.fk_inventario = i.inv_id
        WHERE v.ven_fis_fecha BETWEEN p_fecha_inicio AND p_fecha_fin
        
        UNION ALL
        
        -- Costo de ventas online
        SELECT SUM(d.det_ven_onl_cantidad * pa.pre_alm_precio) as costo_total
        FROM public.detalle_venta_online d
        JOIN public.venta_online v ON d.fk_venta_online = v.ven_onl_id
        JOIN public.pre_alm pa ON d.fk_pre_alm = pa.pre_alm_id
        WHERE v.ven_onl_fecha BETWEEN p_fecha_inicio AND p_fecha_fin
    ) AS costos;

    -- 2. Calcular el Valor Total del Inventario Actual (físico + almacén)
    SELECT COALESCE(SUM(valor_total), 0) INTO v_valor_inventario_actual
    FROM (
        -- Valor en anaqueles
        SELECT SUM(inv_cantidad * inv_precio_unitario) as valor_total FROM public.inventario
        UNION ALL
        -- Valor en almacén principal
        SELECT SUM(pre_alm_cantidad * pre_alm_precio) as valor_total FROM public.pre_alm
    ) AS inventario_total;

    -- 3. Calcular la tasa de rotación, evitando la división por cero
    v_rotacion := v_valor_inventario_actual / NULLIF(v_cogs, 0);

    -- 4. Construir el objeto JSON con los resultados
    RETURN json_build_object(
        'costo_productos_vendidos', v_cogs,
        'valor_inventario_actual', v_valor_inventario_actual,
        'tasa_rotacion', v_rotacion
    );
END;
$$ LANGUAGE plpgsql;

-- tasa de ruptura
CREATE OR REPLACE FUNCTION public.kpi_tasa_ruptura_stock()
RETURNS JSON AS $$
DECLARE
    v_total_productos INT;
    v_productos_sin_stock INT;
    v_tasa_ruptura NUMERIC;
BEGIN
    -- 1. Contar el total de productos únicos en el inventario (anaquel + almacén)
    SELECT COUNT(DISTINCT fk_presentacion)
    INTO v_total_productos
    FROM (
        SELECT fk_presentacion FROM public.inventario
        UNION
        SELECT fk_presentacion FROM public.pre_alm
    ) as todos_los_productos;

    -- 2. Contar el número de productos únicos con stock <= 0
    SELECT COUNT(DISTINCT fk_presentacion)
    INTO v_productos_sin_stock
    FROM (
        SELECT fk_presentacion FROM public.inventario WHERE inv_cantidad <= 0
        UNION
        SELECT fk_presentacion FROM public.pre_alm WHERE pre_alm_cantidad <= 0
    ) as productos_agotados;

    -- 3. Calcular la tasa de ruptura, evitando la división por cero
    v_tasa_ruptura := (v_productos_sin_stock::NUMERIC / NULLIF(v_total_productos, 0)) * 100;

    -- 4. Construir el objeto JSON con los resultados
    RETURN json_build_object(
        'total_productos', v_total_productos,
        'productos_sin_stock', v_productos_sin_stock,
        'tasa_ruptura', v_tasa_ruptura
    );
END;
$$ LANGUAGE plpgsql;

--grafico de tendencia de ventas
CREATE OR REPLACE FUNCTION public.grafico_tendencia_ventas(
    p_fecha_inicio DATE,
    p_fecha_fin DATE,
    p_agrupacion TEXT DEFAULT 'dia'
)
RETURNS JSON AS $$
DECLARE
    v_reporte_data JSON;
BEGIN
    -- Se utiliza una estructura IF/ELSIF para construir la consulta de forma segura,
    -- usando literales de texto para los intervalos ('day', 'week', 'month').
    
    IF p_agrupacion = 'mes' THEN
        -- Lógica para agrupar por MES
        WITH ventas_unificadas AS (
            SELECT ven_fis_fecha AS fecha, ven_fis_total AS total FROM public.venta_fisica
            UNION ALL
            SELECT ven_onl_fecha AS fecha, ven_onl_total AS total FROM public.venta_online
        ),
        ventas_agrupadas AS (
            SELECT date_trunc('month', fecha)::DATE AS fecha_agrupada, SUM(total) AS total_ventas
            FROM ventas_unificadas WHERE fecha BETWEEN p_fecha_inicio AND p_fecha_fin
            GROUP BY fecha_agrupada
        ),
        serie_tiempo AS (
            SELECT generate_series(date_trunc('month', p_fecha_inicio)::DATE, p_fecha_fin, '1 month')::DATE AS fecha_serie
        )
        SELECT COALESCE(json_agg(json_build_object('fecha', TO_CHAR(st.fecha_serie, 'YYYY-MM-DD'), 'total_ventas', COALESCE(va.total_ventas, 0)) ORDER BY st.fecha_serie), '[]'::json)
        INTO v_reporte_data
        FROM serie_tiempo st
        LEFT JOIN ventas_agrupadas va ON st.fecha_serie = va.fecha_agrupada;

    ELSIF p_agrupacion = 'semana' THEN
        -- Lógica para agrupar por SEMANA
        WITH ventas_unificadas AS (
            SELECT ven_fis_fecha AS fecha, ven_fis_total AS total FROM public.venta_fisica
            UNION ALL
            SELECT ven_onl_fecha AS fecha, ven_onl_total AS total FROM public.venta_online
        ),
        ventas_agrupadas AS (
            SELECT date_trunc('week', fecha)::DATE AS fecha_agrupada, SUM(total) AS total_ventas
            FROM ventas_unificadas WHERE fecha BETWEEN p_fecha_inicio AND p_fecha_fin
            GROUP BY fecha_agrupada
        ),
        serie_tiempo AS (
            SELECT generate_series(date_trunc('week', p_fecha_inicio)::DATE, p_fecha_fin, '1 week')::DATE AS fecha_serie
        )
        SELECT COALESCE(json_agg(json_build_object('fecha', TO_CHAR(st.fecha_serie, 'YYYY-MM-DD'), 'total_ventas', COALESCE(va.total_ventas, 0)) ORDER BY st.fecha_serie), '[]'::json)
        INTO v_reporte_data
        FROM serie_tiempo st
        LEFT JOIN ventas_agrupadas va ON st.fecha_serie = va.fecha_agrupada;

    ELSE -- El caso por defecto es agrupar por DÍA
        WITH ventas_unificadas AS (
            SELECT ven_fis_fecha AS fecha, ven_fis_total AS total FROM public.venta_fisica
            UNION ALL
            SELECT ven_onl_fecha AS fecha, ven_onl_total AS total FROM public.venta_online
        ),
        ventas_agrupadas AS (
            SELECT date_trunc('day', fecha)::DATE AS fecha_agrupada, SUM(total) AS total_ventas
            FROM ventas_unificadas WHERE fecha BETWEEN p_fecha_inicio AND p_fecha_fin
            GROUP BY fecha_agrupada
        ),
        serie_tiempo AS (
            SELECT generate_series(date_trunc('day', p_fecha_inicio)::DATE, p_fecha_fin, '1 day')::DATE AS fecha_serie
        )
        SELECT COALESCE(json_agg(json_build_object('fecha', TO_CHAR(st.fecha_serie, 'YYYY-MM-DD'), 'total_ventas', COALESCE(va.total_ventas, 0)) ORDER BY st.fecha_serie), '[]'::json)
        INTO v_reporte_data
        FROM serie_tiempo st
        LEFT JOIN ventas_agrupadas va ON st.fecha_serie = va.fecha_agrupada;
    END IF;

    RETURN v_reporte_data;
END;
$$ LANGUAGE plpgsql;

--productos más vendidos
CREATE OR REPLACE FUNCTION public.kpi_productos_mas_vendidos(
    p_fecha_inicio DATE,
    p_fecha_fin DATE
)
RETURNS JSON AS $$
DECLARE
    v_reporte_data JSON;
BEGIN
    WITH
    -- Paso 1: Se unifican los detalles de todas las ventas (físicas y online)
    ventas_detalladas AS (
        SELECT
            i.fk_presentacion,
            d.det_ven_fis_cantidad AS cantidad,
            d.det_ven_fis_precio_unitario AS precio
        FROM public.detalle_venta_fisica d
        JOIN public.venta_fisica v ON d.fk_venta_fisica = v.ven_fis_id
        JOIN public.inventario i ON d.fk_inventario = i.inv_id
        WHERE v.ven_fis_fecha BETWEEN p_fecha_inicio AND p_fecha_fin

        UNION ALL

        SELECT
            pa.fk_presentacion,
            d.det_ven_onl_cantidad AS cantidad,
            d.det_ven_onl_precio AS precio
        FROM public.detalle_venta_online d
        JOIN public.venta_online v ON d.fk_venta_online = v.ven_onl_id
        JOIN public.pre_alm pa ON d.fk_pre_alm = pa.pre_alm_id
        WHERE v.ven_onl_fecha BETWEEN p_fecha_inicio AND p_fecha_fin
    ),
    -- Paso 2: Se calculan los totales y se obtiene el Top 10 de productos
    top_productos AS (
        SELECT
            fk_presentacion,
            SUM(cantidad) as unidades_vendidas,
            SUM(cantidad * precio) as ingresos_totales
        FROM ventas_detalladas
        GROUP BY fk_presentacion
        ORDER BY ingresos_totales DESC
        LIMIT 10
    )
    -- Paso 3: Se unen los resultados con la tabla de presentación para obtener los nombres y se construye el JSON
    SELECT COALESCE(json_agg(
        json_build_object(
            'producto_id', p.prese_id,
            'producto_nombre', p.prese_nombre,
            'unidades_vendidas', tp.unidades_vendidas,
            'ingresos_totales', tp.ingresos_totales
        ) ORDER BY tp.ingresos_totales DESC
    ), '[]'::json)
    INTO v_reporte_data
    FROM top_productos tp
    JOIN public.presentacion p ON tp.fk_presentacion = p.prese_id;

    RETURN v_reporte_data;
END;
$$ LANGUAGE plpgsql;

--inventario actual
-- ✅ NUEVA FUNCIÓN: Para obtener la lista de todas las tiendas
CREATE OR REPLACE FUNCTION public.obtener_lista_tiendas()
RETURNS JSON AS $$
BEGIN
    RETURN (
        SELECT COALESCE(json_agg(
            json_build_object(
                'id', tie_id,
                'nombre', tie_nombre
            ) ORDER BY tie_nombre
        ), '[]'::json)
        FROM public.tienda
    );
END;
$$ LANGUAGE plpgsql;


-- ✅ FUNCIÓN MODIFICADA: Ahora filtra tanto el inventario de la tienda como el del almacén.
CREATE OR REPLACE FUNCTION public.reporte_stock_por_presentacion(
    p_tienda_id INT, -- ID de la tienda para filtrar. Si es 0, muestra el total de todas las tiendas.
    p_limite INT DEFAULT 10,
    p_offset INT DEFAULT 0
)
RETURNS JSON AS $$
DECLARE
    v_reporte_data JSON;
BEGIN
    WITH
    -- Se calcula el stock en la tienda física seleccionada
    stock_tienda_seleccionada AS (
        SELECT
            i.fk_presentacion,
            SUM(i.inv_cantidad) AS total_tienda
        FROM public.inventario i
        JOIN public.anaquel a ON i.fk_anaquel = a.ana_id
        JOIN public.lugar_tienda lt ON a.fk_lugar_tienda = lt.lug_tie_id
        WHERE (p_tienda_id = 0 OR lt.fk_tienda = p_tienda_id)
        GROUP BY i.fk_presentacion
    ),
    -- Se calcula el stock del almacén online asociado a la tienda
    stock_almacen AS (
        SELECT
            pa.fk_presentacion,
            SUM(pa.pre_alm_cantidad) AS total_almacen
        FROM public.pre_alm pa
        JOIN public.almacen a ON pa.fk_almacen = a.alm_id
        WHERE (p_tienda_id = 0 OR a.fk_tienda = p_tienda_id)
        GROUP BY pa.fk_presentacion
    ),
    -- Se unen los resultados
    full_stock_list AS (
        SELECT
            p.prese_id,
            p.prese_nombre,
            COALESCE(st.total_tienda, 0) AS stock_tienda_seleccionada,
            COALESCE(sa.total_almacen, 0) AS stock_almacen
        FROM public.presentacion p
        LEFT JOIN stock_tienda_seleccionada st ON p.prese_id = st.fk_presentacion
        LEFT JOIN stock_almacen sa ON p.prese_id = sa.fk_presentacion
    )
    -- Se construye el JSON final
    SELECT json_build_object(
        'total_count', (SELECT COUNT(*) FROM full_stock_list),
        'productos', (
            SELECT COALESCE(json_agg(t.*), '[]'::json)
            FROM (
                SELECT * FROM full_stock_list
                ORDER BY prese_nombre
                LIMIT p_limite OFFSET p_offset
            ) t
        )
    )
    INTO v_reporte_data;

    RETURN v_reporte_data;
END;
$$ LANGUAGE plpgsql;