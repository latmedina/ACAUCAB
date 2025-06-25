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