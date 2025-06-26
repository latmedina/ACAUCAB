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

-- factura de venta física
CREATE OR REPLACE FUNCTION public.obtener_datos_reporte_venta(p_venta_id INT)
RETURNS JSON AS $$
DECLARE
    v_reporte_data JSON;
BEGIN
    SELECT
        -- Construye el objeto JSON principal
        json_build_object(
            -- Sección 'venta': contiene datos generales y totales de la factura
            'venta', json_build_object(
                'id', vf.ven_fis_id,
                'fecha', TO_CHAR(vf.ven_fis_fecha, 'DD/MM/YYYY'),
                'subtotal', vf.ven_fis_total / 1.16, -- Calcula la base imponible (asumiendo IVA 16%)
                'iva', vf.ven_fis_total - (vf.ven_fis_total / 1.16), -- Calcula el monto del IVA
                'total', vf.ven_fis_total
            ),
            -- Sección 'cliente': información del cliente que realizó la compra
            'cliente', json_build_object(
                'nombre', COALESCE(c.cli_nat_pnombre || ' ' || c.cli_nat_papellido, c.cli_jur_razon_social, 'No disponible'),
                'rif', COALESCE(c.cli_rif, 'N/A'),
                'direccion', COALESCE(c.cli_direccion_fisica, 'N/A'),
                'telefono', (SELECT tel_numero::text FROM public.telefono WHERE fk_cliente = c.cli_id LIMIT 1) -- Subconsulta para obtener un teléfono
            ),
            -- Sección 'tienda': datos de la tienda donde se realizó la venta
            'tienda', json_build_object(
                'nombre', COALESCE(t.tie_nombre, 'No disponible'),
                'direccion', COALESCE(t.tie_direccion, 'N/A')
            ),
            -- Sección 'detalles': una lista (array) de todos los productos en la venta
            'detalles', (
                SELECT COALESCE(json_agg(
                    json_build_object(
                        'id', p.prese_id, -- ID del producto/presentación
                        'producto', p.prese_nombre,
                        'cantidad', dvf.det_ven_fis_cantidad,
                        'precio_unitario', dvf.det_ven_fis_precio_unitario,
                        'total_linea', dvf.det_ven_fis_cantidad * dvf.det_ven_fis_precio_unitario
                    )
                ), '[]'::json) -- Si no hay detalles, devuelve un array JSON vacío
                FROM public.detalle_venta_fisica dvf
                JOIN public.inventario i ON dvf.fk_inventario = i.inv_id
                JOIN public.presentacion p ON i.fk_presentacion = p.prese_id
                WHERE dvf.fk_venta_fisica = vf.ven_fis_id
            )
        )
    INTO v_reporte_data
    FROM public.venta_fisica vf
    -- Usamos LEFT JOIN para ser más robustos
    LEFT JOIN public.cliente c ON vf.fk_cliente = c.cli_id
    LEFT JOIN public.tienda t ON vf.fk_tienda = t.tie_id
    WHERE vf.ven_fis_id = p_venta_id;

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
               'Entrada pautada: ' || hora_entrada_pautada || ', Entrada real: ' || hora_entrada_real AS detalle,
               diferencia_entrada AS duracion
        FROM incidencias WHERE tipo_incidencia_entrada IS NOT NULL
        UNION ALL
        SELECT fk_empleado, empleado_nombre, fecha, 'Salida Temprano' AS tipo,
               'Salida pautada: ' || hora_salida_pautada || ', Salida real: ' || hora_salida_real AS detalle,
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
                    'detalle', detalle,
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
                'solicitado_por', u.username,
                'total_orden', sc.sol_com_total
            )
        ), '[]'::json)
    INTO v_reporte_data
    FROM public.solicitud_compra sc
    -- Se une con la CTE que contiene el análisis de los estados.
    JOIN estados_por_solicitud eps ON sc.sol_com_id = eps.fk_sol_com
    -- Se unen las tablas de proveedor y usuario para obtener sus nombres.
    LEFT JOIN public.proveedor p ON sc.fk_proveedor = p.pro_id
    LEFT JOIN public.usuario u ON sc.fk_usuario = u.id
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
    -- Se unifican todas las ventas en una sola tabla temporal
    todas_las_ventas AS (
        -- Ventas Físicas
        SELECT
            vf.ven_fis_id AS id_venta,
            vf.ven_fis_fecha::DATE AS fecha,
            vf.ven_fis_total AS total,
            'Venta en Tienda' AS tipo_compra
        FROM public.venta_fisica vf
        WHERE vf.fk_cliente = p_cliente_id

        UNION ALL

        -- Ventas Online
        SELECT
            vo.ven_onl_id AS id_venta,
            vo.ven_onl_fecha::DATE AS fecha,
            vo.ven_onl_total AS total,
            'Pedido Online' AS tipo_compra
        FROM public.venta_online vo
        JOIN public.usuario u ON vo.fk_usuario = u.id
        WHERE u.fk_cliente = p_cliente_id

        UNION ALL

        -- Ventas en Eventos
        SELECT
            ve.ven_eve_id AS id_venta,
            ve.ven_eve_fecha_hora::DATE AS fecha,
            ve.ven_eve_monto_total AS total,
            'Compra en Evento' AS tipo_compra
        FROM public.venta_evento ve
        WHERE ve.fk_cliente = p_cliente_id
    )
    -- Se construye el JSON final a partir de la tabla unificada
    SELECT
        COALESCE(json_agg(
            json_build_object(
                'id_venta', tv.id_venta,
                'fecha_compra', TO_CHAR(tv.fecha, 'DD/MM/YYYY'),
                'monto_total', tv.total,
                'tipo_compra', tv.tipo_compra,
                -- Se añade un campo para saber a qué URL apuntar para la factura
                'tipo_factura', CASE 
                                    WHEN tv.tipo_compra = 'Venta en Tienda' THEN 'fisica'
                                    WHEN tv.tipo_compra = 'Pedido Online' THEN 'online'
                                    ELSE 'evento'
                                END
            ) ORDER BY tv.fecha DESC
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
                'solicitado_por', u.username,
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


